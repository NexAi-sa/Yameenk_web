/// خدمة إدارة الموافقات — Consent Service
/// التحقق من الموافقة الصريحة على جمع البيانات الصحية (PDPL)
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';

// أنواع الموافقات
enum ConsentType {
  healthDataCollection(
      'health_data_collection',
      'جمع البيانات الصحية',
      'نحتاج موافقتك لجمع القراءات الصحية مثل السكر والضغط لمتابعة حالة المريض.',
      true),
  aiAnalysis(
      'ai_analysis',
      'تحليل الذكاء الاصطناعي',
      'يستخدم يمينك الذكاء الاصطناعي لتحليل القراءات وتقديم إرشادات صحية. يتم إخفاء هوية المريض قبل التحليل.',
      true),
  whatsappNotifications(
      'whatsapp_notifications',
      'إشعارات واتساب',
      'إرسال تنبيهات القراءات غير الطبيعية والتقارير الأسبوعية لأفراد الأسرة عبر واتساب.',
      true),
  pushNotifications('push_notifications', 'إشعارات التطبيق',
      'تذكيرات تسجيل القراءات والتنبيهات الفورية داخل التطبيق.', false),
  analytics('analytics', 'التحليلات والتحسين',
      'بيانات مجهولة الهوية لتحسين أداء التطبيق وتجربة المستخدم.', false),
  marketing('marketing', 'التسويق',
      'إرسال عروض ومعلومات عن خدمات إضافية قد تفيدك.', false);

  const ConsentType(
      this.apiKey, this.label, this.description, this.isEssential);
  final String apiKey;
  final String label;
  final String description;
  final bool isEssential;
}

// نموذج حالة الموافقة
class ConsentState {
  final Map<ConsentType, bool> consents;
  final bool isLoading;
  final bool hasCompletedInitialConsent;

  const ConsentState({
    this.consents = const {},
    this.isLoading = false,
    this.hasCompletedInitialConsent = false,
  });

  ConsentState copyWith({
    Map<ConsentType, bool>? consents,
    bool? isLoading,
    bool? hasCompletedInitialConsent,
  }) {
    return ConsentState(
      consents: consents ?? this.consents,
      isLoading: isLoading ?? this.isLoading,
      hasCompletedInitialConsent:
          hasCompletedInitialConsent ?? this.hasCompletedInitialConsent,
    );
  }

  bool get essentialConsentsGranted {
    return ConsentType.values
        .where((t) => t.isEssential)
        .every((t) => consents[t] == true);
  }
}

// Provider
final consentProvider = StateNotifierProvider<ConsentNotifier, ConsentState>(
  (ref) => ConsentNotifier(ref),
);

class ConsentNotifier extends StateNotifier<ConsentState> {
  final Ref _ref;
  final _storage = const FlutterSecureStorage();
  static const _consentCompletedKey = 'pdpl_consent_completed';

  ConsentNotifier(this._ref) : super(const ConsentState()) {
    _loadLocalState();
  }

  Future<void> _loadLocalState() async {
    final completed = await _storage.read(key: _consentCompletedKey);
    if (completed == 'true') {
      state = state.copyWith(hasCompletedInitialConsent: true);
    }
  }

  /// تحديث حالة موافقة محلياً
  void toggleConsent(ConsentType type, bool value) {
    final updated = Map<ConsentType, bool>.from(state.consents);
    updated[type] = value;
    state = state.copyWith(consents: updated);
  }

  /// إرسال جميع الموافقات للباك إند
  Future<bool> submitConsents() async {
    state = state.copyWith(isLoading: true);
    try {
      final api = _ref.read(apiServiceProvider);
      final consentsToSend = state.consents.entries
          .map((e) => {'type': e.key.apiKey, 'granted': e.value})
          .toList();

      await api.submitConsents(consentsToSend);
      await _storage.write(key: _consentCompletedKey, value: 'true');

      state = state.copyWith(
        isLoading: false,
        hasCompletedInitialConsent: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  /// تحميل الموافقات من الباك إند
  Future<void> loadConsentsFromServer() async {
    state = state.copyWith(isLoading: true);
    try {
      final api = _ref.read(apiServiceProvider);
      final serverConsents = await api.getConsents();

      final Map<ConsentType, bool> loaded = {};
      for (final consent in serverConsents) {
        final type = ConsentType.values.cast<ConsentType?>().firstWhere(
              (t) => t?.apiKey == consent['consent_type'],
              orElse: () => null,
            );
        if (type != null) {
          loaded[type] = consent['granted'] == true;
        }
      }

      final completed = await _storage.read(key: _consentCompletedKey);

      state = state.copyWith(
        consents: loaded,
        isLoading: false,
        hasCompletedInitialConsent: completed == 'true',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// سحب موافقة محددة
  Future<bool> revokeConsent(ConsentType type) async {
    try {
      final api = _ref.read(apiServiceProvider);
      await api.revokeConsent(type.apiKey);

      final updated = Map<ConsentType, bool>.from(state.consents);
      updated[type] = false;
      state = state.copyWith(consents: updated);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// إعادة تعيين (عند حذف الحساب)
  Future<void> reset() async {
    await _storage.delete(key: _consentCompletedKey);
    state = const ConsentState();
  }
}
