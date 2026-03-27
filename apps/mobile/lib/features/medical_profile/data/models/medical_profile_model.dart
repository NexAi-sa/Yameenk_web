library;

import 'dart:convert';
import '../../domain/entities/medical_profile_entity.dart';

class MedicalProfileModel extends MedicalProfileEntity {
  const MedicalProfileModel({
    required super.patientId,
    required super.fullName,
    required super.age,
    super.bloodType,
    super.gender,
    super.height,
    super.weight,
    super.diseases,
    super.allergies,
    super.medications,
    super.emergencyContacts,
    super.notificationPreferences,
  });

  factory MedicalProfileModel.fromSupabase(
    Map<String, dynamic> patient, {
    List<dynamic>? medications,
    List<dynamic>? emergencyContacts,
    Map<String, dynamic>? notifPrefs,
  }) {
    int age = 0;
    if (patient['date_of_birth'] != null) {
      final dob = DateTime.parse(patient['date_of_birth'] as String);
      age = DateTime.now().difference(dob).inDays ~/ 365;
    }

    final conditions =
        (patient['chronic_conditions'] as List<dynamic>?) ?? [];
    final allergyList = (patient['allergies'] as List<dynamic>?) ?? [];

    return MedicalProfileModel(
      patientId: patient['id'] as String,
      fullName: patient['full_name'] as String? ?? '',
      age: age,
      bloodType: patient['blood_type'] as String?,
      gender: patient['gender'] as String?,
      height: (patient['height'] as num?)?.toDouble(),
      weight: (patient['weight'] as num?)?.toDouble(),
      diseases: conditions
          .map((e) => DiseaseEntity(name: e as String))
          .toList(),
      allergies: allergyList
          .map((e) => AllergyEntity(name: e as String))
          .toList(),
      medications: (medications ?? [])
          .map((e) =>
              MedicationEntityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      emergencyContacts: (emergencyContacts ?? [])
          .map((e) => EmergencyContactEntityModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      notificationPreferences: notifPrefs != null
          ? NotificationPreferencesModel.fromJson(notifPrefs)
          : const NotificationPreferencesEntity(),
    );
  }

  factory MedicalProfileModel.fromJson(Map<String, dynamic> json) =>
      MedicalProfileModel(
        patientId: json['patient_id'] as String,
        fullName: json['full_name'] as String,
        age: json['age'] as int,
        bloodType: json['blood_type'] as String?,
        gender: json['gender'] as String?,
        height: (json['height'] as num?)?.toDouble(),
        weight: (json['weight'] as num?)?.toDouble(),
        diseases: (json['diseases'] as List?)
                ?.map((e) => DiseaseEntity(
                    name: (e as Map)['name'] as String,
                    severity: (e)['severity'] as String?))
                .toList() ??
            [],
        allergies: (json['allergies'] as List?)
                ?.map((e) => AllergyEntity(
                    name: (e as Map)['name'] as String,
                    severity: (e)['severity'] as String?))
                .toList() ??
            [],
        medications: (json['medications'] as List?)
                ?.map((e) => MedicationEntityModel.fromJson(
                    e as Map<String, dynamic>))
                .toList() ??
            [],
        emergencyContacts: (json['emergency_contacts'] as List?)
                ?.map((e) => EmergencyContactEntityModel.fromJson(
                    e as Map<String, dynamic>))
                .toList() ??
            [],
        notificationPreferences:
            json['notification_preferences'] != null
                ? NotificationPreferencesModel.fromJson(
                    json['notification_preferences']
                        as Map<String, dynamic>)
                : const NotificationPreferencesEntity(),
      );

  Map<String, dynamic> toJson() => {
        'patient_id': patientId,
        'full_name': fullName,
        'age': age,
        'blood_type': bloodType,
        'gender': gender,
        'height': height,
        'weight': weight,
        'diseases': diseases
            .map((e) => {'name': e.name, 'severity': e.severity})
            .toList(),
        'allergies': allergies
            .map((e) => {'name': e.name, 'severity': e.severity})
            .toList(),
        'medications': medications
            .map((e) => {
                  'name': e.name,
                  'dosage': e.dosage,
                  'frequency': e.frequency,
                  if (e.notes != null) 'notes': e.notes,
                })
            .toList(),
        'emergency_contacts': emergencyContacts
            .map((e) => {
                  'name': e.name,
                  'phone': e.phone,
                  'relation': e.relation,
                })
            .toList(),
        'notification_preferences': {
          'daily_follow_up': notificationPreferences.dailyFollowUp,
          'emergency_only': notificationPreferences.emergencyOnly,
          'weekly_report': notificationPreferences.weeklyReport,
          'vital_signs_reminder':
              notificationPreferences.vitalSignsReminder,
        },
      };

  String toJsonString() => jsonEncode(toJson());
}

class MedicationEntityModel extends MedicationEntity {
  const MedicationEntityModel({
    required super.name,
    required super.dosage,
    required super.frequency,
    super.notes,
  });

  factory MedicationEntityModel.fromJson(Map<String, dynamic> json) =>
      MedicationEntityModel(
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

class EmergencyContactEntityModel extends EmergencyContactEntity {
  const EmergencyContactEntityModel({
    required super.name,
    required super.phone,
    required super.relation,
  });

  factory EmergencyContactEntityModel.fromJson(
          Map<String, dynamic> json) =>
      EmergencyContactEntityModel(
        name: json['name'] as String,
        phone: json['phone'] as String,
        relation: json['relation'] as String? ??
            json['relationship'] as String? ??
            '',
      );

  Map<String, dynamic> toJson() =>
      {'name': name, 'phone': phone, 'relation': relation};
}

class NotificationPreferencesModel extends NotificationPreferencesEntity {
  const NotificationPreferencesModel({
    super.dailyFollowUp = false,
    super.emergencyOnly = true,
    super.weeklyReport = false,
    super.vitalSignsReminder = false,
  });

  factory NotificationPreferencesModel.fromJson(
          Map<String, dynamic> json) =>
      NotificationPreferencesModel(
        dailyFollowUp: json['daily_follow_up'] as bool? ?? false,
        emergencyOnly: json['emergency_only'] as bool? ?? true,
        weeklyReport: json['weekly_report'] as bool? ?? false,
        vitalSignsReminder:
            json['vital_signs_reminder'] as bool? ?? false,
      );
}
