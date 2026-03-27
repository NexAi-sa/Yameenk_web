library;

import '../../domain/entities/patient_entity.dart';

class PatientModel extends PatientEntity {
  const PatientModel({
    required super.id,
    required super.name,
    required super.age,
    required super.conditions,
    required super.limits,
    super.bloodType,
    super.height,
    super.weight,
    super.allergies,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) => PatientModel(
        id: json['id'] as String,
        name: json['name'] as String? ?? json['full_name'] as String? ?? '',
        age: json['age'] as int? ?? _calcAge(json['dob'] as String?),
        conditions: List<String>.from(
            json['conditions'] as List? ??
                json['chronic_conditions'] as List? ??
                []),
        limits: json['limits'] != null
            ? PatientLimitsModel.fromJson(
                json['limits'] as Map<String, dynamic>)
            : PatientLimitsModel(
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

class PatientLimitsModel extends PatientLimitsEntity {
  const PatientLimitsModel({
    super.bloodSugarMin = 70,
    super.bloodSugarMax = 140,
    super.systolicMax = 140,
    super.diastolicMax = 90,
  });

  factory PatientLimitsModel.fromJson(Map<String, dynamic> json) =>
      PatientLimitsModel(
        bloodSugarMin:
            (json['blood_sugar_min'] as num?)?.toInt() ?? 70,
        bloodSugarMax:
            (json['blood_sugar_max'] as num?)?.toInt() ?? 140,
        systolicMax: (json['systolic_max'] as num?)?.toInt() ?? 140,
        diastolicMax: (json['diastolic_max'] as num?)?.toInt() ?? 90,
      );
}
