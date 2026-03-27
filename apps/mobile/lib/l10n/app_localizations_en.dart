// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Yameenak';

  @override
  String get tagline => 'Your family\'s peace of mind in your hands';

  @override
  String get login_title => 'Sign In';

  @override
  String get login_subtitle => 'Enter your phone number to continue';

  @override
  String get login_phoneHint => '5XXXXXXXX';

  @override
  String get login_sendOtp => 'Send Verification Code';

  @override
  String get login_otpTitle => 'Verification Code';

  @override
  String login_otpSubtitle(String phone) {
    return 'Enter the code sent to $phone';
  }

  @override
  String get login_confirm => 'Confirm';

  @override
  String get login_changeNumber => 'Change Number';

  @override
  String get login_resend => 'Resend';

  @override
  String login_resendTimer(int seconds) {
    return 'Resend ($seconds)';
  }

  @override
  String get login_errorPhone => 'Enter your phone number';

  @override
  String get login_errorPhoneInvalid =>
      'Enter a valid Saudi number (5XXXXXXXX)';

  @override
  String get login_errorOtpSend => 'Failed to send code. Check your number.';

  @override
  String get login_errorOtpLength => 'Enter the 6-digit code';

  @override
  String get login_errorOtpInvalid => 'Invalid code. Try again.';

  @override
  String get dashboard_greeting => 'Hello 👋';

  @override
  String get dashboard_subtitle => 'Patient health monitoring';

  @override
  String get dashboard_recordReading => 'Record Reading';

  @override
  String get dashboard_services => 'Services';

  @override
  String get dashboard_errorLoad => 'Failed to load patient data';

  @override
  String get dashboard_errorDetail => 'Check your internet connection';

  @override
  String get dashboard_weekSummary => 'Week Summary';

  @override
  String get dashboard_alerts => 'Alerts';

  @override
  String get dashboard_normal => 'Normal';

  @override
  String get dashboard_total => 'Total';

  @override
  String get dashboard_medicalProfile => 'Medical Profile';

  @override
  String get dashboard_healthReports => 'Health Reports';

  @override
  String get dashboard_marketplace => 'Services Market';

  @override
  String get dashboard_healthChat => 'Health Chat';

  @override
  String get dashboard_upgradePlus => 'Upgrade to Yameenak Plus';

  @override
  String get dashboard_plusFeatures =>
      'WhatsApp alerts · Smart analytics · Real-time monitoring';

  @override
  String get dashboard_readingLabel => 'Blood Sugar Reading';

  @override
  String common_years(int count) {
    return '$count years';
  }

  @override
  String get common_retry => 'Try Again';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_back => 'Back';

  @override
  String common_error(String message) {
    return 'Error: $message';
  }

  @override
  String get common_cm => 'cm';

  @override
  String get common_kg => 'kg';

  @override
  String get common_sar => 'SAR';

  @override
  String get chat_title => 'Health Chat';

  @override
  String get chat_errorLoad => 'Failed to load conversation';

  @override
  String get chat_errorDetail => 'Check your internet connection';

  @override
  String get chat_inputHint => 'Ask about your parent...';

  @override
  String get chat_q1 => 'Is the reading normal?';

  @override
  String get chat_q2 => 'What medications are they taking?';

  @override
  String get chat_q3 => 'When was the last reading?';

  @override
  String get chat_q4 => 'Do they need a doctor?';

  @override
  String get profile_title => 'Medical Profile';

  @override
  String get profile_diseases => 'Chronic Diseases';

  @override
  String get profile_diseasesEmpty => 'No diseases added yet';

  @override
  String get profile_allergies => 'Allergies';

  @override
  String get profile_allergiesEmpty => 'No allergies recorded';

  @override
  String get profile_medications => 'Medications & Dosages';

  @override
  String get profile_medicationsEmpty => 'No medications added yet';

  @override
  String get profile_emergency => 'Emergency Contacts';

  @override
  String get profile_emergencyEmpty => 'No emergency contacts';

  @override
  String get profile_bloodType => 'Blood Type';

  @override
  String get profile_height => 'Height';

  @override
  String get profile_weight => 'Weight';

  @override
  String get profile_completeBanner => 'Complete your medical profile';

  @override
  String profile_completePercent(int percent) {
    return '$percent% complete';
  }

  @override
  String get profile_completeNow => 'Complete Now';

  @override
  String get setup_step1 => 'Basic Information';

  @override
  String get setup_step2 => 'Diseases & Allergies';

  @override
  String get setup_step3 => 'Medications & Dosages';

  @override
  String get setup_step4 => 'Emergency Contacts';

  @override
  String get setup_previous => 'Previous';

  @override
  String get setup_next => 'Next';

  @override
  String get setup_save => 'Save Profile';

  @override
  String get setup_tellUs => 'Tell us about the patient';

  @override
  String get setup_tellUsDetail =>
      'This information helps us provide better care';

  @override
  String get setup_fullName => 'Full Name';

  @override
  String get setup_age => 'Age';

  @override
  String get setup_heightCm => 'Height (cm)';

  @override
  String get setup_weightKg => 'Weight (kg)';

  @override
  String get setup_chronicDiseases => 'Chronic Diseases';

  @override
  String get setup_selectOrAdd => 'Select from the list or add manually';

  @override
  String get setup_otherDisease => 'Other disease...';

  @override
  String get setup_addAllergy => 'Add allergy...';

  @override
  String get setup_currentMeds => 'Current Medications';

  @override
  String get setup_addAllMeds => 'Add all medications the patient is taking';

  @override
  String get setup_addMed => 'Add Medication';

  @override
  String get setup_medName => 'Medication Name';

  @override
  String get setup_dosage => 'Dosage (e.g. 500mg)';

  @override
  String get setup_frequency => 'Frequency';

  @override
  String get setup_add => 'Add';

  @override
  String get setup_emergencyTitle => 'Emergency Contacts';

  @override
  String get setup_emergencyDetail =>
      'Add at least one person who can be contacted in emergencies';

  @override
  String get setup_addContact => 'Add Contact';

  @override
  String get setup_contactName => 'Full Name';

  @override
  String get setup_contactPhone => 'Phone Number (05xxxxxxxx)';

  @override
  String get setup_relation => 'Relationship';

  @override
  String get setup_whatsappAlert =>
      'WhatsApp notifications will be sent to these numbers in emergency cases';

  @override
  String get setup_notificationOptions => 'Notification Options';

  @override
  String get setup_dailyFollowUp => 'Daily Follow-up';

  @override
  String get setup_emergencyOnly => 'Emergency Only';

  @override
  String get setup_weeklyReport => 'Weekly Report';

  @override
  String get setup_vitalsAlert => 'Alerts if daily vitals are not recorded';

  @override
  String get setup_disease_diabetes1 => 'Type 1 Diabetes';

  @override
  String get setup_disease_diabetes2 => 'Type 2 Diabetes';

  @override
  String get setup_disease_hypertension => 'Hypertension';

  @override
  String get setup_disease_heart => 'Heart Disease';

  @override
  String get setup_disease_asthma => 'Asthma';

  @override
  String get setup_disease_kidney => 'Kidney Disease';

  @override
  String get setup_disease_osteoporosis => 'Osteoporosis';

  @override
  String get setup_disease_alzheimers => 'Alzheimer\'s';

  @override
  String get setup_freq_once => 'Once daily';

  @override
  String get setup_freq_twice => 'Twice daily';

  @override
  String get setup_freq_thrice => 'Three times daily';

  @override
  String get setup_freq_weekly => 'Weekly';

  @override
  String get setup_freq_asNeeded => 'As needed';

  @override
  String get setup_rel_child => 'Son/Daughter';

  @override
  String get setup_rel_spouse => 'Spouse';

  @override
  String get setup_rel_sibling => 'Brother/Sister';

  @override
  String get setup_rel_parent => 'Parent';

  @override
  String get setup_rel_otherRelative => 'Other Relative';

  @override
  String get setup_rel_friend => 'Friend';

  @override
  String reading_record(String label) {
    return 'Record $label';
  }

  @override
  String get reading_lowerBP => 'Diastolic';

  @override
  String get reading_upperBP => 'Systolic';

  @override
  String get reading_enterValue => 'Enter reading';

  @override
  String get reading_timing => 'Timing';

  @override
  String get reading_fasting => 'Fasting';

  @override
  String get reading_afterMeal => 'After Meal';

  @override
  String get reading_beforeSleep => 'Before Sleep';

  @override
  String get reading_submit => 'Record Now';

  @override
  String get reading_errorSave => 'Not saved. Try again.';

  @override
  String get reading_defaultLabel => 'Your reading';

  @override
  String get reports_title => 'Health Reports';

  @override
  String get reports_insights => 'Smart Insights';

  @override
  String get reports_previous => 'Previous Reports';

  @override
  String get reports_medAdherence => 'Medication Adherence';

  @override
  String get reports_viewReport => 'View Report';

  @override
  String get reports_sugar => 'Sugar';

  @override
  String get reports_pressure => 'Pressure';

  @override
  String get reports_readingsCount => 'Readings';

  @override
  String reports_insightsCount(int count) {
    return '$count insights';
  }

  @override
  String get reports_today => 'Today';

  @override
  String get reports_yesterday => 'Yesterday';

  @override
  String reports_daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get consent_protectTitle => 'Protecting Your Data';

  @override
  String get consent_protectSubtitle =>
      'Per the Personal Data Protection Law (PDPL), we need your explicit consent';

  @override
  String get consent_essential => 'Essential Consents';

  @override
  String get consent_essentialSub => 'Required for service operation';

  @override
  String get consent_optional => 'Optional Consents';

  @override
  String get consent_optionalSub => 'You can change these later in settings';

  @override
  String get consent_readPrivacy => 'Read full privacy policy';

  @override
  String get consent_withdrawNote =>
      'You can withdraw your consent at any time from privacy settings';

  @override
  String get consent_agreeStart => 'Agree & Start';

  @override
  String get consent_errorRequired =>
      'You must consent to essential health data collection to use the app';

  @override
  String get consent_errorSave => 'Failed to save consents. Try again.';

  @override
  String get consent_type_healthData => 'Health Data Collection';

  @override
  String get consent_type_healthDataDesc =>
      'We need your consent to collect health readings like blood sugar and pressure to monitor the patient\'s condition.';

  @override
  String get consent_type_ai => 'AI Analysis';

  @override
  String get consent_type_aiDesc =>
      'Yameenak uses AI to analyze readings and provide health guidance. Patient identity is anonymized before analysis.';

  @override
  String get consent_type_whatsapp => 'WhatsApp Notifications';

  @override
  String get consent_type_whatsappDesc =>
      'Send alerts for abnormal readings and weekly reports to family members via WhatsApp.';

  @override
  String get consent_type_push => 'App Notifications';

  @override
  String get consent_type_pushDesc =>
      'Reading reminders and instant alerts within the app.';

  @override
  String get consent_type_analytics => 'Analytics & Improvement';

  @override
  String get consent_type_analyticsDesc =>
      'Anonymous data to improve app performance and user experience.';

  @override
  String get consent_type_marketing => 'Marketing';

  @override
  String get consent_type_marketingDesc =>
      'Send offers and information about additional services that may benefit you.';

  @override
  String get privacy_title => 'Privacy Settings';

  @override
  String get privacy_pdplTitle => 'Personal Data Protection';

  @override
  String get privacy_pdplSubtitle =>
      'Yameenak complies with SDAIA\'s PDPL regulations';

  @override
  String get privacy_manageConsents => 'Manage Consents';

  @override
  String get privacy_yourRights => 'Your Rights';

  @override
  String get privacy_downloadData => 'Download My Data';

  @override
  String get privacy_downloadDataSub =>
      'Download a complete copy of all your data';

  @override
  String get privacy_deleteAccount => 'Delete My Account & Data';

  @override
  String get privacy_deleteAccountSub =>
      'Permanently delete all data — irreversible';

  @override
  String get privacy_policy => 'Privacy Policy';

  @override
  String get privacy_essential => 'Essential';

  @override
  String privacy_consentRevoked(String label) {
    return 'Consent revoked: $label';
  }

  @override
  String privacy_exportSuccess(int count) {
    return 'Your data is ready. Records count: $count';
  }

  @override
  String get privacy_exportError => 'Failed to download data. Try again.';

  @override
  String get privacy_deleteTitle => 'Delete Account';

  @override
  String get privacy_deleteMsg =>
      'Are you sure you want to delete your account and all your health data?\n\nThis action cannot be undone.';

  @override
  String get privacy_deleteConfirm => 'Yes, Delete';

  @override
  String get privacy_deleteFinalTitle => 'Final Confirmation';

  @override
  String get privacy_deleteFinalMsg =>
      'The following will be deleted:\n• All patient health data\n• Readings and conversations\n• Bookings and notifications\n• Your entire account\n\nThis data cannot be recovered.';

  @override
  String get privacy_deleteFinal => 'Delete Permanently';

  @override
  String get privacy_deleteError => 'Failed to delete account. Try again.';

  @override
  String get services_title => 'Services Market';

  @override
  String get services_searchHint => 'Search for a service...';

  @override
  String get services_noServices => 'No services in this category';

  @override
  String get services_catAll => 'All';

  @override
  String get services_catNursing => 'Nursing';

  @override
  String get services_catPhysio => 'Physiotherapy';

  @override
  String get services_catCompanion => 'Companion';

  @override
  String get services_catTests => 'Lab Tests';

  @override
  String get services_catConsult => 'Consultations';

  @override
  String get services_catPharmacy => 'Pharmacy';

  @override
  String get plus_upgradeTitle => 'Upgrade to Yameenak Plus';

  @override
  String get plus_upgradeSubtitle =>
      'Enjoy a comprehensive smart healthcare experience\ndesigned specifically for your needs';

  @override
  String get plus_features => 'Membership Features';

  @override
  String get plus_whatsappTitle => 'Smart WhatsApp Alerts';

  @override
  String get plus_whatsappDesc =>
      'Instant notifications and daily reports sent directly to WhatsApp for easy monitoring.';

  @override
  String get plus_aiTitle => 'AI Analytics';

  @override
  String get plus_aiDesc =>
      'Deep health data analysis to discover patterns and provide smart preventive recommendations.';

  @override
  String get plus_monitorTitle => 'Real-time Monitoring';

  @override
  String get plus_monitorDesc =>
      'Continuous vital signs monitoring with alerts for any out-of-range readings.';

  @override
  String get plus_choosePlan => 'Choose Your Plan';

  @override
  String get plus_yearly => 'Annual';

  @override
  String get plus_monthly => 'Monthly';

  @override
  String get plus_yearlyPrice => '249';

  @override
  String get plus_monthlyPrice => '29';

  @override
  String get plus_perYear => 'SAR / year';

  @override
  String get plus_perMonth => 'SAR / month';

  @override
  String get plus_save29 => 'Save 29%';

  @override
  String get plus_subscribe => 'Subscribe Now';

  @override
  String get plus_terms =>
      'By subscribing, you agree to the Terms of Service and Privacy Policy.';

  @override
  String get plus_welcomeMsg => 'Welcome to Yameenak Plus! 🎉';

  @override
  String get gate_exclusive => 'Exclusive to Yameenak Plus';

  @override
  String gate_subscribeFor(String feature) {
    return 'Subscribe to Yameenak Plus to access $feature\nand all premium features';
  }

  @override
  String get gate_upgrade => 'Upgrade to Yameenak Plus';

  @override
  String get status_normal => 'Normal';

  @override
  String get status_needsAttention => 'Needs Attention';

  @override
  String get status_alert => 'Alert';

  @override
  String get success_title => 'Recorded ✅';

  @override
  String get success_subtitle => 'Thanks! Your reading was saved successfully';

  @override
  String get language_toggle => 'عربي';

  @override
  String get disclaimer_title => 'Medical Disclaimer';

  @override
  String get disclaimer_point1 =>
      'This app does not provide medical diagnoses and is not a substitute for professional medical consultation.';

  @override
  String get disclaimer_point2 =>
      'All readings and alerts are for monitoring purposes only and do not represent medical advice.';

  @override
  String get disclaimer_point3 =>
      'In case of emergency, go immediately to the nearest hospital or call 997.';

  @override
  String get disclaimer_accept => 'I have read and agree';

  @override
  String get disclaimer_footer =>
      'By using the app, you agree that Yameenak is a monitoring tool only and is not a substitute for medical care.';

  @override
  String get chat_aiDisclaimer =>
      '⚕️ Atheer is a smart health assistant, not a doctor. It does not prescribe medications. Always consult your doctor for medical decisions.';

  @override
  String get privacy_noDataSelling =>
      'Your health data is never sold or shared with third parties for advertising or commercial purposes.';

  @override
  String get dashboard_lastUpdated => 'Last updated: 5m ago';

  @override
  String get dashboard_recentActivities => 'Recent Activities';

  @override
  String get dashboard_viewAll => 'View All';

  @override
  String get dashboard_completeProfileBanner =>
      'Complete your medical profile now for smart monitoring.';

  @override
  String get dashboard_completeBtn => 'Complete';

  @override
  String dashboard_patientStatus(String name) {
    return '$name\'s Status';
  }

  @override
  String get dashboard_statusExcellent => 'Stable and Excellent Today';

  @override
  String get dashboard_stablePulse => 'Stable Pulse';

  @override
  String get dashboard_talkToAI => 'Talk to AI Assistant';

  @override
  String get dashboard_aiSubtitle => 'Quick medical consultation with AI';

  @override
  String get dashboard_actInsulin => 'Taken Insulin (Metformin)';

  @override
  String get dashboard_act1hAgo => '1h ago';

  @override
  String get dashboard_actCompleted => 'Completed';

  @override
  String get dashboard_actCheckup => 'Routine Checkup - Dr. Ahmed';

  @override
  String get dashboard_actTomorrow => 'Tomorrow 10:00 AM';

  @override
  String get dashboard_actUpcoming => 'Upcoming';

  @override
  String get dashboard_vitalBP => 'B. Pressure';

  @override
  String get dashboard_vitalSugar => 'B. Sugar';

  @override
  String get dashboard_vitalHR => 'Heart Rate';

  @override
  String get dashboard_vitalO2 => 'Oxygen';

  @override
  String get nav_home => 'Home';

  @override
  String get nav_assistant => 'Assistant';

  @override
  String get nav_services => 'Services';

  @override
  String get nav_reports => 'Reports';

  @override
  String get nav_profile => 'Profile';

  @override
  String get welcome_subtitle => 'Integrated Care System';

  @override
  String get welcome_tagline =>
      'Your smart support for caring for loved ones..';

  @override
  String get welcome_tagline2 =>
      'Peace of mind for you, and care they deserve.';

  @override
  String get welcome_getStarted => 'Get Started';

  @override
  String get welcome_footer => 'Care Reimagined • Yameenak Saudi Arabia';

  @override
  String get password_tooShort => 'Password must be at least 8 characters';

  @override
  String get password_needsUppercase =>
      'Password must contain at least one uppercase letter';

  @override
  String get password_needsDigit => 'Password must contain at least one digit';

  @override
  String get reports_generating => 'Generating Report...';

  @override
  String get setup_featureComingSoon => 'This feature is coming soon!';

  @override
  String setup_stepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get setup_progressSaved => 'Progress saved automatically';

  @override
  String get setup_nextDiseases => 'Next Step: Chronic Diseases';

  @override
  String get setup_nextMeds => 'Next Step: Medications';

  @override
  String get setup_nextEmergency => 'Next Step: Emergency Contacts';

  @override
  String get setup_welcomeCaregiver => 'Welcome, Caregiver';

  @override
  String get setup_settingUpProfile =>
      'You are setting up the\nprofile for your loved one.';

  @override
  String get setup_tailorExperience =>
      'This information helps us tailor the medical sanctuary experience to their specific biological and health needs.';

  @override
  String get setup_enterFullName => 'Enter full legal name';

  @override
  String get setup_ageInYears => 'Age in years';

  @override
  String get setup_gender => 'Gender';

  @override
  String get setup_male => 'Male';

  @override
  String get setup_female => 'Female';

  @override
  String get setup_whyMattersLabel => 'Why this matters: ';

  @override
  String get setup_whyBasicInfo =>
      'Providing accurate basic info allows our AI system to calculate the correct dosage levels and health risk factors based on demographic standards.';

  @override
  String get setup_allergyHint => 'e.g., Penicillin, Peanuts, Latex...';

  @override
  String get setup_addAllergyBtn => 'Add Allergy';

  @override
  String get setup_whyMattersQ => 'Why this matters?';

  @override
  String get setup_whyMedHistory =>
      'Your medical history helps our AI-powered care system prevent drug interactions and tailor your nutrition plan specifically to your needs.';

  @override
  String get setup_medNameLabel => 'Medication Name';

  @override
  String get setup_doseHint => 'e.g., 500mg, twice daily';

  @override
  String get setup_doseLabel => 'Dose & Frequency';

  @override
  String get setup_addMedBtn => 'Add Medication';

  @override
  String get setup_aiTip => 'AI Assistant Tip';

  @override
  String get setup_aiTipDetail =>
      'Accuracy is vital. If you\'re unsure about the dosage, use the photo upload feature to let our clinical AI verify the details for you.';

  @override
  String get setup_uploadPrescription => 'Upload Prescription';

  @override
  String get setup_aiExtractInfo =>
      'Our AI will extract medicine names, dosages, and schedules.';

  @override
  String get setup_browseFiles => 'Browse Files';

  @override
  String get setup_contactNameLabel => 'Contact Name';

  @override
  String get setup_relationLabel => 'Relationship';

  @override
  String get setup_phoneLabel => 'Phone Number';

  @override
  String get setup_addAnotherContact => 'Add Another Contact';

  @override
  String get setup_optionalSettings => 'Optional settings';

  @override
  String get setup_dailyCareFeature => 'DAILY CARE FEATURE';

  @override
  String get setup_vitalsLogging => 'Vitals Logging';

  @override
  String get setup_vitalsLoggingDetail =>
      'Once your profile is active, we\'ll help you log critical readings like Blood Sugar and Blood Pressure every day.';

  @override
  String get setup_dataPrivacy => 'Data Privacy & Security';

  @override
  String get setup_dataPrivacyDetail =>
      'Your medical data is encrypted and shared only with your authorized medical team and family members.';
}
