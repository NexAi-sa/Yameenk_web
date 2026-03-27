import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'يمينك'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In ar, this message translates to:
  /// **'طمأنينة أسرتك بين يديك'**
  String get tagline;

  /// No description provided for @login_title.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get login_title;

  /// No description provided for @login_subtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم جوالك للمتابعة'**
  String get login_subtitle;

  /// No description provided for @login_phoneHint.
  ///
  /// In ar, this message translates to:
  /// **'5XXXXXXXX'**
  String get login_phoneHint;

  /// No description provided for @login_sendOtp.
  ///
  /// In ar, this message translates to:
  /// **'أرسل رمز التحقق'**
  String get login_sendOtp;

  /// No description provided for @login_otpTitle.
  ///
  /// In ar, this message translates to:
  /// **'رمز التحقق'**
  String get login_otpTitle;

  /// No description provided for @login_otpSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الرمز المُرسَل إلى {phone}'**
  String login_otpSubtitle(String phone);

  /// No description provided for @login_confirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get login_confirm;

  /// No description provided for @login_changeNumber.
  ///
  /// In ar, this message translates to:
  /// **'تغيير الرقم'**
  String get login_changeNumber;

  /// No description provided for @login_resend.
  ///
  /// In ar, this message translates to:
  /// **'إعادة الإرسال'**
  String get login_resend;

  /// No description provided for @login_resendTimer.
  ///
  /// In ar, this message translates to:
  /// **'إعادة الإرسال ({seconds})'**
  String login_resendTimer(int seconds);

  /// No description provided for @login_errorPhone.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم الجوال'**
  String get login_errorPhone;

  /// No description provided for @login_errorPhoneInvalid.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم سعودي صحيح (5XXXXXXXX)'**
  String get login_errorPhoneInvalid;

  /// No description provided for @login_errorOtpSend.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر إرسال الرمز. تحقق من الرقم.'**
  String get login_errorOtpSend;

  /// No description provided for @login_errorOtpLength.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الرمز المكوّن من 6 أرقام'**
  String get login_errorOtpLength;

  /// No description provided for @login_errorOtpInvalid.
  ///
  /// In ar, this message translates to:
  /// **'رمز غير صحيح. حاول مرة أخرى.'**
  String get login_errorOtpInvalid;

  /// No description provided for @register_title.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get register_title;

  /// No description provided for @register_emailHint.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get register_emailHint;

  /// No description provided for @register_haveAccount.
  ///
  /// In ar, this message translates to:
  /// **'لديك حساب بالفعل؟'**
  String get register_haveAccount;

  /// No description provided for @register_loginLink.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get register_loginLink;

  /// No description provided for @register_fillAllFields.
  ///
  /// In ar, this message translates to:
  /// **'يرجى تعبئة جميع الحقول'**
  String get register_fillAllFields;

  /// No description provided for @login_noAccount.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب؟'**
  String get login_noAccount;

  /// No description provided for @register_newAccount.
  ///
  /// In ar, this message translates to:
  /// **'حساب جديد'**
  String get register_newAccount;

  /// No description provided for @dashboard_greeting.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً 👋'**
  String get dashboard_greeting;

  /// No description provided for @dashboard_subtitle.
  ///
  /// In ar, this message translates to:
  /// **'متابعة صحة المريض'**
  String get dashboard_subtitle;

  /// No description provided for @dashboard_recordReading.
  ///
  /// In ar, this message translates to:
  /// **'سجّل قراءة'**
  String get dashboard_recordReading;

  /// No description provided for @dashboard_services.
  ///
  /// In ar, this message translates to:
  /// **'الخدمات'**
  String get dashboard_services;

  /// No description provided for @dashboard_errorLoad.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحميل بيانات المريض'**
  String get dashboard_errorLoad;

  /// No description provided for @dashboard_errorDetail.
  ///
  /// In ar, this message translates to:
  /// **'تحقق من اتصالك بالإنترنت'**
  String get dashboard_errorDetail;

  /// No description provided for @dashboard_weekSummary.
  ///
  /// In ar, this message translates to:
  /// **'ملخص الأسبوع'**
  String get dashboard_weekSummary;

  /// No description provided for @dashboard_alerts.
  ///
  /// In ar, this message translates to:
  /// **'تنبيهات'**
  String get dashboard_alerts;

  /// No description provided for @dashboard_normal.
  ///
  /// In ar, this message translates to:
  /// **'طبيعية'**
  String get dashboard_normal;

  /// No description provided for @dashboard_total.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي'**
  String get dashboard_total;

  /// No description provided for @dashboard_medicalProfile.
  ///
  /// In ar, this message translates to:
  /// **'الملف الطبي'**
  String get dashboard_medicalProfile;

  /// No description provided for @dashboard_healthReports.
  ///
  /// In ar, this message translates to:
  /// **'التقارير الصحية'**
  String get dashboard_healthReports;

  /// No description provided for @dashboard_marketplace.
  ///
  /// In ar, this message translates to:
  /// **'سوق الخدمات'**
  String get dashboard_marketplace;

  /// No description provided for @dashboard_healthChat.
  ///
  /// In ar, this message translates to:
  /// **'شات صحي'**
  String get dashboard_healthChat;

  /// No description provided for @dashboard_upgradePlus.
  ///
  /// In ar, this message translates to:
  /// **'ترقية ليمينك بلس'**
  String get dashboard_upgradePlus;

  /// No description provided for @dashboard_plusFeatures.
  ///
  /// In ar, this message translates to:
  /// **'تنبيهات واتساب · تحليلات ذكية · متابعة لحظية'**
  String get dashboard_plusFeatures;

  /// No description provided for @dashboard_readingLabel.
  ///
  /// In ar, this message translates to:
  /// **'قراءة السكر'**
  String get dashboard_readingLabel;

  /// No description provided for @common_years.
  ///
  /// In ar, this message translates to:
  /// **'{count} سنة'**
  String common_years(int count);

  /// No description provided for @common_retry.
  ///
  /// In ar, this message translates to:
  /// **'حاول مرة أخرى'**
  String get common_retry;

  /// No description provided for @common_cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get common_cancel;

  /// No description provided for @common_back.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get common_back;

  /// No description provided for @common_error.
  ///
  /// In ar, this message translates to:
  /// **'خطأ: {message}'**
  String common_error(String message);

  /// No description provided for @common_cm.
  ///
  /// In ar, this message translates to:
  /// **'سم'**
  String get common_cm;

  /// No description provided for @common_kg.
  ///
  /// In ar, this message translates to:
  /// **'كجم'**
  String get common_kg;

  /// No description provided for @common_sar.
  ///
  /// In ar, this message translates to:
  /// **'ر.س'**
  String get common_sar;

  /// No description provided for @chat_title.
  ///
  /// In ar, this message translates to:
  /// **'أمين — مساعدك الصحي'**
  String get chat_title;

  /// No description provided for @chat_errorLoad.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحميل المحادثة'**
  String get chat_errorLoad;

  /// No description provided for @chat_errorDetail.
  ///
  /// In ar, this message translates to:
  /// **'تحقق من اتصالك بالإنترنت'**
  String get chat_errorDetail;

  /// No description provided for @chat_inputHint.
  ///
  /// In ar, this message translates to:
  /// **'اسأل عن والدك...'**
  String get chat_inputHint;

  /// No description provided for @chat_q1.
  ///
  /// In ar, this message translates to:
  /// **'هل قراءته طبيعية؟'**
  String get chat_q1;

  /// No description provided for @chat_q2.
  ///
  /// In ar, this message translates to:
  /// **'ما الأدوية التي يأخذها؟'**
  String get chat_q2;

  /// No description provided for @chat_q3.
  ///
  /// In ar, this message translates to:
  /// **'متى آخر قراءة؟'**
  String get chat_q3;

  /// No description provided for @chat_q4.
  ///
  /// In ar, this message translates to:
  /// **'هل يحتاج طبيب؟'**
  String get chat_q4;

  /// No description provided for @profile_title.
  ///
  /// In ar, this message translates to:
  /// **'الملف الطبي'**
  String get profile_title;

  /// No description provided for @profile_diseases.
  ///
  /// In ar, this message translates to:
  /// **'الأمراض المزمنة'**
  String get profile_diseases;

  /// No description provided for @profile_diseasesEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لم تُضَف أمراض بعد'**
  String get profile_diseasesEmpty;

  /// No description provided for @profile_allergies.
  ///
  /// In ar, this message translates to:
  /// **'الحساسية'**
  String get profile_allergies;

  /// No description provided for @profile_allergiesEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد حساسية مسجلة'**
  String get profile_allergiesEmpty;

  /// No description provided for @profile_medications.
  ///
  /// In ar, this message translates to:
  /// **'الأدوية والجرعات'**
  String get profile_medications;

  /// No description provided for @profile_medicationsEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لم تُضَف أدوية بعد'**
  String get profile_medicationsEmpty;

  /// No description provided for @profile_emergency.
  ///
  /// In ar, this message translates to:
  /// **'جهات الطوارئ'**
  String get profile_emergency;

  /// No description provided for @profile_emergencyEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد جهات طوارئ'**
  String get profile_emergencyEmpty;

  /// No description provided for @profile_bloodType.
  ///
  /// In ar, this message translates to:
  /// **'فصيلة الدم'**
  String get profile_bloodType;

  /// No description provided for @profile_height.
  ///
  /// In ar, this message translates to:
  /// **'الطول'**
  String get profile_height;

  /// No description provided for @profile_weight.
  ///
  /// In ar, this message translates to:
  /// **'الوزن'**
  String get profile_weight;

  /// No description provided for @profile_completeBanner.
  ///
  /// In ar, this message translates to:
  /// **'أكمل ملفك الطبي'**
  String get profile_completeBanner;

  /// No description provided for @profile_completePercent.
  ///
  /// In ar, this message translates to:
  /// **'{percent}% مكتمل'**
  String profile_completePercent(int percent);

  /// No description provided for @profile_completeNow.
  ///
  /// In ar, this message translates to:
  /// **'أكمل الآن'**
  String get profile_completeNow;

  /// No description provided for @setup_step1.
  ///
  /// In ar, this message translates to:
  /// **'البيانات الأساسية'**
  String get setup_step1;

  /// No description provided for @setup_step2.
  ///
  /// In ar, this message translates to:
  /// **'الأمراض والحساسية'**
  String get setup_step2;

  /// No description provided for @setup_step3.
  ///
  /// In ar, this message translates to:
  /// **'الأدوية والجرعات'**
  String get setup_step3;

  /// No description provided for @setup_step4.
  ///
  /// In ar, this message translates to:
  /// **'جهات الطوارئ'**
  String get setup_step4;

  /// No description provided for @setup_previous.
  ///
  /// In ar, this message translates to:
  /// **'السابق'**
  String get setup_previous;

  /// No description provided for @setup_next.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get setup_next;

  /// No description provided for @setup_save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ الملف'**
  String get setup_save;

  /// No description provided for @setup_tellUs.
  ///
  /// In ar, this message translates to:
  /// **'أخبرنا عن المريض'**
  String get setup_tellUs;

  /// No description provided for @setup_tellUsDetail.
  ///
  /// In ar, this message translates to:
  /// **'هذه المعلومات تساعدنا في تقديم رعاية أفضل'**
  String get setup_tellUsDetail;

  /// No description provided for @setup_fullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get setup_fullName;

  /// No description provided for @setup_age.
  ///
  /// In ar, this message translates to:
  /// **'العمر'**
  String get setup_age;

  /// No description provided for @setup_heightCm.
  ///
  /// In ar, this message translates to:
  /// **'الطول (سم)'**
  String get setup_heightCm;

  /// No description provided for @setup_weightKg.
  ///
  /// In ar, this message translates to:
  /// **'الوزن (كجم)'**
  String get setup_weightKg;

  /// No description provided for @setup_chronicDiseases.
  ///
  /// In ar, this message translates to:
  /// **'الأمراض المزمنة'**
  String get setup_chronicDiseases;

  /// No description provided for @setup_selectOrAdd.
  ///
  /// In ar, this message translates to:
  /// **'اختر من القائمة أو أضف يدوياً'**
  String get setup_selectOrAdd;

  /// No description provided for @setup_otherDisease.
  ///
  /// In ar, this message translates to:
  /// **'مرض آخر...'**
  String get setup_otherDisease;

  /// No description provided for @setup_addAllergy.
  ///
  /// In ar, this message translates to:
  /// **'أضف حساسية...'**
  String get setup_addAllergy;

  /// No description provided for @setup_currentMeds.
  ///
  /// In ar, this message translates to:
  /// **'الأدوية الحالية'**
  String get setup_currentMeds;

  /// No description provided for @setup_addAllMeds.
  ///
  /// In ar, this message translates to:
  /// **'أضف جميع الأدوية التي يتناولها المريض'**
  String get setup_addAllMeds;

  /// No description provided for @setup_addMed.
  ///
  /// In ar, this message translates to:
  /// **'إضافة دواء'**
  String get setup_addMed;

  /// No description provided for @setup_medName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الدواء'**
  String get setup_medName;

  /// No description provided for @setup_dosage.
  ///
  /// In ar, this message translates to:
  /// **'الجرعة (مثال: 500mg)'**
  String get setup_dosage;

  /// No description provided for @setup_frequency.
  ///
  /// In ar, this message translates to:
  /// **'التكرار'**
  String get setup_frequency;

  /// No description provided for @setup_add.
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get setup_add;

  /// No description provided for @setup_emergencyTitle.
  ///
  /// In ar, this message translates to:
  /// **'جهات الطوارئ'**
  String get setup_emergencyTitle;

  /// No description provided for @setup_emergencyDetail.
  ///
  /// In ar, this message translates to:
  /// **'أضف شخصاً واحداً على الأقل يمكن التواصل معه في الطوارئ'**
  String get setup_emergencyDetail;

  /// No description provided for @setup_addContact.
  ///
  /// In ar, this message translates to:
  /// **'إضافة جهة'**
  String get setup_addContact;

  /// No description provided for @setup_contactName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get setup_contactName;

  /// No description provided for @setup_contactPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الجوال (05xxxxxxxx)'**
  String get setup_contactPhone;

  /// No description provided for @setup_relation.
  ///
  /// In ar, this message translates to:
  /// **'صلة القرابة'**
  String get setup_relation;

  /// No description provided for @setup_whatsappAlert.
  ///
  /// In ar, this message translates to:
  /// **'سوف يتم إرسال إشعارات واتس اب لهذه الأرقام في الحالات الطارئة'**
  String get setup_whatsappAlert;

  /// No description provided for @setup_notificationOptions.
  ///
  /// In ar, this message translates to:
  /// **'خيارات التنبيهات'**
  String get setup_notificationOptions;

  /// No description provided for @setup_dailyFollowUp.
  ///
  /// In ar, this message translates to:
  /// **'متابعة يومية'**
  String get setup_dailyFollowUp;

  /// No description provided for @setup_emergencyOnly.
  ///
  /// In ar, this message translates to:
  /// **'طارئة فقط'**
  String get setup_emergencyOnly;

  /// No description provided for @setup_weeklyReport.
  ///
  /// In ar, this message translates to:
  /// **'تقرير أسبوعي'**
  String get setup_weeklyReport;

  /// No description provided for @setup_vitalsAlert.
  ///
  /// In ar, this message translates to:
  /// **'تنبيهات في حال عدم تسجيل المؤشرات الحيوية اليومية'**
  String get setup_vitalsAlert;

  /// No description provided for @setup_disease_diabetes1.
  ///
  /// In ar, this message translates to:
  /// **'السكري النوع الأول'**
  String get setup_disease_diabetes1;

  /// No description provided for @setup_disease_diabetes2.
  ///
  /// In ar, this message translates to:
  /// **'السكري النوع الثاني'**
  String get setup_disease_diabetes2;

  /// No description provided for @setup_disease_hypertension.
  ///
  /// In ar, this message translates to:
  /// **'ارتفاع ضغط الدم'**
  String get setup_disease_hypertension;

  /// No description provided for @setup_disease_heart.
  ///
  /// In ar, this message translates to:
  /// **'أمراض القلب'**
  String get setup_disease_heart;

  /// No description provided for @setup_disease_asthma.
  ///
  /// In ar, this message translates to:
  /// **'الربو'**
  String get setup_disease_asthma;

  /// No description provided for @setup_disease_kidney.
  ///
  /// In ar, this message translates to:
  /// **'أمراض الكلى'**
  String get setup_disease_kidney;

  /// No description provided for @setup_disease_osteoporosis.
  ///
  /// In ar, this message translates to:
  /// **'هشاشة العظام'**
  String get setup_disease_osteoporosis;

  /// No description provided for @setup_disease_alzheimers.
  ///
  /// In ar, this message translates to:
  /// **'الزهايمر'**
  String get setup_disease_alzheimers;

  /// No description provided for @setup_freq_once.
  ///
  /// In ar, this message translates to:
  /// **'مرة يومياً'**
  String get setup_freq_once;

  /// No description provided for @setup_freq_twice.
  ///
  /// In ar, this message translates to:
  /// **'مرتين يومياً'**
  String get setup_freq_twice;

  /// No description provided for @setup_freq_thrice.
  ///
  /// In ar, this message translates to:
  /// **'ثلاث مرات يومياً'**
  String get setup_freq_thrice;

  /// No description provided for @setup_freq_weekly.
  ///
  /// In ar, this message translates to:
  /// **'أسبوعياً'**
  String get setup_freq_weekly;

  /// No description provided for @setup_freq_asNeeded.
  ///
  /// In ar, this message translates to:
  /// **'عند الحاجة'**
  String get setup_freq_asNeeded;

  /// No description provided for @setup_rel_child.
  ///
  /// In ar, this message translates to:
  /// **'ابن/ابنة'**
  String get setup_rel_child;

  /// No description provided for @setup_rel_spouse.
  ///
  /// In ar, this message translates to:
  /// **'زوج/زوجة'**
  String get setup_rel_spouse;

  /// No description provided for @setup_rel_sibling.
  ///
  /// In ar, this message translates to:
  /// **'أخ/أخت'**
  String get setup_rel_sibling;

  /// No description provided for @setup_rel_parent.
  ///
  /// In ar, this message translates to:
  /// **'والد/والدة'**
  String get setup_rel_parent;

  /// No description provided for @setup_rel_otherRelative.
  ///
  /// In ar, this message translates to:
  /// **'قريب آخر'**
  String get setup_rel_otherRelative;

  /// No description provided for @setup_rel_friend.
  ///
  /// In ar, this message translates to:
  /// **'صديق'**
  String get setup_rel_friend;

  /// No description provided for @reading_record.
  ///
  /// In ar, this message translates to:
  /// **'سجّل {label}'**
  String reading_record(String label);

  /// No description provided for @reading_lowerBP.
  ///
  /// In ar, this message translates to:
  /// **'السفلي'**
  String get reading_lowerBP;

  /// No description provided for @reading_upperBP.
  ///
  /// In ar, this message translates to:
  /// **'العلوي'**
  String get reading_upperBP;

  /// No description provided for @reading_enterValue.
  ///
  /// In ar, this message translates to:
  /// **'أدخل القراءة'**
  String get reading_enterValue;

  /// No description provided for @reading_timing.
  ///
  /// In ar, this message translates to:
  /// **'التوقيت'**
  String get reading_timing;

  /// No description provided for @reading_fasting.
  ///
  /// In ar, this message translates to:
  /// **'صائم'**
  String get reading_fasting;

  /// No description provided for @reading_afterMeal.
  ///
  /// In ar, this message translates to:
  /// **'بعد الأكل'**
  String get reading_afterMeal;

  /// No description provided for @reading_beforeSleep.
  ///
  /// In ar, this message translates to:
  /// **'قبل النوم'**
  String get reading_beforeSleep;

  /// No description provided for @reading_submit.
  ///
  /// In ar, this message translates to:
  /// **'سجّل الآن'**
  String get reading_submit;

  /// No description provided for @reading_errorSave.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم الحفظ. حاول مرة أخرى.'**
  String get reading_errorSave;

  /// No description provided for @reading_defaultLabel.
  ///
  /// In ar, this message translates to:
  /// **'قراءتك'**
  String get reading_defaultLabel;

  /// No description provided for @reports_title.
  ///
  /// In ar, this message translates to:
  /// **'التقارير الصحية'**
  String get reports_title;

  /// No description provided for @reports_insights.
  ///
  /// In ar, this message translates to:
  /// **'رؤى ذكية'**
  String get reports_insights;

  /// No description provided for @reports_previous.
  ///
  /// In ar, this message translates to:
  /// **'التقارير السابقة'**
  String get reports_previous;

  /// No description provided for @reports_medAdherence.
  ///
  /// In ar, this message translates to:
  /// **'الالتزام بالأدوية'**
  String get reports_medAdherence;

  /// No description provided for @reports_viewReport.
  ///
  /// In ar, this message translates to:
  /// **'عرض التقرير'**
  String get reports_viewReport;

  /// No description provided for @reports_sugar.
  ///
  /// In ar, this message translates to:
  /// **'سكر'**
  String get reports_sugar;

  /// No description provided for @reports_pressure.
  ///
  /// In ar, this message translates to:
  /// **'ضغط'**
  String get reports_pressure;

  /// No description provided for @reports_readingsCount.
  ///
  /// In ar, this message translates to:
  /// **'قراءات'**
  String get reports_readingsCount;

  /// No description provided for @reports_insightsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} رؤى'**
  String reports_insightsCount(int count);

  /// No description provided for @reports_today.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get reports_today;

  /// No description provided for @reports_yesterday.
  ///
  /// In ar, this message translates to:
  /// **'أمس'**
  String get reports_yesterday;

  /// No description provided for @reports_daysAgo.
  ///
  /// In ar, this message translates to:
  /// **'قبل {count} أيام'**
  String reports_daysAgo(int count);

  /// No description provided for @consent_protectTitle.
  ///
  /// In ar, this message translates to:
  /// **'حماية بياناتك'**
  String get consent_protectTitle;

  /// No description provided for @consent_protectSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'وفقاً لنظام حماية البيانات الشخصية (PDPL) نحتاج موافقتك الصريحة'**
  String get consent_protectSubtitle;

  /// No description provided for @consent_essential.
  ///
  /// In ar, this message translates to:
  /// **'موافقات أساسية'**
  String get consent_essential;

  /// No description provided for @consent_essentialSub.
  ///
  /// In ar, this message translates to:
  /// **'مطلوبة لتشغيل الخدمة'**
  String get consent_essentialSub;

  /// No description provided for @consent_optional.
  ///
  /// In ar, this message translates to:
  /// **'موافقات اختيارية'**
  String get consent_optional;

  /// No description provided for @consent_optionalSub.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك تغييرها لاحقاً من الإعدادات'**
  String get consent_optionalSub;

  /// No description provided for @consent_readPrivacy.
  ///
  /// In ar, this message translates to:
  /// **'اقرأ سياسة الخصوصية كاملة'**
  String get consent_readPrivacy;

  /// No description provided for @consent_withdrawNote.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك سحب موافقتك في أي وقت من إعدادات الخصوصية'**
  String get consent_withdrawNote;

  /// No description provided for @consent_agreeStart.
  ///
  /// In ar, this message translates to:
  /// **'أوافق وأبدأ'**
  String get consent_agreeStart;

  /// No description provided for @consent_errorRequired.
  ///
  /// In ar, this message translates to:
  /// **'يجب الموافقة على جمع البيانات الصحية الأساسية لاستخدام التطبيق'**
  String get consent_errorRequired;

  /// No description provided for @consent_errorSave.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر حفظ الموافقات. حاول مرة أخرى.'**
  String get consent_errorSave;

  /// No description provided for @consent_type_healthData.
  ///
  /// In ar, this message translates to:
  /// **'جمع البيانات الصحية'**
  String get consent_type_healthData;

  /// No description provided for @consent_type_healthDataDesc.
  ///
  /// In ar, this message translates to:
  /// **'نحتاج موافقتك لجمع القراءات الصحية مثل السكر والضغط لمتابعة حالة المريض.'**
  String get consent_type_healthDataDesc;

  /// No description provided for @consent_type_ai.
  ///
  /// In ar, this message translates to:
  /// **'تحليل الذكاء الاصطناعي'**
  String get consent_type_ai;

  /// No description provided for @consent_type_aiDesc.
  ///
  /// In ar, this message translates to:
  /// **'يستخدم يمينك الذكاء الاصطناعي لتحليل القراءات وتقديم إرشادات صحية. يتم إخفاء هوية المريض قبل التحليل.'**
  String get consent_type_aiDesc;

  /// No description provided for @consent_type_whatsapp.
  ///
  /// In ar, this message translates to:
  /// **'إشعارات واتساب'**
  String get consent_type_whatsapp;

  /// No description provided for @consent_type_whatsappDesc.
  ///
  /// In ar, this message translates to:
  /// **'إرسال تنبيهات القراءات غير الطبيعية والتقارير الأسبوعية لأفراد الأسرة عبر واتساب.'**
  String get consent_type_whatsappDesc;

  /// No description provided for @consent_type_push.
  ///
  /// In ar, this message translates to:
  /// **'إشعارات التطبيق'**
  String get consent_type_push;

  /// No description provided for @consent_type_pushDesc.
  ///
  /// In ar, this message translates to:
  /// **'تذكيرات تسجيل القراءات والتنبيهات الفورية داخل التطبيق.'**
  String get consent_type_pushDesc;

  /// No description provided for @consent_type_analytics.
  ///
  /// In ar, this message translates to:
  /// **'التحليلات والتحسين'**
  String get consent_type_analytics;

  /// No description provided for @consent_type_analyticsDesc.
  ///
  /// In ar, this message translates to:
  /// **'بيانات مجهولة الهوية لتحسين أداء التطبيق وتجربة المستخدم.'**
  String get consent_type_analyticsDesc;

  /// No description provided for @consent_type_marketing.
  ///
  /// In ar, this message translates to:
  /// **'التسويق'**
  String get consent_type_marketing;

  /// No description provided for @consent_type_marketingDesc.
  ///
  /// In ar, this message translates to:
  /// **'إرسال عروض ومعلومات عن خدمات إضافية قد تفيدك.'**
  String get consent_type_marketingDesc;

  /// No description provided for @privacy_title.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الخصوصية'**
  String get privacy_title;

  /// No description provided for @privacy_pdplTitle.
  ///
  /// In ar, this message translates to:
  /// **'حماية البيانات الشخصية'**
  String get privacy_pdplTitle;

  /// No description provided for @privacy_pdplSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'يمينك ملتزم بنظام PDPL الصادر عن سدايا'**
  String get privacy_pdplSubtitle;

  /// No description provided for @privacy_manageConsents.
  ///
  /// In ar, this message translates to:
  /// **'إدارة الموافقات'**
  String get privacy_manageConsents;

  /// No description provided for @privacy_yourRights.
  ///
  /// In ar, this message translates to:
  /// **'حقوقك'**
  String get privacy_yourRights;

  /// No description provided for @privacy_downloadData.
  ///
  /// In ar, this message translates to:
  /// **'تحميل بياناتي'**
  String get privacy_downloadData;

  /// No description provided for @privacy_downloadDataSub.
  ///
  /// In ar, this message translates to:
  /// **'تحميل نسخة كاملة من جميع بياناتك'**
  String get privacy_downloadDataSub;

  /// No description provided for @privacy_deleteAccount.
  ///
  /// In ar, this message translates to:
  /// **'حذف حسابي وبياناتي'**
  String get privacy_deleteAccount;

  /// No description provided for @privacy_deleteAccountSub.
  ///
  /// In ar, this message translates to:
  /// **'حذف جميع البيانات نهائياً — لا يمكن التراجع'**
  String get privacy_deleteAccountSub;

  /// No description provided for @privacy_policy.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get privacy_policy;

  /// No description provided for @privacy_essential.
  ///
  /// In ar, this message translates to:
  /// **'أساسي'**
  String get privacy_essential;

  /// No description provided for @privacy_consentRevoked.
  ///
  /// In ar, this message translates to:
  /// **'تم سحب الموافقة: {label}'**
  String privacy_consentRevoked(String label);

  /// No description provided for @privacy_exportSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تجهيز بياناتك بنجاح. عدد السجلات: {count}'**
  String privacy_exportSuccess(int count);

  /// No description provided for @privacy_exportError.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحميل البيانات. حاول مرة أخرى.'**
  String get privacy_exportError;

  /// No description provided for @privacy_deleteTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف الحساب'**
  String get privacy_deleteTitle;

  /// No description provided for @privacy_deleteMsg.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف حسابك وجميع بياناتك الصحية؟\n\nهذا الإجراء لا يمكن التراجع عنه.'**
  String get privacy_deleteMsg;

  /// No description provided for @privacy_deleteConfirm.
  ///
  /// In ar, this message translates to:
  /// **'نعم، احذف'**
  String get privacy_deleteConfirm;

  /// No description provided for @privacy_deleteFinalTitle.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد نهائي'**
  String get privacy_deleteFinalTitle;

  /// No description provided for @privacy_deleteFinalMsg.
  ///
  /// In ar, this message translates to:
  /// **'سيتم حذف:\n• جميع بيانات المريض الصحية\n• القراءات والمحادثات\n• الحجوزات والإشعارات\n• حسابك بالكامل\n\nلن تتمكن من استعادة هذه البيانات.'**
  String get privacy_deleteFinalMsg;

  /// No description provided for @privacy_deleteFinal.
  ///
  /// In ar, this message translates to:
  /// **'احذف نهائياً'**
  String get privacy_deleteFinal;

  /// No description provided for @privacy_deleteError.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر حذف الحساب. حاول مرة أخرى.'**
  String get privacy_deleteError;

  /// No description provided for @services_title.
  ///
  /// In ar, this message translates to:
  /// **'سوق الخدمات'**
  String get services_title;

  /// No description provided for @services_searchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن خدمة...'**
  String get services_searchHint;

  /// No description provided for @services_noServices.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد خدمات في هذا التصنيف'**
  String get services_noServices;

  /// No description provided for @services_catAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get services_catAll;

  /// No description provided for @services_catNursing.
  ///
  /// In ar, this message translates to:
  /// **'تمريض'**
  String get services_catNursing;

  /// No description provided for @services_catPhysio.
  ///
  /// In ar, this message translates to:
  /// **'علاج طبيعي'**
  String get services_catPhysio;

  /// No description provided for @services_catCompanion.
  ///
  /// In ar, this message translates to:
  /// **'مرافقة'**
  String get services_catCompanion;

  /// No description provided for @services_catTests.
  ///
  /// In ar, this message translates to:
  /// **'فحوصات'**
  String get services_catTests;

  /// No description provided for @services_catConsult.
  ///
  /// In ar, this message translates to:
  /// **'استشارات'**
  String get services_catConsult;

  /// No description provided for @services_catPharmacy.
  ///
  /// In ar, this message translates to:
  /// **'صيدلية'**
  String get services_catPharmacy;

  /// No description provided for @plus_upgradeTitle.
  ///
  /// In ar, this message translates to:
  /// **'قم بالترقية إلى يمينك بلس'**
  String get plus_upgradeTitle;

  /// No description provided for @plus_upgradeSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'استمتع بتجربة رعاية صحية ذكية متكاملة\nومصممة خصيصاً لاحتياجاتك'**
  String get plus_upgradeSubtitle;

  /// No description provided for @plus_features.
  ///
  /// In ar, this message translates to:
  /// **'مميزات العضوية'**
  String get plus_features;

  /// No description provided for @plus_whatsappTitle.
  ///
  /// In ar, this message translates to:
  /// **'تنبيهات واتساب ذكية'**
  String get plus_whatsappTitle;

  /// No description provided for @plus_whatsappDesc.
  ///
  /// In ar, this message translates to:
  /// **'إشعارات فورية وتقارير يومية تصلك مباشرة على واتساب لسهولة المتابعة.'**
  String get plus_whatsappDesc;

  /// No description provided for @plus_aiTitle.
  ///
  /// In ar, this message translates to:
  /// **'تحليلات الذكاء الاصطناعي'**
  String get plus_aiTitle;

  /// No description provided for @plus_aiDesc.
  ///
  /// In ar, this message translates to:
  /// **'تحليل عميق للبيانات الصحية لاكتشاف الأنماط وتقديم توصيات وقائية ذكية.'**
  String get plus_aiDesc;

  /// No description provided for @plus_monitorTitle.
  ///
  /// In ar, this message translates to:
  /// **'متابعة لحظية'**
  String get plus_monitorTitle;

  /// No description provided for @plus_monitorDesc.
  ///
  /// In ar, this message translates to:
  /// **'رصد مستمر للمؤشرات الحيوية مع تنبيهات عند أي قراءات خارج النطاق الطبيعي.'**
  String get plus_monitorDesc;

  /// No description provided for @plus_choosePlan.
  ///
  /// In ar, this message translates to:
  /// **'اختر خطتك'**
  String get plus_choosePlan;

  /// No description provided for @plus_yearly.
  ///
  /// In ar, this message translates to:
  /// **'سنوي'**
  String get plus_yearly;

  /// No description provided for @plus_monthly.
  ///
  /// In ar, this message translates to:
  /// **'شهري'**
  String get plus_monthly;

  /// No description provided for @plus_yearlyPrice.
  ///
  /// In ar, this message translates to:
  /// **'٢٤٩'**
  String get plus_yearlyPrice;

  /// No description provided for @plus_monthlyPrice.
  ///
  /// In ar, this message translates to:
  /// **'٢٤٩'**
  String get plus_monthlyPrice;

  /// No description provided for @plus_perYear.
  ///
  /// In ar, this message translates to:
  /// **'ر.س / سنة'**
  String get plus_perYear;

  /// No description provided for @plus_perMonth.
  ///
  /// In ar, this message translates to:
  /// **'ر.س / شهر'**
  String get plus_perMonth;

  /// No description provided for @plus_save29.
  ///
  /// In ar, this message translates to:
  /// **'وفّر ٢٩٪'**
  String get plus_save29;

  /// No description provided for @plus_subscribe.
  ///
  /// In ar, this message translates to:
  /// **'اشترك الآن'**
  String get plus_subscribe;

  /// No description provided for @plus_terms.
  ///
  /// In ar, this message translates to:
  /// **'بالاشتراك، أنت توافق على الشروط والأحكام وسياسة الخصوصية.'**
  String get plus_terms;

  /// No description provided for @plus_welcomeMsg.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك في يمينك بلس! 🎉'**
  String get plus_welcomeMsg;

  /// No description provided for @plus_termsLink.
  ///
  /// In ar, this message translates to:
  /// **'الشروط والأحكام'**
  String get plus_termsLink;

  /// No description provided for @plus_privacyLink.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get plus_privacyLink;

  /// No description provided for @plus_appleInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات مهمة'**
  String get plus_appleInfo;

  /// No description provided for @plus_autoRenew.
  ///
  /// In ar, this message translates to:
  /// **'يتجدد الاشتراك تلقائياً كل شهر ما لم يتم إلغاؤه قبل ٢٤ ساعة من نهاية الفترة الحالية.'**
  String get plus_autoRenew;

  /// No description provided for @plus_cancelInfo.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك إلغاء الاشتراك في أي وقت من إعدادات حساب Apple ID.'**
  String get plus_cancelInfo;

  /// No description provided for @plus_noRefund.
  ///
  /// In ar, this message translates to:
  /// **'لا يتم استرداد المبلغ عن أي جزء غير مستخدم من فترة الاشتراك الحالية.'**
  String get plus_noRefund;

  /// No description provided for @gate_exclusive.
  ///
  /// In ar, this message translates to:
  /// **'ميزة حصرية ليمينك بلس'**
  String get gate_exclusive;

  /// No description provided for @gate_subscribeFor.
  ///
  /// In ar, this message translates to:
  /// **'اشترك في يمينك بلس للوصول إلى {feature}\nوجميع المميزات المتقدمة'**
  String gate_subscribeFor(String feature);

  /// No description provided for @gate_upgrade.
  ///
  /// In ar, this message translates to:
  /// **'ترقية ليمينك بلس'**
  String get gate_upgrade;

  /// No description provided for @status_normal.
  ///
  /// In ar, this message translates to:
  /// **'طبيعي'**
  String get status_normal;

  /// No description provided for @status_needsAttention.
  ///
  /// In ar, this message translates to:
  /// **'يحتاج متابعة'**
  String get status_needsAttention;

  /// No description provided for @status_alert.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه'**
  String get status_alert;

  /// No description provided for @success_title.
  ///
  /// In ar, this message translates to:
  /// **'تم التسجيل ✅'**
  String get success_title;

  /// No description provided for @success_subtitle.
  ///
  /// In ar, this message translates to:
  /// **'شكراً! تم حفظ قراءتك بنجاح'**
  String get success_subtitle;

  /// No description provided for @language_toggle.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get language_toggle;

  /// No description provided for @disclaimer_title.
  ///
  /// In ar, this message translates to:
  /// **'إخلاء مسؤولية طبية'**
  String get disclaimer_title;

  /// No description provided for @disclaimer_point1.
  ///
  /// In ar, this message translates to:
  /// **'هذا التطبيق لا يقدم تشخيصاً طبياً ولا يُغني عن استشارة الطبيب المختص.'**
  String get disclaimer_point1;

  /// No description provided for @disclaimer_point2.
  ///
  /// In ar, this message translates to:
  /// **'جميع القراءات والتنبيهات هي لأغراض المتابعة فقط ولا تمثل رأياً طبياً.'**
  String get disclaimer_point2;

  /// No description provided for @disclaimer_point3.
  ///
  /// In ar, this message translates to:
  /// **'في حالات الطوارئ، يجب التوجه فوراً إلى أقرب مستشفى أو الاتصال بالرقم 997.'**
  String get disclaimer_point3;

  /// No description provided for @disclaimer_accept.
  ///
  /// In ar, this message translates to:
  /// **'قرأتُ وأوافق'**
  String get disclaimer_accept;

  /// No description provided for @disclaimer_footer.
  ///
  /// In ar, this message translates to:
  /// **'باستخدامك التطبيق فإنك توافق على أن يمينك أداة متابعة فقط وليست بديلاً عن الرعاية الطبية.'**
  String get disclaimer_footer;

  /// No description provided for @chat_aiDisclaimer.
  ///
  /// In ar, this message translates to:
  /// **'⚕️ أمين مساعد صحي ذكي وليس طبيباً. لا يقدم وصفات طبية. استشر طبيبك دائماً في القرارات الطبية.'**
  String get chat_aiDisclaimer;

  /// No description provided for @privacy_noDataSelling.
  ///
  /// In ar, this message translates to:
  /// **'بياناتك الصحية لا تُباع ولا تُشارك مع أي طرف ثالث لأغراض إعلانية أو تجارية.'**
  String get privacy_noDataSelling;

  /// No description provided for @dashboard_lastUpdated.
  ///
  /// In ar, this message translates to:
  /// **'آخر تحديث: قبل ٥ دقائق'**
  String get dashboard_lastUpdated;

  /// No description provided for @dashboard_recentActivities.
  ///
  /// In ar, this message translates to:
  /// **'الأنشطة الأخيرة'**
  String get dashboard_recentActivities;

  /// No description provided for @dashboard_viewAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get dashboard_viewAll;

  /// No description provided for @dashboard_completeProfileBanner.
  ///
  /// In ar, this message translates to:
  /// **'أكمل ملفك الطبي الآن للمتابعة الذكية.'**
  String get dashboard_completeProfileBanner;

  /// No description provided for @dashboard_completeBtn.
  ///
  /// In ar, this message translates to:
  /// **'أكمل'**
  String get dashboard_completeBtn;

  /// No description provided for @dashboard_patientStatus.
  ///
  /// In ar, this message translates to:
  /// **'حالة {name}'**
  String dashboard_patientStatus(String name);

  /// No description provided for @dashboard_statusExcellent.
  ///
  /// In ar, this message translates to:
  /// **'مستقر وممتاز اليوم'**
  String get dashboard_statusExcellent;

  /// No description provided for @dashboard_stablePulse.
  ///
  /// In ar, this message translates to:
  /// **'نبض مستقر'**
  String get dashboard_stablePulse;

  /// No description provided for @dashboard_talkToAI.
  ///
  /// In ar, this message translates to:
  /// **'تحدث مع المساعد الذكي'**
  String get dashboard_talkToAI;

  /// No description provided for @dashboard_aiSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'استشارة طبية سريعة مع الذكاء الاصطناعي'**
  String get dashboard_aiSubtitle;

  /// No description provided for @dashboard_actInsulin.
  ///
  /// In ar, this message translates to:
  /// **'تناول الإنسولين (ميتفورمين)'**
  String get dashboard_actInsulin;

  /// No description provided for @dashboard_act1hAgo.
  ///
  /// In ar, this message translates to:
  /// **'قبل ساعة'**
  String get dashboard_act1hAgo;

  /// No description provided for @dashboard_actCompleted.
  ///
  /// In ar, this message translates to:
  /// **'مكتمل'**
  String get dashboard_actCompleted;

  /// No description provided for @dashboard_actCheckup.
  ///
  /// In ar, this message translates to:
  /// **'فحص دوري - د. أحمد'**
  String get dashboard_actCheckup;

  /// No description provided for @dashboard_actTomorrow.
  ///
  /// In ar, this message translates to:
  /// **'غداً ١٠:٠٠ صباحاً'**
  String get dashboard_actTomorrow;

  /// No description provided for @dashboard_actUpcoming.
  ///
  /// In ar, this message translates to:
  /// **'قادم'**
  String get dashboard_actUpcoming;

  /// No description provided for @dashboard_vitalBP.
  ///
  /// In ar, this message translates to:
  /// **'ضغط الدم'**
  String get dashboard_vitalBP;

  /// No description provided for @dashboard_vitalSugar.
  ///
  /// In ar, this message translates to:
  /// **'السكر'**
  String get dashboard_vitalSugar;

  /// No description provided for @dashboard_vitalHR.
  ///
  /// In ar, this message translates to:
  /// **'نبض القلب'**
  String get dashboard_vitalHR;

  /// No description provided for @dashboard_vitalO2.
  ///
  /// In ar, this message translates to:
  /// **'الأكسجين'**
  String get dashboard_vitalO2;

  /// No description provided for @nav_home.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get nav_home;

  /// No description provided for @nav_assistant.
  ///
  /// In ar, this message translates to:
  /// **'المساعد'**
  String get nav_assistant;

  /// No description provided for @nav_services.
  ///
  /// In ar, this message translates to:
  /// **'الخدمات'**
  String get nav_services;

  /// No description provided for @nav_reports.
  ///
  /// In ar, this message translates to:
  /// **'التقارير'**
  String get nav_reports;

  /// No description provided for @nav_profile.
  ///
  /// In ar, this message translates to:
  /// **'الملف'**
  String get nav_profile;

  /// No description provided for @welcome_subtitle.
  ///
  /// In ar, this message translates to:
  /// **'نظام الرعاية المتكاملة'**
  String get welcome_subtitle;

  /// No description provided for @welcome_tagline.
  ///
  /// In ar, this message translates to:
  /// **'سندك الذكي لرعاية من تحب..'**
  String get welcome_tagline;

  /// No description provided for @welcome_tagline2.
  ///
  /// In ar, this message translates to:
  /// **'طمأنينة لك، وعناية تليق بهم.'**
  String get welcome_tagline2;

  /// No description provided for @welcome_getStarted.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ الآن'**
  String get welcome_getStarted;

  /// No description provided for @welcome_footer.
  ///
  /// In ar, this message translates to:
  /// **'Care Reimagined • Yameenak Saudi Arabia'**
  String get welcome_footer;

  /// No description provided for @password_tooShort.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور يجب أن تكون 8 أحرف على الأقل'**
  String get password_tooShort;

  /// No description provided for @password_needsUppercase.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور يجب أن تحتوي على حرف كبير واحد على الأقل'**
  String get password_needsUppercase;

  /// No description provided for @password_needsDigit.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور يجب أن تحتوي على رقم واحد على الأقل'**
  String get password_needsDigit;

  /// No description provided for @reports_generating.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ إنشاء التقرير...'**
  String get reports_generating;

  /// No description provided for @setup_featureComingSoon.
  ///
  /// In ar, this message translates to:
  /// **'هذه الميزة قادمة قريباً!'**
  String get setup_featureComingSoon;

  /// No description provided for @setup_stepOf.
  ///
  /// In ar, this message translates to:
  /// **'الخطوة {current} من {total}'**
  String setup_stepOf(int current, int total);

  /// No description provided for @setup_progressSaved.
  ///
  /// In ar, this message translates to:
  /// **'يتم الحفظ تلقائياً'**
  String get setup_progressSaved;

  /// No description provided for @setup_nextDiseases.
  ///
  /// In ar, this message translates to:
  /// **'التالي: الأمراض المزمنة'**
  String get setup_nextDiseases;

  /// No description provided for @setup_nextMeds.
  ///
  /// In ar, this message translates to:
  /// **'التالي: الأدوية'**
  String get setup_nextMeds;

  /// No description provided for @setup_nextEmergency.
  ///
  /// In ar, this message translates to:
  /// **'التالي: جهات الطوارئ'**
  String get setup_nextEmergency;

  /// No description provided for @setup_welcomeCaregiver.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً، مقدّم الرعاية'**
  String get setup_welcomeCaregiver;

  /// No description provided for @setup_settingUpProfile.
  ///
  /// In ar, this message translates to:
  /// **'أنت تقوم بإعداد\nملف الشخص العزيز عليك.'**
  String get setup_settingUpProfile;

  /// No description provided for @setup_tailorExperience.
  ///
  /// In ar, this message translates to:
  /// **'هذه المعلومات تساعدنا في تخصيص تجربة الرعاية الصحية حسب احتياجاتهم البيولوجية والصحية.'**
  String get setup_tailorExperience;

  /// No description provided for @setup_enterFullName.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الاسم الكامل'**
  String get setup_enterFullName;

  /// No description provided for @setup_ageInYears.
  ///
  /// In ar, this message translates to:
  /// **'العمر بالسنوات'**
  String get setup_ageInYears;

  /// No description provided for @setup_gender.
  ///
  /// In ar, this message translates to:
  /// **'الجنس'**
  String get setup_gender;

  /// No description provided for @setup_male.
  ///
  /// In ar, this message translates to:
  /// **'ذكر'**
  String get setup_male;

  /// No description provided for @setup_female.
  ///
  /// In ar, this message translates to:
  /// **'أنثى'**
  String get setup_female;

  /// No description provided for @setup_whyMattersLabel.
  ///
  /// In ar, this message translates to:
  /// **'لماذا هذا مهم: '**
  String get setup_whyMattersLabel;

  /// No description provided for @setup_whyBasicInfo.
  ///
  /// In ar, this message translates to:
  /// **'تقديم معلومات أساسية دقيقة يسمح لنظام الذكاء الاصطناعي بحساب مستويات الجرعات الصحيحة وعوامل الخطورة الصحية بناءً على المعايير الديموغرافية.'**
  String get setup_whyBasicInfo;

  /// No description provided for @setup_allergyHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: بنسلين، فول سوداني، لاتكس...'**
  String get setup_allergyHint;

  /// No description provided for @setup_addAllergyBtn.
  ///
  /// In ar, this message translates to:
  /// **'إضافة حساسية'**
  String get setup_addAllergyBtn;

  /// No description provided for @setup_whyMattersQ.
  ///
  /// In ar, this message translates to:
  /// **'لماذا هذا مهم؟'**
  String get setup_whyMattersQ;

  /// No description provided for @setup_whyMedHistory.
  ///
  /// In ar, this message translates to:
  /// **'تاريخك الطبي يساعد نظام الرعاية الذكية لدينا على منع التداخلات الدوائية وتصميم خطة التغذية خصيصاً لاحتياجاتك.'**
  String get setup_whyMedHistory;

  /// No description provided for @setup_medNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم الدواء'**
  String get setup_medNameLabel;

  /// No description provided for @setup_doseHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: 500 ملجم، مرتين يومياً'**
  String get setup_doseHint;

  /// No description provided for @setup_doseLabel.
  ///
  /// In ar, this message translates to:
  /// **'الجرعة والتكرار'**
  String get setup_doseLabel;

  /// No description provided for @setup_addMedBtn.
  ///
  /// In ar, this message translates to:
  /// **'إضافة دواء'**
  String get setup_addMedBtn;

  /// No description provided for @setup_aiTip.
  ///
  /// In ar, this message translates to:
  /// **'نصيحة المساعد الذكي'**
  String get setup_aiTip;

  /// No description provided for @setup_aiTipDetail.
  ///
  /// In ar, this message translates to:
  /// **'الدقة مهمة. إذا لم تكن متأكداً من الجرعة، استخدم ميزة تحميل الصور ليتحقق نظامنا الطبي الذكي من التفاصيل.'**
  String get setup_aiTipDetail;

  /// No description provided for @setup_uploadPrescription.
  ///
  /// In ar, this message translates to:
  /// **'تحميل الوصفة الطبية'**
  String get setup_uploadPrescription;

  /// No description provided for @setup_aiExtractInfo.
  ///
  /// In ar, this message translates to:
  /// **'سيقوم الذكاء الاصطناعي باستخراج أسماء الأدوية والجرعات والجداول.'**
  String get setup_aiExtractInfo;

  /// No description provided for @setup_browseFiles.
  ///
  /// In ar, this message translates to:
  /// **'تصفح الملفات'**
  String get setup_browseFiles;

  /// No description provided for @setup_contactNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم جهة الاتصال'**
  String get setup_contactNameLabel;

  /// No description provided for @setup_relationLabel.
  ///
  /// In ar, this message translates to:
  /// **'صلة القرابة'**
  String get setup_relationLabel;

  /// No description provided for @setup_phoneLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get setup_phoneLabel;

  /// No description provided for @setup_addAnotherContact.
  ///
  /// In ar, this message translates to:
  /// **'إضافة جهة اتصال أخرى'**
  String get setup_addAnotherContact;

  /// No description provided for @setup_optionalSettings.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات اختيارية'**
  String get setup_optionalSettings;

  /// No description provided for @setup_dailyCareFeature.
  ///
  /// In ar, this message translates to:
  /// **'ميزة الرعاية اليومية'**
  String get setup_dailyCareFeature;

  /// No description provided for @setup_vitalsLogging.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل المؤشرات الحيوية'**
  String get setup_vitalsLogging;

  /// No description provided for @setup_vitalsLoggingDetail.
  ///
  /// In ar, this message translates to:
  /// **'بمجرد تفعيل ملفك، سنساعدك في تسجيل القراءات الحيوية مثل السكر والضغط يومياً.'**
  String get setup_vitalsLoggingDetail;

  /// No description provided for @setup_dataPrivacy.
  ///
  /// In ar, this message translates to:
  /// **'خصوصية وأمان البيانات'**
  String get setup_dataPrivacy;

  /// No description provided for @setup_dataPrivacyDetail.
  ///
  /// In ar, this message translates to:
  /// **'بياناتك الطبية مشفّرة ولا تُشارك إلا مع فريقك الطبي المعتمد وأفراد أسرتك.'**
  String get setup_dataPrivacyDetail;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return SAr();
    case 'en':
      return SEn();
  }

  throw FlutterError(
      'S.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
