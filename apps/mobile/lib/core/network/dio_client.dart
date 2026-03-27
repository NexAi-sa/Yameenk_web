library;

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _supabaseUrl = 'https://bnmvuaqxcmdycpyojfbg.supabase.co';
const _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
const _baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: '$_supabaseUrl/rest/v1',
);
const _functionsUrl = '$_supabaseUrl/functions/v1';

typedef OnSessionExpired = void Function();

class DioClient {
  late final Dio rest;
  late final Dio functions;

  final _storage = const FlutterSecureStorage();
  OnSessionExpired? onSessionExpired;
  bool _isLoggingOut = false;

  DioClient({this.onSessionExpired}) {
    rest = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'apikey': _supabaseAnonKey,
      },
    ));

    rest.interceptors.add(InterceptorsWrapper(
      onRequest: _attachToken,
      onError: _handleError,
    ));

    functions = Dio(BaseOptions(
      baseUrl: _functionsUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_supabaseAnonKey',
      },
    ));

    functions.interceptors.add(InterceptorsWrapper(
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

  Future<void> _triggerSessionExpired() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;
    await _storage.deleteAll();
    onSessionExpired?.call();
  }
}
