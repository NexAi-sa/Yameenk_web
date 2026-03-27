library;

import 'package:equatable/equatable.dart';

enum ConsentType {
  healthDataCollection(
      'health_data_collection',
      'جمع البيانات الصحية',
      'نحتاج موافقتك لجمع القراءات الصحية مثل السكر والضغط لمتابعة حالة المريض.',
      true),
  aiAnalysis(
      'ai_analysis',
      'تحليل الذكاء الاصطناعي',
      'يستخدم يمينك الذكاء الاصطناعي لتحليل القراءات وتقديم إرشادات صحية.',
      true),
  predictiveHealthMonitoring(
      'predictive_health_monitoring',
      'التنبؤ بالأمراض الصامتة',
      'تحليل اتجاهات القراءات لاكتشاف المخاطر الصحية مبكراً قبل تفاقمها.',
      true),
  crossBorderAiTransfer(
      'cross_border_ai_transfer',
      'نقل بيانات مجهولة لخارج المملكة',
      'إرسال بيانات مجهولة الهوية لخدمات الذكاء الاصطناعي (Gemini/Claude) للتحليل المتقدم. وفقاً للمادة 29 من PDPL.',
      true),
  medicalRecordsRetention(
      'medical_records_retention',
      'الاحتفاظ بالسجلات الطبية',
      'الاحتفاظ بسجلاتك الطبية لمدة 10 سنوات وفقاً لأنظمة وزارة الصحة.',
      true),
  emergencyFamilyAccess(
      'emergency_family_access',
      'وصول الأسرة في الطوارئ',
      'السماح لأفراد الأسرة المسجلين بالوصول للبيانات الصحية في حالات الطوارئ.',
      true),
  whatsappNotifications(
      'whatsapp_notifications',
      'إشعارات واتساب',
      'إرسال تنبيهات القراءات غير الطبيعية والتقارير الأسبوعية لأفراد الأسرة.',
      true),
  pushNotifications('push_notifications', 'إشعارات التطبيق',
      'تذكيرات تسجيل القراءات والتنبيهات الفورية داخل التطبيق.', false),
  analytics('analytics', 'التحليلات والتحسين',
      'بيانات مجهولة الهوية لتحسين أداء التطبيق.', false),
  marketing('marketing', 'التسويق',
      'إرسال عروض ومعلومات عن خدمات إضافية.', false);

  const ConsentType(
      this.apiKey, this.label, this.description, this.isEssential);
  final String apiKey;
  final String label;
  final String description;
  final bool isEssential;
}

class ConsentEntity extends Equatable {
  final Map<ConsentType, bool> consents;
  final bool hasCompletedInitialConsent;

  const ConsentEntity({
    this.consents = const {},
    this.hasCompletedInitialConsent = false,
  });

  bool get essentialConsentsGranted => ConsentType.values
      .where((t) => t.isEssential)
      .every((t) => consents[t] == true);

  ConsentEntity copyWith({
    Map<ConsentType, bool>? consents,
    bool? hasCompletedInitialConsent,
  }) =>
      ConsentEntity(
        consents: consents ?? this.consents,
        hasCompletedInitialConsent:
            hasCompletedInitialConsent ?? this.hasCompletedInitialConsent,
      );

  @override
  List<Object?> get props => [consents, hasCompletedInitialConsent];
}
