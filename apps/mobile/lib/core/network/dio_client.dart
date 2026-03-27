library;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/supabase_config.dart';

const _baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: '$supabaseUrl/rest/v1',
);
const _functionsUrl = '$supabaseUrl/functions/v1';

/// NestJS backend API URL for privacy, consent, and other managed endpoints.
const _nestjsApiUrl = String.fromEnvironment(
  'NESTJS_API_URL',
  defaultValue: '$supabaseUrl/functions/v1/api',
);

typedef OnSessionExpired = void Function();

class DioClient {
  late final Dio rest;
  late final Dio functions;

  /// Dedicated Dio instance for NestJS backend API (privacy, consent, etc.)
  late final Dio api;

  final _storage = const FlutterSecureStorage();
  OnSessionExpired? onSessionExpired;
  bool _isLoggingOut = false;
  bool _isRefreshing = false;

  DioClient({this.onSessionExpired}) {
    rest = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'apikey': supabaseAnonKey,
      },
    ));

    rest.interceptors.add(InterceptorsWrapper(
      onRequest: _attachToken,
      onError: _handleRestError,
    ));

    functions = Dio(BaseOptions(
      baseUrl: _functionsUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        'apikey': supabaseAnonKey,
      },
    ));

    // ✅ FIX: Attach user JWT to functions Dio (was missing — chat/reports
    //    were sent without user identity)
    functions.interceptors.add(InterceptorsWrapper(
      onRequest: _attachToken,
      onError: _handleError,
    ));

    // NestJS API client for privacy/consent endpoints
    api = Dio(BaseOptions(
      baseUrl: _nestjsApiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'apikey': supabaseAnonKey,
      },
    ));

    api.interceptors.add(InterceptorsWrapper(
      onRequest: _attachToken,
      onError: _handleError,
    ));
  }

  Future<void> _attachToken(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: 'access_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  /// REST-specific error handler that attempts token refresh on 401.
  Future<void> _handleRestError(
    DioException e,
    ErrorInterceptorHandler handler,
  ) async {
    // Attempt token refresh on 401 (non-auth endpoints)
    if (e.response?.statusCode == 401 &&
        !e.requestOptions.path.contains('/auth/')) {
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        // Retry the original request with the new token
        try {
          final token = await _storage.read(key: 'access_token');
          final opts = e.requestOptions;
          opts.headers['Authorization'] = 'Bearer $token';
          final response = await rest.fetch(opts);
          return handler.resolve(response);
        } catch (_) {
          // Retry failed — fall through to session expired
        }
      }
      _triggerSessionExpired();
    }
    _handleError(e, handler);
  }

  void _handleError(DioException e, ErrorInterceptorHandler handler) {
    if (e.response?.statusCode == 401 &&
        !e.requestOptions.path.contains('/auth/')) {
      _triggerSessionExpired();
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      handler.reject(DioException(
        requestOptions: e.requestOptions,
        type: e.type,
        error: 'تعذّر الاتصال بالخادم — تحقق من الاتصال بالإنترنت',
      ));
      return;
    }
    handler.next(e);
  }

  /// Attempt to refresh the access token using the stored refresh_token.
  Future<bool> _tryRefreshToken() async {
    if (_isRefreshing) return false;
    _isRefreshing = true;
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null || refreshToken.isEmpty) return false;

      final dio = Dio(BaseOptions(
        baseUrl: '$supabaseUrl/auth/v1',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'apikey': supabaseAnonKey,
        },
      ));

      final res = await dio.post(
        '/token?grant_type=refresh_token',
        data: {'refresh_token': refreshToken},
      );

      final data = res.data as Map<String, dynamic>;
      final newToken = data['access_token'] as String?;
      final newRefresh = data['refresh_token'] as String?;

      if (newToken != null && newToken.isNotEmpty) {
        await _storage.write(key: 'access_token', value: newToken);
        if (newRefresh != null && newRefresh.isNotEmpty) {
          await _storage.write(key: 'refresh_token', value: newRefresh);
        }
        debugPrint('🔄 Token refreshed successfully');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Token refresh failed: $e');
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _triggerSessionExpired() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;
    await _storage.deleteAll();
    onSessionExpired?.call();
  }
}
