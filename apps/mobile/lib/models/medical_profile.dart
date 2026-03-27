/// نموذج الملف الطبي — Medical Profile
library;

class MedicalProfile {
  final String patientId;
  final String fullName;
  final int age;
  final String? bloodType;
  final String? gender;
  final double? height;
  final double? weight;
  final List<Disease> diseases;
  final List<Allergy> allergies;
  final List<Medication> medications;
  final List<EmergencyContact> emergencyContacts;
  final NotificationPreferences notificationPreferences;

  const MedicalProfile({
    required this.patientId,
    required this.fullName,
    required this.age,
    this.bloodType,
    this.gender,
    this.height,
    this.weight,
    this.diseases = const [],
    this.allergies = const [],
    this.medications = const [],
    this.emergencyContacts = const [],
    this.notificationPreferences = const NotificationPreferences(),
  });

  bool get isComplete =>
      bloodType != null &&
      height != null &&
      weight != null &&
      diseases.isNotEmpty &&
      emergencyContacts.isNotEmpty;

  double get completionPercent {
    var total = 0;
    var done = 0;

    total += 3; // blood, height, weight
    if (bloodType != null) done++;
    if (height != null) done++;
    if (weight != null) done++;

    total += 1; // diseases
    if (diseases.isNotEmpty) done++;

    total += 1; // allergies (optional but counted)
    if (allergies.isNotEmpty) done++;

    total += 1; // medications
    if (medications.isNotEmpty) done++;

    total += 1; // emergency contacts
    if (emergencyContacts.isNotEmpty) done++;

    return total == 0 ? 0 : done / total;
  }

  MedicalProfile copyWith({
    String? patientId,
    String? fullName,
    int? age,
    String? bloodType,
    String? gender,
    double? height,
    double? weight,
    List<Disease>? diseases,
    List<Allergy>? allergies,
    List<Medication>? medications,
    List<EmergencyContact>? emergencyContacts,
    NotificationPreferences? notificationPreferences,
  }) {
    return MedicalProfile(
      patientId: patientId ?? this.patientId,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      bloodType: bloodType ?? this.bloodType,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      diseases: diseases ?? this.diseases,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
    );
  }

  Map<String, dynamic> toJson() => {
        'patient_id': patientId,
        'full_name': fullName,
        'age': age,
        'blood_type': bloodType,
        'gender': gender,
        'height': height,
        'weight': weight,
        'diseases': diseases.map((e) => e.toJson()).toList(),
        'allergies': allergies.map((e) => e.toJson()).toList(),
        'medications': medications.map((e) => e.toJson()).toList(),
        'emergency_contacts': emergencyContacts.map((e) => e.toJson()).toList(),
        'notification_preferences': notificationPreferences.toJson(),
      };

  /// تحويل بيانات Supabase (patients + medications + emergency_contacts) إلى Model
  factory MedicalProfile.fromSupabase(Map<String, dynamic> patient, {
    List<dynamic>? medications,
    List<dynamic>? emergencyContacts,
    Map<String, dynamic>? notifPrefs,
  }) {
    // حساب العمر من date_of_birth
    int age = 0;
    if (patient['date_of_birth'] != null) {
      final dob = DateTime.parse(patient['date_of_birth'] as String);
      age = DateTime.now().difference(dob).inDays ~/ 365;
    }

    // chronic_conditions هي TEXT[] في Supabase
    final conditions = (patient['chronic_conditions'] as List<dynamic>?) ?? [];
    final allergyList = (patient['allergies'] as List<dynamic>?) ?? [];

    return MedicalProfile(
      patientId: patient['id'] as String,
      fullName: patient['full_name'] as String? ?? '',
      age: age,
      bloodType: patient['blood_type'] as String?,
      gender: patient['gender'] as String?,
      height: (patient['height'] as num?)?.toDouble(),
      weight: (patient['weight'] as num?)?.toDouble(),
      diseases: conditions
          .map((e) => Disease(name: e as String))
          .toList(),
      allergies: allergyList
          .map((e) => Allergy(name: e as String))
          .toList(),
      medications: (medications ?? [])
          .map((e) => Medication.fromJson(e as Map<String, dynamic>))
          .toList(),
      emergencyContacts: (emergencyContacts ?? [])
          .map((e) => EmergencyContact.fromJson(e as Map<String, dynamic>))
          .toList(),
      notificationPreferences: notifPrefs != null
          ? NotificationPreferences.fromJson(notifPrefs)
          : const NotificationPreferences(),
    );
  }

