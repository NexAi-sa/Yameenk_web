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
