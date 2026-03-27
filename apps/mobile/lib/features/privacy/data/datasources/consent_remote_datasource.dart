library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';

abstract class ConsentRemoteDataSource {
  Future<bool> hasCompletedConsent();
  Future<List<Map<String, dynamic>>> getConsents();
  Future<void> submitConsents(List<Map<String, dynamic>> consents);
  Future<void> revokeConsent(String typeKey);
  Future<void> markConsentCompleted();
}

class ConsentRemoteDataSourceImpl implements ConsentRemoteDataSource {
  final DioClient _client;
  final _storage = const FlutterSecureStorage();
  static const _consentKey = 'pdpl_consent_completed';

  ConsentRemoteDataSourceImpl(this._client);

  @override
  Future<bool> hasCompletedConsent() async {
    // Check SharedPreferences first (fast), then fall back to secure storage.
    final prefs = await SharedPreferences.getInstance();
    final spVal = prefs.getBool('pdpl_consent_completed_sp');
    if (spVal == true) return true;
    final val = await _storage.read(key: _consentKey);
    return val == 'true';
  }

  @override
  Future<List<Map<String, dynamic>>> getConsents() async {
    try {
      final res = await _client.rest.get('/privacy/consents');
      return List<Map<String, dynamic>>.from(res.data as List);
    } catch (_) {
      throw const ServerException();
    }
  }

  @override
  Future<void> submitConsents(
      List<Map<String, dynamic>> consents) async {
    try {
      await _client.rest
          .post('/privacy/consents/batch', data: {'consents': consents});
    } catch (_) {
      throw const ServerException();
    }
  }

  @override
  Future<void> revokeConsent(String typeKey) async {
    try {
      await _client.rest.delete('/privacy/consents/$typeKey');
    } catch (_) {
      throw const ServerException();
    }
  }

  @override
  Future<void> markConsentCompleted() async {
    await _storage.write(key: _consentKey, value: 'true');
    // Also persist in SharedPreferences for fast route guard checks.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pdpl_consent_completed_sp', true);
  }
}
