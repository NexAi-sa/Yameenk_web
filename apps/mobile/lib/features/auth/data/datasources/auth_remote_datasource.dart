library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';

abstract class AuthRemoteDataSource {
  Future<void> requestOtp(String phone);
  Future<Map<String, dynamic>> verifyOtp(String phone, String code);
  Future<Map<String, dynamic>> register(
      String name, String email, String password);
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
    } catch (_) {
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
    } catch (_) {
      throw const ServerException('رمز التحقق غير صحيح');
    }
  }

  @override
  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final res = await _client.rest.post(
        '/auth/register',
        data: {'name': name, 'email': email, 'password': password},
      );
      final data = res.data as Map<String, dynamic>;
      await _storage.write(
          key: 'access_token', value: data['access_token'] as String);
      if (data.containsKey('patient_id')) {
        await _storage.write(
            key: 'patient_id', value: data['patient_id'] as String);
      }
      return data;
    } catch (_) {
      throw const ServerException('فشل التسجيل، حاول مرة أخرى');
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
