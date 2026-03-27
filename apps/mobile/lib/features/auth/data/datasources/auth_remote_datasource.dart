library;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';

abstract class AuthRemoteDataSource {
  Future<void> requestOtp(String phone);
  Future<Map<String, dynamic>> verifyOtp(String phone, String code);
  Future<Map<String, dynamic>> register(
      String name, String email, String password);
  Future<Map<String, dynamic>> loginWithEmail(String email, String password);
  Future<bool> hasCompletedConsent();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _client;
  final _storage = const FlutterSecureStorage();
  static const _consentKey = 'pdpl_consent_completed';

  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<void> requestOtp(String phone) async {
    try {
      await _client.rest.post('/auth/otp/request', data: {'phone': phone});
    } catch (e) {
      debugPrint('OTP request error: $e');
      throw const ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(String phone, String code) async {
    try {
      final res = await _client.rest.post(
        '/auth/otp/verify',
        data: {'phone': phone, 'code': code},
      );
      final data = res.data as Map<String, dynamic>;
      await _storage.write(
          key: 'access_token', value: data['access_token'] as String);
      if (data.containsKey('patient_id')) {
        await _storage.write(
            key: 'patient_id', value: data['patient_id'] as String);
      }
      return data;
    } catch (e) {
      debugPrint('OTP verify error: $e');
      throw const ServerException('رمز التحقق غير صحيح');
    }
  }

  /// Extracts the most useful error message from a Supabase error response.
  String? _extractSupabaseError(dynamic body) {
    if (body is! Map) return body?.toString();
    // Supabase uses different keys depending on the endpoint:
    //   signup  → "msg" or "message"
    //   token   → "error_description"
    for (final key in ['msg', 'error_description', 'message', 'error']) {
      if (body.containsKey(key) && body[key] is String) {
        return body[key] as String;
      }
    }
    return body.toString();
  }

  @override
  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final sanitizedEmail = email.trim().toLowerCase();
    debugPrint('──────── REGISTER START ────────');
    debugPrint('📧 email=$sanitizedEmail, 👤 name=$name');
    debugPrint('🔑 SUPABASE_ANON_KEY set=${supabaseAnonKey.isNotEmpty} '
        '(length=${supabaseAnonKey.length})');
    try {
      final dio = Dio(BaseOptions(
        baseUrl: '$supabaseUrl/auth/v1',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'apikey': supabaseAnonKey,
        },
      ));

      final res = await dio.post(
        '/signup',
        data: {
          'email': sanitizedEmail,
          'password': password,
          'data': {'full_name': name},
        },
      );
      final data = res.data as Map<String, dynamic>;

      debugPrint('✅ Register response [${res.statusCode}]: $data');

      // Supabase returns access_token inside the response
      final token = data['access_token'] as String?;
      if (token != null && token.isNotEmpty) {
        await _storage.write(key: 'access_token', value: token);
        debugPrint('🔐 access_token saved (length=${token.length})');
      } else {
        debugPrint('⚠️ No access_token in response — '
            'email confirmation may be required');
      }

      // Save refresh_token for automatic token renewal
      final refreshToken = data['refresh_token'] as String?;
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _storage.write(key: 'refresh_token', value: refreshToken);
        debugPrint('🔄 refresh_token saved');
      }

      // Extract user ID – Supabase nests it under "user"
      final user = data['user'] as Map<String, dynamic>?;
      final userId = user?['id'] as String?;
      if (userId != null && userId.isNotEmpty) {
        await _storage.write(key: 'patient_id', value: userId);
        debugPrint('🆔 patient_id saved: $userId');
      } else {
        debugPrint('⚠️ No user.id in response');
      }

      debugPrint('──────── REGISTER END (SUCCESS) ────────');
      return data;
    } on DioException catch (e) {
      debugPrint('❌ Register DioException [${e.response?.statusCode}]');
      debugPrint('   ➜ response.data : ${e.response?.data}');
      debugPrint('   ➜ response.headers: ${e.response?.headers}');
      debugPrint('   ➜ type: ${e.type}');
      debugPrint('   ➜ message: ${e.message}');
      final errorMessage = _extractSupabaseError(e.response?.data);
      debugPrint('   ➜ extracted error: $errorMessage');
      debugPrint('──────── REGISTER END (FAILURE) ────────');
      throw ServerException(
          errorMessage ?? 'فشل التسجيل، حاول مرة أخرى');
    } catch (e, st) {
      debugPrint('❌ Register unexpected error: $e');
      debugPrint('   ➜ stackTrace: $st');
      debugPrint('──────── REGISTER END (EXCEPTION) ────────');
      throw ServerException('فشل التسجيل: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> loginWithEmail(
      String email, String password) async {
    final sanitizedEmail = email.trim().toLowerCase();
    debugPrint('──────── LOGIN START ────────');
    debugPrint('📧 email=$sanitizedEmail');
    debugPrint('🔑 SUPABASE_ANON_KEY set=${supabaseAnonKey.isNotEmpty} '
        '(length=${supabaseAnonKey.length})');
    try {
      final dio = Dio(BaseOptions(
        baseUrl: '$supabaseUrl/auth/v1',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'apikey': supabaseAnonKey,
        },
      ));

      final res = await dio.post(
        '/token?grant_type=password',
        data: {'email': sanitizedEmail, 'password': password},
      );
      final data = res.data as Map<String, dynamic>;

      debugPrint('✅ Login response [${res.statusCode}]: $data');

      final token = data['access_token'] as String?;
      if (token != null && token.isNotEmpty) {
        await _storage.write(key: 'access_token', value: token);
        debugPrint('🔐 access_token saved (length=${token.length})');
      }

      // Save refresh_token for automatic token renewal
      final refreshToken = data['refresh_token'] as String?;
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _storage.write(key: 'refresh_token', value: refreshToken);
        debugPrint('🔄 refresh_token saved');
      }

      final user = data['user'] as Map<String, dynamic>?;
      final userId = user?['id'] as String?;
      if (userId != null && userId.isNotEmpty) {
        await _storage.write(key: 'patient_id', value: userId);
        debugPrint('🆔 patient_id saved: $userId');
      }

      debugPrint('──────── LOGIN END (SUCCESS) ────────');
      return data;
    } on DioException catch (e) {
      debugPrint('❌ Login DioException [${e.response?.statusCode}]');
      debugPrint('   ➜ response.data : ${e.response?.data}');
      debugPrint('   ➜ response.headers: ${e.response?.headers}');
      debugPrint('   ➜ type: ${e.type}');
      debugPrint('   ➜ message: ${e.message}');
      final errorMessage = _extractSupabaseError(e.response?.data);
      debugPrint('   ➜ extracted error: $errorMessage');
      debugPrint('──────── LOGIN END (FAILURE) ────────');
      throw ServerException(
          errorMessage ?? 'فشل تسجيل الدخول، حاول مرة أخرى');
    } catch (e, st) {
      debugPrint('❌ Login unexpected error: $e');
      debugPrint('   ➜ stackTrace: $st');
      debugPrint('──────── LOGIN END (EXCEPTION) ────────');
      throw ServerException('فشل تسجيل الدخول: $e');
    }
  }

  @override
  Future<bool> hasCompletedConsent() async {
    final val = await _storage.read(key: _consentKey);
    return val == 'true';
  }

  @override
  Future<void> logout() async {
    await _storage.deleteAll();
  }
}
