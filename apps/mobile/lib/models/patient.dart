class Patient {
  final String id;
  final String name;
  final int age;
  final List<String> conditions;
  final PatientLimits limits;

  // Extended profile fields
  final String? bloodType;
  final double? height;
  final double? weight;
  final List<String>? allergies;
  final List<Medication>? medications;
  final List<EmergencyContact>? emergencyContacts;

  const Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.conditions,
    required this.limits,
    this.bloodType,
    this.height,
    this.weight,
    this.allergies,
    this.medications,
    this.emergencyContacts,
  });

  /// نسبة اكتمال الملف الشخصي
  int get profileCompletionPercent {
    int filled = 0;
    int total = 7;
    if (name.isNotEmpty) filled++;
    if (conditions.isNotEmpty) filled++;
    if (bloodType != null && bloodType!.isNotEmpty) filled++;
    if (height != null) filled++;
    if (weight != null) filled++;
    if (allergies != null && allergies!.isNotEmpty) filled++;
    if (medications != null && medications!.isNotEmpty) filled++;
    return ((filled / total) * 100).round();
  }

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        id: json['id'] as String,
        name: json['name'] as String? ?? json['full_name'] as String? ?? '',
        age: json['age'] as int? ?? _calcAge(json['dob'] as String?),
        conditions: List<String>.from(
            json['conditions'] as List? ??
                json['chronic_conditions'] as List? ??
                []),
        limits: json['limits'] != null
            ? PatientLimits.fromJson(json['limits'] as Map<String, dynamic>)
            : PatientLimits(
                bloodSugarMin:
                    (json['sugar_min'] as num?)?.toInt() ?? 70,
                bloodSugarMax:
                    (json['sugar_max'] as num?)?.toInt() ?? 140,
                systolicMax:
                    (json['bp_systolic_max'] as num?)?.toInt() ?? 140,
                diastolicMax:
                    (json['bp_diastolic_max'] as num?)?.toInt() ?? 90,
              ),
        bloodType: json['blood_type'] as String?,
        height: (json['height'] as num?)?.toDouble(),
        weight: (json['weight'] as num?)?.toDouble(),
        allergies: json['allergies'] != null
            ? List<String>.from(json['allergies'] as List)
            : null,
        medications: json['medications'] != null
            ? (json['medications'] as List)
                .map((m) => Medication.fromJson(m as Map<String, dynamic>))
                .toList()
            : null,
        emergencyContacts: json['emergency_contacts'] != null
            ? (json['emergency_contacts'] as List)
                .map((c) =>
                    EmergencyContact.fromJson(c as Map<String, dynamic>))
                .toList()
            : null,
      );

  static int _calcAge(String? dob) {
    if (dob == null || dob.isEmpty) return 0;
    try {
      final birth = DateTime.parse(dob);
      final now = DateTime.now();
      int age = now.year - birth.year;
      if (now.month < birth.month ||
          (now.month == birth.month && now.day < birth.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return 0;
    }
  }
}

class PatientLimits {
  final int bloodSugarMin;
  final int bloodSugarMax;
  final int systolicMax;
  final int diastolicMax;

  const PatientLimits({
    this.bloodSugarMin = 70,
    this.bloodSugarMax = 140,
    this.systolicMax = 140,
    this.diastolicMax = 90,
  });

  factory PatientLimits.fromJson(Map<String, dynamic> json) => PatientLimits(
        bloodSugarMin: (json['blood_sugar_min'] as num?)?.toInt() ?? 70,
        bloodSugarMax: (json['blood_sugar_max'] as num?)?.toInt() ?? 140,
        systolicMax: (json['systolic_max'] as num?)?.toInt() ?? 140,
        diastolicMax: (json['diastolic_max'] as num?)?.toInt() ?? 90,
      );
}

class Medication {
  final String name;
  final String dosage;
  final String frequency;

  const Medication({
    required this.name,
    required this.dosage,
    required this.frequency,
  });

  factory Medication.fromJson(Map<String, dynamic> json) => Medication(
        name: json['name'] as String? ?? '',
        dosage: json['dosage'] as String? ?? '',
        frequency: json['frequency'] as String? ?? '',
      );
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
        name: json['name'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        relation: json['relation'] as String? ?? json['relationship'] as String? ?? '',
      );
}
