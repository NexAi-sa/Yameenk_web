// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class SAr extends S {
  SAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'يمينك';

  @override
  String get tagline => 'طمأنينة أسرتك بين يديك';

  @override
  String get login_title => 'تسجيل الدخول';

  @override
  String get login_subtitle => 'أدخل رقم جوالك للمتابعة';

  @override
  String get login_phoneHint => '5XXXXXXXX';

  @override
  String get login_sendOtp => 'أرسل رمز التحقق';

  @override
  String get login_otpTitle => 'رمز التحقق';

  @override
  String login_otpSubtitle(String phone) {
    return 'أدخل الرمز المُرسَل إلى $phone';
  }

  @override
  String get login_confirm => 'تأكيد';

  @override
  String get login_changeNumber => 'تغيير الرقم';

  @override
  String get login_resend => 'إعادة الإرسال';

  @override
  String login_resendTimer(int seconds) {
    return 'إعادة الإرسال ($seconds)';
  }

  @override
  String get login_errorPhone => 'أدخل رقم الجوال';

  @override
  String get login_errorPhoneInvalid => 'أدخل رقم سعودي صحيح (5XXXXXXXX)';

  @override
  String get login_errorOtpSend => 'تعذّر إرسال الرمز. تحقق من الرقم.';

  @override
  String get login_errorOtpLength => 'أدخل الرمز المكوّن من 6 أرقام';

  @override
  String get login_errorOtpInvalid => 'رمز غير صحيح. حاول مرة أخرى.';

  @override
  String get register_title => 'إنشاء حساب';

  @override
  String get register_emailHint => 'البريد الإلكتروني';

  @override
  String get register_haveAccount => 'لديك حساب بالفعل؟';

  @override
  String get register_loginLink => 'تسجيل الدخول';

  @override
  String get register_fillAllFields => 'يرجى تعبئة جميع الحقول';

  @override
  String get login_noAccount => 'ليس لديك حساب؟';

  @override
  String get register_newAccount => 'حساب جديد';

  @override
  String get dashboard_greeting => 'مرحباً 👋';

  @override
  String get dashboard_subtitle => 'متابعة صحة المريض';

  @override
  String get dashboard_recordReading => 'سجّل قراءة';

  @override
  String get dashboard_services => 'الخدمات';

  @override
  String get dashboard_errorLoad => 'تعذّر تحميل بيانات المريض';

  @override
  String get dashboard_errorDetail => 'تحقق من اتصالك بالإنترنت';

  @override
  String get dashboard_weekSummary => 'ملخص الأسبوع';

  @override
  String get dashboard_alerts => 'تنبيهات';

  @override
  String get dashboard_normal => 'طبيعية';

  @override
  String get dashboard_total => 'إجمالي';

  @override
  String get dashboard_medicalProfile => 'الملف الطبي';

  @override
  String get dashboard_healthReports => 'التقارير الصحية';

  @override
  String get dashboard_marketplace => 'سوق الخدمات';

  @override
  String get dashboard_healthChat => 'شات صحي';

  @override
  String get dashboard_upgradePlus => 'ترقية ليمينك بلس';

  @override
  String get dashboard_plusFeatures =>
      'تنبيهات واتساب · تحليلات ذكية · متابعة لحظية';

  @override
  String get dashboard_readingLabel => 'قراءة السكر';

  @override
  String common_years(int count) {
    return '$count سنة';
  }

  @override
  String get common_retry => 'حاول مرة أخرى';

  @override
  String get common_cancel => 'إلغاء';

  @override
  String get common_back => 'رجوع';

  @override
  String common_error(String message) {
    return 'خطأ: $message';
  }

  @override
  String get common_cm => 'سم';

  @override
  String get common_kg => 'كجم';

  @override
  String get common_sar => 'ر.س';

  @override
  String get chat_title => 'أمين — مساعدك الصحي';

  @override
  String get chat_errorLoad => 'تعذّر تحميل المحادثة';

  @override
  String get chat_errorDetail => 'تحقق من اتصالك بالإنترنت';

  @override
  String get chat_inputHint => 'اسأل عن والدك...';

  @override
  String get chat_q1 => 'هل قراءته طبيعية؟';

  @override
  String get chat_q2 => 'ما الأدوية التي يأخذها؟';

  @override
  String get chat_q3 => 'متى آخر قراءة؟';

  @override
  String get chat_q4 => 'هل يحتاج طبيب؟';

  @override
  String get profile_title => 'الملف الطبي';

  @override
  String get profile_diseases => 'الأمراض المزمنة';

  @override
  String get profile_diseasesEmpty => 'لم تُضَف أمراض بعد';

  @override
  String get profile_allergies => 'الحساسية';

  @override
  String get profile_allergiesEmpty => 'لا توجد حساسية مسجلة';

  @override
  String get profile_medications => 'الأدوية والجرعات';

  @override
  String get profile_medicationsEmpty => 'لم تُضَف أدوية بعد';

  @override
  String get profile_emergency => 'جهات الطوارئ';

  @override
  String get profile_emergencyEmpty => 'لا توجد جهات طوارئ';

  @override
  String get profile_bloodType => 'فصيلة الدم';

  @override
  String get profile_height => 'الطول';

  @override
  String get profile_weight => 'الوزن';

  @override
  String get profile_completeBanner => 'أكمل ملفك الطبي';

  @override
  String profile_completePercent(int percent) {
    return '$percent% مكتمل';
  }

  @override
  String get profile_completeNow => 'أكمل الآن';

  @override
  String get setup_step1 => 'البيانات الأساسية';

  @override
  String get setup_step2 => 'الأمراض والحساسية';

  @override
  String get setup_step3 => 'الأدوية والجرعات';

  @override
  String get setup_step4 => 'جهات الطوارئ';

  @override
  String get setup_previous => 'السابق';

  @override
  String get setup_next => 'التالي';

  @override
  String get setup_save => 'حفظ الملف';

  @override
  String get setup_tellUs => 'أخبرنا عن المريض';

  @override
  String get setup_tellUsDetail => 'هذه المعلومات تساعدنا في تقديم رعاية أفضل';

  @override
  String get setup_fullName => 'الاسم الكامل';

  @override
  String get setup_age => 'العمر';

  @override
  String get setup_heightCm => 'الطول (سم)';

  @override
  String get setup_weightKg => 'الوزن (كجم)';

  @override
  String get setup_chronicDiseases => 'الأمراض المزمنة';

  @override
  String get setup_selectOrAdd => 'اختر من القائمة أو أضف يدوياً';

  @override
  String get setup_otherDisease => 'مرض آخر...';

  @override
  String get setup_addAllergy => 'أضف حساسية...';

  @override
  String get setup_currentMeds => 'الأدوية الحالية';

  @override
  String get setup_addAllMeds => 'أضف جميع الأدوية التي يتناولها المريض';

  @override
  String get setup_addMed => 'إضافة دواء';

  @override
  String get setup_medName => 'اسم الدواء';

  @override
  String get setup_dosage => 'الجرعة (مثال: 500mg)';

  @override
  String get setup_frequency => 'التكرار';

  @override
  String get setup_add => 'إضافة';

  @override
  String get setup_emergencyTitle => 'جهات الطوارئ';

  @override
  String get setup_emergencyDetail =>
      'أضف شخصاً واحداً على الأقل يمكن التواصل معه في الطوارئ';

  @override
  String get setup_addContact => 'إضافة جهة';

  @override
  String get setup_contactName => 'الاسم الكامل';

  @override
  String get setup_contactPhone => 'رقم الجوال (05xxxxxxxx)';

  @override
  String get setup_relation => 'صلة القرابة';

  @override
  String get setup_whatsappAlert =>
      'سوف يتم إرسال إشعارات واتس اب لهذه الأرقام في الحالات الطارئة';

  @override
  String get setup_notificationOptions => 'خيارات التنبيهات';

  @override
  String get setup_dailyFollowUp => 'متابعة يومية';

  @override
  String get setup_emergencyOnly => 'طارئة فقط';

  @override
  String get setup_weeklyReport => 'تقرير أسبوعي';

  @override
  String get setup_vitalsAlert =>
      'تنبيهات في حال عدم تسجيل المؤشرات الحيوية اليومية';

  @override
  String get setup_disease_diabetes1 => 'السكري النوع الأول';

  @override
  String get setup_disease_diabetes2 => 'السكري النوع الثاني';

  @override
  String get setup_disease_hypertension => 'ارتفاع ضغط الدم';

  @override
  String get setup_disease_heart => 'أمراض القلب';

  @override
  String get setup_disease_asthma => 'الربو';

  @override
  String get setup_disease_kidney => 'أمراض الكلى';

  @override
  String get setup_disease_osteoporosis => 'هشاشة العظام';

  @override
  String get setup_disease_alzheimers => 'الزهايمر';

  @override
  String get setup_freq_once => 'مرة يومياً';

  @override
  String get setup_freq_twice => 'مرتين يومياً';

  @override
  String get setup_freq_thrice => 'ثلاث مرات يومياً';

  @override
  String get setup_freq_weekly => 'أسبوعياً';

  @override
  String get setup_freq_asNeeded => 'عند الحاجة';

  @override
  String get setup_rel_child => 'ابن/ابنة';

  @override
  String get setup_rel_spouse => 'زوج/زوجة';

  @override
  String get setup_rel_sibling => 'أخ/أخت';

  @override
  String get setup_rel_parent => 'والد/والدة';

  @override
  String get setup_rel_otherRelative => 'قريب آخر';

  @override
  String get setup_rel_friend => 'صديق';

  @override
  String reading_record(String label) {
    return 'سجّل $label';
  }

  @override
  String get reading_lowerBP => 'السفلي';

  @override
  String get reading_upperBP => 'العلوي';

  @override
  String get reading_enterValue => 'أدخل القراءة';

  @override
  String get reading_timing => 'التوقيت';

  @override
  String get reading_fasting => 'صائم';

  @override
  String get reading_afterMeal => 'بعد الأكل';

  @override
  String get reading_beforeSleep => 'قبل النوم';

  @override
  String get reading_submit => 'سجّل الآن';

  @override
  String get reading_errorSave => 'لم يتم الحفظ. حاول مرة أخرى.';

  @override
  String get reading_defaultLabel => 'قراءتك';

  @override
  String get reports_title => 'التقارير الصحية';

  @override
  String get reports_insights => 'رؤى ذكية';

  @override
  String get reports_previous => 'التقارير السابقة';

  @override
  String get reports_medAdherence => 'الالتزام بالأدوية';

  @override
  String get reports_viewReport => 'عرض التقرير';

  @override
  String get reports_sugar => 'سكر';

  @override
  String get reports_pressure => 'ضغط';

  @override
  String get reports_readingsCount => 'قراءات';

  @override
  String reports_insightsCount(int count) {
    return '$count رؤى';
  }

  @override
  String get reports_today => 'اليوم';

  @override
  String get reports_yesterday => 'أمس';

  @override
  String reports_daysAgo(int count) {
    return 'قبل $count أيام';
  }

  @override
  String get consent_protectTitle => 'حماية بياناتك';

  @override
  String get consent_protectSubtitle =>
      'وفقاً لنظام حماية البيانات الشخصية (PDPL) نحتاج موافقتك الصريحة';

  @override
  String get consent_essential => 'موافقات أساسية';

  @override
  String get consent_essentialSub => 'مطلوبة لتشغيل الخدمة';

  @override
  String get consent_optional => 'موافقات اختيارية';

  @override
  String get consent_optionalSub => 'يمكنك تغييرها لاحقاً من الإعدادات';

  @override
  String get consent_readPrivacy => 'اقرأ سياسة الخصوصية كاملة';

  @override
  String get consent_withdrawNote =>
      'يمكنك سحب موافقتك في أي وقت من إعدادات الخصوصية';

  @override
  String get consent_agreeStart => 'أوافق وأبدأ';

  @override
  String get consent_errorRequired =>
      'يجب الموافقة على جمع البيانات الصحية الأساسية لاستخدام التطبيق';

  @override
  String get consent_errorSave => 'تعذّر حفظ الموافقات. حاول مرة أخرى.';

  @override
  String get consent_type_healthData => 'جمع البيانات الصحية';

  @override
  String get consent_type_healthDataDesc =>
      'نحتاج موافقتك لجمع القراءات الصحية مثل السكر والضغط لمتابعة حالة المريض.';

  @override
  String get consent_type_ai => 'تحليل الذكاء الاصطناعي';

  @override
  String get consent_type_aiDesc =>
      'يستخدم يمينك الذكاء الاصطناعي لتحليل القراءات وتقديم إرشادات صحية. يتم إخفاء هوية المريض قبل التحليل.';

  @override
  String get consent_type_whatsapp => 'إشعارات واتساب';

  @override
  String get consent_type_whatsappDesc =>
      'إرسال تنبيهات القراءات غير الطبيعية والتقارير الأسبوعية لأفراد الأسرة عبر واتساب.';

  @override
  String get consent_type_push => 'إشعارات التطبيق';

  @override
  String get consent_type_pushDesc =>
      'تذكيرات تسجيل القراءات والتنبيهات الفورية داخل التطبيق.';

  @override
  String get consent_type_analytics => 'التحليلات والتحسين';

  @override
  String get consent_type_analyticsDesc =>
      'بيانات مجهولة الهوية لتحسين أداء التطبيق وتجربة المستخدم.';

  @override
  String get consent_type_marketing => 'التسويق';

  @override
  String get consent_type_marketingDesc =>
      'إرسال عروض ومعلومات عن خدمات إضافية قد تفيدك.';

  @override
  String get privacy_title => 'إعدادات الخصوصية';

  @override
  String get privacy_pdplTitle => 'حماية البيانات الشخصية';

  @override
  String get privacy_pdplSubtitle => 'يمينك ملتزم بنظام PDPL الصادر عن سدايا';

  @override
  String get privacy_manageConsents => 'إدارة الموافقات';

  @override
  String get privacy_yourRights => 'حقوقك';

  @override
  String get privacy_downloadData => 'تحميل بياناتي';

  @override
  String get privacy_downloadDataSub => 'تحميل نسخة كاملة من جميع بياناتك';

  @override
  String get privacy_deleteAccount => 'حذف حسابي وبياناتي';

  @override
  String get privacy_deleteAccountSub =>
      'حذف جميع البيانات نهائياً — لا يمكن التراجع';

  @override
  String get privacy_policy => 'سياسة الخصوصية';

  @override
  String get privacy_essential => 'أساسي';

  @override
  String privacy_consentRevoked(String label) {
    return 'تم سحب الموافقة: $label';
  }

  @override
  String privacy_exportSuccess(int count) {
    return 'تم تجهيز بياناتك بنجاح. عدد السجلات: $count';
  }

  @override
  String get privacy_exportError => 'تعذّر تحميل البيانات. حاول مرة أخرى.';

  @override
  String get privacy_deleteTitle => 'حذف الحساب';

  @override
  String get privacy_deleteMsg =>
      'هل أنت متأكد من حذف حسابك وجميع بياناتك الصحية؟\n\nهذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get privacy_deleteConfirm => 'نعم، احذف';

  @override
  String get privacy_deleteFinalTitle => 'تأكيد نهائي';

  @override
  String get privacy_deleteFinalMsg =>
      'سيتم حذف:\n• جميع بيانات المريض الصحية\n• القراءات والمحادثات\n• الحجوزات والإشعارات\n• حسابك بالكامل\n\nلن تتمكن من استعادة هذه البيانات.';

  @override
  String get privacy_deleteFinal => 'احذف نهائياً';

  @override
  String get privacy_deleteError => 'تعذّر حذف الحساب. حاول مرة أخرى.';

  @override
  String get services_title => 'سوق الخدمات';

  @override
  String get services_searchHint => 'ابحث عن خدمة...';

  @override
  String get services_noServices => 'لا توجد خدمات في هذا التصنيف';

  @override
  String get services_catAll => 'الكل';

  @override
  String get services_catNursing => 'تمريض';

  @override
  String get services_catPhysio => 'علاج طبيعي';

  @override
  String get services_catCompanion => 'مرافقة';

  @override
  String get services_catTests => 'فحوصات';

  @override
  String get services_catConsult => 'استشارات';

  @override
  String get services_catPharmacy => 'صيدلية';

  @override
  String get plus_upgradeTitle => 'قم بالترقية إلى يمينك بلس';

  @override
  String get plus_upgradeSubtitle =>
      'استمتع بتجربة رعاية صحية ذكية متكاملة\nومصممة خصيصاً لاحتياجاتك';

  @override
  String get plus_features => 'مميزات العضوية';

  @override
  String get plus_whatsappTitle => 'تنبيهات واتساب ذكية';

  @override
  String get plus_whatsappDesc =>
      'إشعارات فورية وتقارير يومية تصلك مباشرة على واتساب لسهولة المتابعة.';

  @override
  String get plus_aiTitle => 'تحليلات الذكاء الاصطناعي';

  @override
  String get plus_aiDesc =>
      'تحليل عميق للبيانات الصحية لاكتشاف الأنماط وتقديم توصيات وقائية ذكية.';

  @override
  String get plus_monitorTitle => 'متابعة لحظية';

  @override
  String get plus_monitorDesc =>
      'رصد مستمر للمؤشرات الحيوية مع تنبيهات عند أي قراءات خارج النطاق الطبيعي.';

  @override
  String get plus_choosePlan => 'اختر خطتك';

  @override
  String get plus_yearly => 'سنوي';

  @override
  String get plus_monthly => 'شهري';

  @override
  String get plus_yearlyPrice => '٢٤٩';

  @override
  String get plus_monthlyPrice => '٢٤٩';

  @override
  String get plus_perYear => 'ر.س / سنة';

  @override
  String get plus_perMonth => 'ر.س / شهر';

  @override
  String get plus_save29 => 'وفّر ٢٩٪';

  @override
  String get plus_subscribe => 'اشترك الآن';

  @override
  String get plus_terms =>
      'بالاشتراك، أنت توافق على الشروط والأحكام وسياسة الخصوصية.';

  @override
  String get plus_welcomeMsg => 'مرحباً بك في يمينك بلس! 🎉';

  @override
  String get plus_termsLink => 'الشروط والأحكام';

  @override
  String get plus_privacyLink => 'سياسة الخصوصية';

  @override
  String get plus_appleInfo => 'معلومات مهمة';

  @override
  String get plus_autoRenew =>
      'يتجدد الاشتراك تلقائياً كل شهر ما لم يتم إلغاؤه قبل ٢٤ ساعة من نهاية الفترة الحالية.';

  @override
  String get plus_cancelInfo =>
      'يمكنك إلغاء الاشتراك في أي وقت من إعدادات حساب Apple ID.';

  @override
  String get plus_noRefund =>
      'لا يتم استرداد المبلغ عن أي جزء غير مستخدم من فترة الاشتراك الحالية.';

  @override
  String get gate_exclusive => 'ميزة حصرية ليمينك بلس';

  @override
  String gate_subscribeFor(String feature) {
    return 'اشترك في يمينك بلس للوصول إلى $feature\nوجميع المميزات المتقدمة';
  }

  @override
  String get gate_upgrade => 'ترقية ليمينك بلس';

  @override
  String get status_normal => 'طبيعي';

  @override
  String get status_needsAttention => 'يحتاج متابعة';

  @override
  String get status_alert => 'تنبيه';

  @override
  String get success_title => 'تم التسجيل ✅';

  @override
  String get success_subtitle => 'شكراً! تم حفظ قراءتك بنجاح';

  @override
  String get language_toggle => 'English';

  @override
  String get disclaimer_title => 'إخلاء مسؤولية طبية';

  @override
  String get disclaimer_point1 =>
      'هذا التطبيق لا يقدم تشخيصاً طبياً ولا يُغني عن استشارة الطبيب المختص.';

  @override
  String get disclaimer_point2 =>
      'جميع القراءات والتنبيهات هي لأغراض المتابعة فقط ولا تمثل رأياً طبياً.';

  @override
  String get disclaimer_point3 =>
      'في حالات الطوارئ، يجب التوجه فوراً إلى أقرب مستشفى أو الاتصال بالرقم 997.';

  @override
  String get disclaimer_accept => 'قرأتُ وأوافق';

  @override
  String get disclaimer_footer =>
      'باستخدامك التطبيق فإنك توافق على أن يمينك أداة متابعة فقط وليست بديلاً عن الرعاية الطبية.';

  @override
  String get chat_aiDisclaimer =>
      '⚕️ أمين مساعد صحي ذكي وليس طبيباً. لا يقدم وصفات طبية. استشر طبيبك دائماً في القرارات الطبية.';

  @override
  String get privacy_noDataSelling =>
      'بياناتك الصحية لا تُباع ولا تُشارك مع أي طرف ثالث لأغراض إعلانية أو تجارية.';

  @override
  String get dashboard_lastUpdated => 'آخر تحديث: قبل ٥ دقائق';

  @override
  String get dashboard_recentActivities => 'الأنشطة الأخيرة';

  @override
  String get dashboard_viewAll => 'عرض الكل';

  @override
  String get dashboard_completeProfileBanner =>
      'أكمل ملفك الطبي الآن للمتابعة الذكية.';

  @override
  String get dashboard_completeBtn => 'أكمل';

  @override
  String dashboard_patientStatus(String name) {
    return 'حالة $name';
  }

  @override
  String get dashboard_statusExcellent => 'مستقر وممتاز اليوم';

  @override
  String get dashboard_stablePulse => 'نبض مستقر';

  @override
  String get dashboard_talkToAI => 'تحدث مع المساعد الذكي';

  @override
  String get dashboard_aiSubtitle => 'استشارة طبية سريعة مع الذكاء الاصطناعي';

  @override
  String get dashboard_actInsulin => 'تناول الإنسولين (ميتفورمين)';

  @override
  String get dashboard_act1hAgo => 'قبل ساعة';

  @override
  String get dashboard_actCompleted => 'مكتمل';

  @override
  String get dashboard_actCheckup => 'فحص دوري - د. أحمد';

  @override
  String get dashboard_actTomorrow => 'غداً ١٠:٠٠ صباحاً';

  @override
  String get dashboard_actUpcoming => 'قادم';

  @override
  String get dashboard_vitalBP => 'ضغط الدم';

  @override
  String get dashboard_vitalSugar => 'السكر';

  @override
  String get dashboard_vitalHR => 'نبض القلب';

  @override
  String get dashboard_vitalO2 => 'الأكسجين';

  @override
  String get nav_home => 'الرئيسية';

  @override
  String get nav_assistant => 'المساعد';

  @override
  String get nav_services => 'الخدمات';

  @override
  String get nav_reports => 'التقارير';

  @override
  String get nav_profile => 'الملف';

  @override
  String get welcome_subtitle => 'نظام الرعاية المتكاملة';

  @override
  String get welcome_tagline => 'سندك الذكي لرعاية من تحب..';

  @override
  String get welcome_tagline2 => 'طمأنينة لك، وعناية تليق بهم.';

  @override
  String get welcome_getStarted => 'ابدأ الآن';

  @override
  String get welcome_footer => 'Care Reimagined • Yameenak Saudi Arabia';

  @override
  String get password_tooShort => 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';

  @override
  String get password_needsUppercase =>
      'كلمة المرور يجب أن تحتوي على حرف كبير واحد على الأقل';

  @override
  String get password_needsDigit =>
      'كلمة المرور يجب أن تحتوي على رقم واحد على الأقل';

  @override
  String get reports_generating => 'جارٍ إنشاء التقرير...';

  @override
  String get setup_featureComingSoon => 'هذه الميزة قادمة قريباً!';

  @override
  String setup_stepOf(int current, int total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get setup_progressSaved => 'يتم الحفظ تلقائياً';

  @override
  String get setup_nextDiseases => 'التالي: الأمراض المزمنة';

  @override
  String get setup_nextMeds => 'التالي: الأدوية';

  @override
  String get setup_nextEmergency => 'التالي: جهات الطوارئ';

  @override
  String get setup_welcomeCaregiver => 'مرحباً، مقدّم الرعاية';

  @override
  String get setup_settingUpProfile =>
      'أنت تقوم بإعداد\nملف الشخص العزيز عليك.';

  @override
  String get setup_tailorExperience =>
      'هذه المعلومات تساعدنا في تخصيص تجربة الرعاية الصحية حسب احتياجاتهم البيولوجية والصحية.';

  @override
  String get setup_enterFullName => 'أدخل الاسم الكامل';

  @override
  String get setup_ageInYears => 'العمر بالسنوات';

  @override
  String get setup_gender => 'الجنس';

  @override
  String get setup_male => 'ذكر';

  @override
  String get setup_female => 'أنثى';

  @override
  String get setup_whyMattersLabel => 'لماذا هذا مهم: ';

  @override
  String get setup_whyBasicInfo =>
      'تقديم معلومات أساسية دقيقة يسمح لنظام الذكاء الاصطناعي بحساب مستويات الجرعات الصحيحة وعوامل الخطورة الصحية بناءً على المعايير الديموغرافية.';

  @override
  String get setup_allergyHint => 'مثال: بنسلين، فول سوداني، لاتكس...';

  @override
  String get setup_addAllergyBtn => 'إضافة حساسية';

  @override
  String get setup_whyMattersQ => 'لماذا هذا مهم؟';

  @override
  String get setup_whyMedHistory =>
      'تاريخك الطبي يساعد نظام الرعاية الذكية لدينا على منع التداخلات الدوائية وتصميم خطة التغذية خصيصاً لاحتياجاتك.';

  @override
  String get setup_medNameLabel => 'اسم الدواء';

  @override
  String get setup_doseHint => 'مثال: 500 ملجم، مرتين يومياً';

  @override
  String get setup_doseLabel => 'الجرعة والتكرار';

  @override
  String get setup_addMedBtn => 'إضافة دواء';

  @override
  String get setup_aiTip => 'نصيحة المساعد الذكي';

  @override
  String get setup_aiTipDetail =>
      'الدقة مهمة. إذا لم تكن متأكداً من الجرعة، استخدم ميزة تحميل الصور ليتحقق نظامنا الطبي الذكي من التفاصيل.';

  @override
  String get setup_uploadPrescription => 'تحميل الوصفة الطبية';

  @override
  String get setup_aiExtractInfo =>
      'سيقوم الذكاء الاصطناعي باستخراج أسماء الأدوية والجرعات والجداول.';

  @override
  String get setup_browseFiles => 'تصفح الملفات';

  @override
  String get setup_contactNameLabel => 'اسم جهة الاتصال';

  @override
  String get setup_relationLabel => 'صلة القرابة';

  @override
  String get setup_phoneLabel => 'رقم الهاتف';

  @override
  String get setup_addAnotherContact => 'إضافة جهة اتصال أخرى';

  @override
  String get setup_optionalSettings => 'إعدادات اختيارية';

  @override
  String get setup_dailyCareFeature => 'ميزة الرعاية اليومية';

  @override
  String get setup_vitalsLogging => 'تسجيل المؤشرات الحيوية';

  @override
  String get setup_vitalsLoggingDetail =>
      'بمجرد تفعيل ملفك، سنساعدك في تسجيل القراءات الحيوية مثل السكر والضغط يومياً.';

  @override
  String get setup_dataPrivacy => 'خصوصية وأمان البيانات';

  @override
  String get setup_dataPrivacyDetail =>
      'بياناتك الطبية مشفّرة ولا تُشارك إلا مع فريقك الطبي المعتمد وأفراد أسرتك.';
}
