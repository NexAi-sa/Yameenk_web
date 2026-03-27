import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../app/router.dart';

/// Supabase project configuration
const _supabaseUrl = 'https://bnmvuaqxcmdycpyojfbg.supabase.co';
const _supabaseAnonKey = String.fromEnvironment(
  'SUPABASE_ANON_KEY',
  defaultValue:
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJubXZ1YXF4Y21keWNweW9qZmJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ1MjkzMDQsImV4cCI6MjA5MDEwNTMwNH0.tTsIV5xbpUMetKp-1xoGlt5vQsY3QMuEFH188GZ4-AM',
);
const _functionsUrl = '$_supabaseUrl/functions/v1';

// Fallback for REST API (non-Edge-Function endpoints)
const _baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: '$_supabaseUrl/rest/v1',
);

final apiServiceProvider = Provider<ApiService>((ref) {
  final router = ref.read(routerProvider);
  return ApiService(
    onSessionExpired: () => router.go('/login'),
  );
});

class ApiService {
  late final Dio _dio; // REST API
  late final Dio _fnDio; // Edge Functions
  final _storage = const FlutterSecureStorage();
  final VoidCallback? _onSessionExpired;
  bool _isLoggingOut = false;

  ApiService({VoidCallback? onSessionExpired})
      : _onSessionExpired = onSessionExpired {
    // ──── REST API (Supabase PostgREST) ────
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'apikey': _supabaseAnonKey,
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401 &&
            !e.requestOptions.path.contains('/auth/')) {
          _handleSessionExpired();
        }
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionError) {
          return handler.reject(DioException(
            requestOptions: e.requestOptions,
            type: e.type,
            error: 'تعذّر الاتصال بالخادم — تحقق من الاتصال بالإنترنت',
          ));
        }
        return handler.next(e);
      },
    ));

    // ──── Edge Functions ────
    _fnDio = Dio(BaseOptions(
      baseUrl: _functionsUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 60), // AI responses can be slow
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_supabaseAnonKey',
      },
    ));

    _fnDio.interceptors.add(InterceptorsWrapper(
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          _handleSessionExpired();
        }
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionError) {
          return handler.reject(DioException(
            requestOptions: e.requestOptions,
            type: e.type,
            error: 'تعذّر الاتصال — تحقق من الاتصال بالإنترنت',
          ));
        }
        return handler.next(e);
      },
    ));
  }

  /// يمسح الجلسة ويوجّه للـ login عند استلام 401
  Future<void> _handleSessionExpired() async {
    if (_isLoggingOut) return; // تجنّب تكرار التوجيه
    _isLoggingOut = true;
    await _storage.deleteAll();
    _onSessionExpired?.call();
  }

  // ═══════════════════════════════════════
  // Auth
  // ═══════════════════════════════════════
  Future<Map<String, dynamic>> requestOtp(String phone) async {
    final res = await _dio.post('/auth/otp/request', data: {'phone': phone});
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String code) async {
    final res = await _dio
        .post('/auth/otp/verify', data: {'phone': phone, 'code': code});
    final data = res.data as Map<String, dynamic>;
    await _storage.write(
        key: 'access_token', value: data['access_token'] as String);
    if (data.containsKey('patient_id')) {
      await _storage.write(
          key: 'patient_id', value: data['patient_id'] as String);
    }
    return data;
  }

  // ═══════════════════════════════════════
  // Patients
  // ═══════════════════════════════════════
  Future<Map<String, dynamic>> getPatient(String patientId) async {
    final res = await _dio.get('/patients/$patientId');
    return res.data as Map<String, dynamic>;
  }

  // ═══════════════════════════════════════
  // Readings
  // ═══════════════════════════════════════
  Future<void> saveReading({
    required String patientId,
    required String type,
    required double value,
    double? value2,
  }) async {
    await _dio.post('/readings', data: {
      'patient_id': patientId,
      'type': type,
      'value': value,
      if (value2 != null) 'value2': value2,
    });
  }

  Future<List<dynamic>> getReadings(String patientId, {int days = 7}) async {
    final res = await _dio.get('/readings', queryParameters: {
      'patient_id': patientId,
      'days': days,
    });
    return res.data as List<dynamic>;
  }

  // ═══════════════════════════════════════
  // AI Chat → Supabase Edge Function
  // ═══════════════════════════════════════
  Future<String> sendChatMessage(String patientId, String message) async {
    final res = await _fnDio.post('/chat', data: {
      'patient_id': patientId,
      'message': message,
    });
    return (res.data as Map<String, dynamic>)['response'] as String;
  }

  // ═══════════════════════════════════════
  // AI Reports → Supabase Edge Function
  // ═══════════════════════════════════════
  Future<Map<String, dynamic>> generateReport(String patientId) async {
    final res = await _fnDio.post('/generate-report', data: {
      'patient_id': patientId,
    });
    return res.data as Map<String, dynamic>;
  }

  // ═══════════════════════════════════════
  // Reading Analysis → Supabase Edge Function
  // ═══════════════════════════════════════
  Future<Map<String, dynamic>> analyzeReading({
    required String readingId,
    required String patientId,
    required String type,
    required double value1,
    double? value2,
  }) async {
    final res = await _fnDio.post('/analyze-reading', data: {
      'reading_id': readingId,
      'patient_id': patientId,
      'type': type,
      'value_1': value1,
      if (value2 != null) 'value_2': value2,
    });
    return res.data as Map<String, dynamic>;
  }

  // ═══════════════════════════════════════
  // Medical Profile — الملف الطبي
  // ═══════════════════════════════════════

  /// جلب الملف الطبي الكامل (patients + medications + emergency_contacts + notification_preferences)
  Future<Map<String, dynamic>> getMedicalProfile(String patientId) async {
    final results = await Future.wait([
      _dio.get('/patients', queryParameters: {
        'id': 'eq.$patientId',
        'select': '*',
      }),
      _dio.get('/medications', queryParameters: {
        'patient_id': 'eq.$patientId',
        'is_active': 'eq.true',
        'select': 'name,dosage,frequency,notes',
      }),
      _dio.get('/emergency_contacts', queryParameters: {
        'patient_id': 'eq.$patientId',
        'select': 'name,phone,relation',
      }),
      _dio.get('/notification_preferences', queryParameters: {
        'patient_id': 'eq.$patientId',
        'select': '*',
      }),
    ]);

    final patients = results[0].data as List;
    if (patients.isEmpty) throw Exception('المريض غير موجود');

    return {
      'patient': patients.first as Map<String, dynamic>,
      'medications': results[1].data as List,
      'emergency_contacts': results[2].data as List,
      'notification_preferences':
          (results[3].data as List).isNotEmpty
              ? (results[3].data as List).first as Map<String, dynamic>
              : null,
    };
  }

  /// تحديث بيانات المريض الأساسية
  Future<void> updatePatient(String patientId, Map<String, dynamic> data) async {
    await _dio.patch(
      '/patients?id=eq.$patientId',
      data: data,
      options: Options(headers: {'Prefer': 'return=minimal'}),
    );
  }

  /// حفظ الأدوية (حذف القديمة + إضافة الجديدة)
  Future<void> upsertMedications(String patientId, List<Map<String, dynamic>> meds) async {
    // إلغاء تفعيل القديمة
    await _dio.patch(
      '/medications?patient_id=eq.$patientId&is_active=eq.true',
      data: {'is_active': false},
      options: Options(headers: {'Prefer': 'return=minimal'}),
    );
    // إضافة الجديدة
    if (meds.isNotEmpty) {
      await _dio.post(
        '/medications',
        data: meds.map((m) => {...m, 'patient_id': patientId}).toList(),
        options: Options(headers: {'Prefer': 'return=minimal'}),
      );
    }
  }

  /// حفظ جهات الطوارئ (حذف + إعادة إنشاء)
  Future<void> upsertEmergencyContacts(String patientId, List<Map<String, dynamic>> contacts) async {
    await _dio.delete('/emergency_contacts?patient_id=eq.$patientId');
    if (contacts.isNotEmpty) {
      await _dio.post(
        '/emergency_contacts',
        data: contacts.map((c) => {...c, 'patient_id': patientId}).toList(),
        options: Options(headers: {'Prefer': 'return=minimal'}),
      );
    }
  }

  /// حفظ تفضيلات الإشعارات (upsert)
  Future<void> upsertNotificationPreferences(String patientId, Map<String, dynamic> prefs) async {
    await _dio.post(
      '/notification_preferences',
      data: {...prefs, 'patient_id': patientId},
      options: Options(headers: {
        'Prefer': 'return=minimal',
        'on-conflict': 'patient_id',
      }),
    );
  }

  // ═══════════════════════════════════════
  // ✅ Record Reading (تسجيل قراءة)
  // ═══════════════════════════════════════
  Future<void> recordReading({
    required String patientId,
    required String type,
    double? value,
    int? systolic,
    int? diastolic,
    String? context,
  }) async {
    await _dio.post('/readings', data: {
      'patient_id': patientId,
      'type': type,
      if (value != null) 'value_1': value,
      if (systolic != null) 'value_1': systolic,
      if (diastolic != null) 'value_2': diastolic,
      if (context != null) 'context': context,
    });
  }

  // ═══════════════════════════════════════
  // ✅ Export Patient Data (PDPL)
  // ═══════════════════════════════════════
  Future<Map<String, dynamic>> exportPatientData(String patientId) async {
    final res = await _dio.get('/privacy/my-data');
    return res.data as Map<String, dynamic>;
  }

  // ═══════════════════════════════════════
  // ✅ وكالة البيانات الطبية
  // الأساس القانوني: PDPL المادة 6(2) + المادة 29
  // ═══════════════════════════════════════

  /// تسجيل وكالة بيانات طبية تُخوّل فرد الأسرة متابعة المريض والتنبؤ بالأمراض
  Future<Map<String, dynamic>> registerMedicalAgency({
    required String patientId,
    required String agentUserId,
    required String relationship,
    required String legalCapacity, // 'patient_self' | 'legal_guardian' | 'power_of_attorney'
    String? legalDocumentRef,
    List<String> scope = const [
      'health_monitoring',
      'anomaly_alerts',
      'ai_analysis',
      'predictive_health',
      'family_dashboard_access',
    ],
  }) async {
    final res = await _dio.post('/privacy/agency', data: {
      'patient_id': patientId,
      'agent_user_id': agentUserId,
      'relationship': relationship,
      'legal_capacity': legalCapacity,
      if (legalDocumentRef != null) 'legal_document_ref': legalDocumentRef,
      'scope': scope,
    });
    return res.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getPatientAgencies(String patientId) async {
    final res = await _dio.get('/privacy/agency/$patientId');
    return res.data as List<dynamic>;
  }

  Future<void> revokeAgency(String agencyId, {String? reason}) async {
    await _dio.delete('/privacy/agency/$agencyId', data: {
      if (reason != null) 'reason': reason,
    });
  }

  // ═══════════════════════════════════════
  // ✅ PDPL: Privacy & Consent APIs
  // ═══════════════════════════════════════
  Future<List<Map<String, dynamic>>> getConsents() async {
    final res = await _dio.get('/privacy/consents');
    return List<Map<String, dynamic>>.from(res.data as List);
  }

  Future<void> submitConsents(List<Map<String, dynamic>> consents) async {
    await _dio.post('/privacy/consents/batch', data: {'consents': consents});
  }

  Future<void> revokeConsent(String type) async {
    await _dio.delete('/privacy/consents/$type');
  }

  Future<Map<String, dynamic>> exportMyData() async {
    final res = await _dio.get('/privacy/my-data');
    return res.data as Map<String, dynamic>;
  }

  Future<void> deleteAccount() async {
    await _dio.delete('/privacy/account');
    await _storage.deleteAll();
  }
}