  factory MedicalProfile.fromJson(Map<String, dynamic> json) {
    return MedicalProfile(
      patientId: json['patient_id'] as String,
      fullName: json['full_name'] as String,
      age: json['age'] as int,
      bloodType: json['blood_type'] as String?,
      gender: json['gender'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      diseases: (json['diseases'] as List?)
              ?.map((e) => Disease.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      allergies: (json['allergies'] as List?)
              ?.map((e) => Allergy.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      medications: (json['medications'] as List?)
              ?.map((e) => Medication.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      emergencyContacts: (json['emergency_contacts'] as List?)
              ?.map((e) => EmergencyContact.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      notificationPreferences: json['notification_preferences'] != null
          ? NotificationPreferences.fromJson(
              json['notification_preferences'] as Map<String, dynamic>)
          : const NotificationPreferences(),
    );
  }

  /// بيانات وهمية للتطوير
  static MedicalProfile mock() => const MedicalProfile(
        patientId: 'p-001',
        fullName: 'عبدالله محمد الأحمد',
        age: 72,
        bloodType: 'A+',
        height: 170,
        weight: 78,
        diseases: [
          Disease(name: 'السكري النوع الثاني', severity: 'متوسط'),
          Disease(name: 'ارتفاع ضغط الدم', severity: 'خفيف'),
        ],
        allergies: [
          Allergy(name: 'البنسلين', severity: 'شديد'),
        ],
        medications: [
          Medication(
              name: 'ميتفورمين', dosage: '500mg', frequency: 'مرتين يومياً'),
          Medication(name: 'أملوديبين', dosage: '5mg', frequency: 'مرة يومياً'),
        ],
        emergencyContacts: [
          EmergencyContact(
              name: 'سارة عبدالله', phone: '0551234567', relation: 'ابنة'),
          EmergencyContact(
              name: 'خالد عبدالله', phone: '0559876543', relation: 'ابن'),
        ],
      );

  /// ملف فارغ جديد
  static MedicalProfile empty(String patientId) => MedicalProfile(
        patientId: patientId,
        fullName: '',
        age: 0,
        notificationPreferences: const NotificationPreferences(),
      );
}

class NotificationPreferences {
  final bool dailyFollowUp;
  final bool emergencyOnly;
  final bool weeklyReport;
  final bool vitalSignsReminder;

  const NotificationPreferences({
    this.dailyFollowUp = false,
    this.emergencyOnly = true,
    this.weeklyReport = false,
    this.vitalSignsReminder = false,
  });

  NotificationPreferences copyWith({
    bool? dailyFollowUp,
    bool? emergencyOnly,
    bool? weeklyReport,
    bool? vitalSignsReminder,
  }) {
    return NotificationPreferences(
      dailyFollowUp: dailyFollowUp ?? this.dailyFollowUp,
      emergencyOnly: emergencyOnly ?? this.emergencyOnly,
      weeklyReport: weeklyReport ?? this.weeklyReport,
      vitalSignsReminder: vitalSignsReminder ?? this.vitalSignsReminder,
    );
  }

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      NotificationPreferences(
        dailyFollowUp: json['daily_follow_up'] as bool? ?? false,
        emergencyOnly: json['emergency_only'] as bool? ?? true,
        weeklyReport: json['weekly_report'] as bool? ?? false,
        vitalSignsReminder: json['vital_signs_reminder'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'daily_follow_up': dailyFollowUp,
        'emergency_only': emergencyOnly,
        'weekly_report': weeklyReport,
        'vital_signs_reminder': vitalSignsReminder,
      };
}

class Disease {
  final String name;
  final String? severity;
  final DateTime? diagnosedAt;

  const Disease({required this.name, this.severity, this.diagnosedAt});

  factory Disease.fromJson(Map<String, dynamic> json) => Disease(
        name: json['name'] as String,
        severity: json['severity'] as String?,
        diagnosedAt: json['diagnosed_at'] != null
            ? DateTime.parse(json['diagnosed_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'severity': severity,
        if (diagnosedAt != null) 'diagnosed_at': diagnosedAt!.toIso8601String(),
      };
}

class Allergy {
  final String name;
  final String? severity;

  const Allergy({required this.name, this.severity});

  factory Allergy.fromJson(Map<String, dynamic> json) => Allergy(
        name: json['name'] as String,
        severity: json['severity'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'severity': severity,
      };
}

class Medication {
  final String name;
  final String dosage;
  final String frequency;
  final String? notes;

  const Medication({
    required this.name,
    required this.dosage,
    required this.frequency,
    this.notes,
  });

  factory Medication.fromJson(Map<String, dynamic> json) => Medication(
        name: json['name'] as String,
        dosage: json['dosage'] as String,
        frequency: json['frequency'] as String,
        notes: json['notes'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'dosage': dosage,
        'frequency': frequency,
        if (notes != null) 'notes': notes,
      };
}

class EmergencyContact {
  final String name;
  final String phone;
  final String relation;

  const EmergencyContact({
    required this.name,
    required this.phone,
    required this.relation,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) =>
      EmergencyContact(
        name: json['name'] as String,
        phone: json['phone'] as String,
        relation: json['relation'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'relation': relation,
      };
}
