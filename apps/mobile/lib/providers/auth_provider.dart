import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _storage = FlutterSecureStorage();

/// يقرأ patient_id المُخزَّن بعد تسجيل الدخول.
/// يُرمي [StateError] إذا لم يكن المستخدم مسجّل دخول.
final currentPatientIdProvider = FutureProvider<String>((ref) async {
  final id = await _storage.read(key: 'patient_id');
  if (id == null || id.isEmpty) {
    throw StateError('لم يتم تسجيل الدخول — patient_id غير موجود');
  }
  return id;
});

/// حالة المصادقة البسيطة — يُستخدم في الشاشات لقراءة patientId
class AuthState {
  final String patientId;
  const AuthState({required this.patientId});
}

/// يقرأ patient_id من التخزين الآمن ويوفّره بشكل متزامن عبر StateProvider
final authProvider = StateProvider<AuthState>((ref) {
  // يُحدَّث من login screen بعد نجاح تسجيل الدخول
  return const AuthState(patientId: '');
});
