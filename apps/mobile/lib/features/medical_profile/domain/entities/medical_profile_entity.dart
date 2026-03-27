library;

import 'package:equatable/equatable.dart';

class MedicalProfileEntity extends Equatable {
  final String patientId;
  final String fullName;
  final int age;
  final String? bloodType;
  final String? gender;
  final double? height;
  final double? weight;
  final List<DiseaseEntity> diseases;
  final List<AllergyEntity> allergies;
  final List<MedicationEntity> medications;
  final List<EmergencyContactEntity> emergencyContacts;
  final NotificationPreferencesEntity notificationPreferences;

  const MedicalProfileEntity({
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
    this.notificationPreferences = const NotificationPreferencesEntity(),
  });

  bool get isComplete =>
      bloodType != null &&
      height != null &&
      weight != null &&
      diseases.isNotEmpty &&
      emergencyContacts.isNotEmpty;

  double get completionPercent {
    var done = 0;
    if (bloodType != null) done++;
    if (height != null) done++;
    if (weight != null) done++;
    if (diseases.isNotEmpty) done++;
    if (allergies.isNotEmpty) done++;
    if (medications.isNotEmpty) done++;
    if (emergencyContacts.isNotEmpty) done++;
    return done / 7;
  }

  MedicalProfileEntity copyWith({
    String? patientId,
    String? fullName,
    int? age,
    String? bloodType,
    String? gender,
    double? height,
    double? weight,
    List<DiseaseEntity>? diseases,
    List<AllergyEntity>? allergies,
    List<MedicationEntity>? medications,
    List<EmergencyContactEntity>? emergencyContacts,
    NotificationPreferencesEntity? notificationPreferences,
  }) {
    return MedicalProfileEntity(
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
      notificationPreferences:
          notificationPreferences ?? this.notificationPreferences,
    );
  }

  static MedicalProfileEntity empty(String patientId) => MedicalProfileEntity(
        patientId: patientId,
        fullName: '',
        age: 0,
      );

  @override
  List<Object?> get props => [
        patientId,
        fullName,
        age,
        bloodType,
        gender,
        height,
        weight,
        diseases,
        allergies,
        medications,
        emergencyContacts,
        notificationPreferences,
      ];
}

class DiseaseEntity extends Equatable {
  final String name;
  final String? severity;
  const DiseaseEntity({required this.name, this.severity});

  @override
  List<Object?> get props => [name, severity];
}

class AllergyEntity extends Equatable {
  final String name;
  final String? severity;
  const AllergyEntity({required this.name, this.severity});

  @override
  List<Object?> get props => [name, severity];
}

class MedicationEntity extends Equatable {
  final String name;
  final String dosage;
  final String frequency;
  final String? notes;
  const MedicationEntity({
    required this.name,
    required this.dosage,
    required this.frequency,
    this.notes,
  });

  @override
  List<Object?> get props => [name, dosage, frequency, notes];
}

class EmergencyContactEntity extends Equatable {
  final String name;
  final String phone;
  final String relation;
  const EmergencyContactEntity({
    required this.name,
    required this.phone,
    required this.relation,
  });

  @override
  List<Object> get props => [name, phone, relation];
}

class NotificationPreferencesEntity extends Equatable {
  final bool dailyFollowUp;
  final bool emergencyOnly;
  final bool weeklyReport;
  final bool vitalSignsReminder;

  const NotificationPreferencesEntity({
    this.dailyFollowUp = false,
    this.emergencyOnly = true,
    this.weeklyReport = false,
    this.vitalSignsReminder = false,
  });

  NotificationPreferencesEntity copyWith({
    bool? dailyFollowUp,
    bool? emergencyOnly,
    bool? weeklyReport,
    bool? vitalSignsReminder,
  }) {
    return NotificationPreferencesEntity(
      dailyFollowUp: dailyFollowUp ?? this.dailyFollowUp,
      emergencyOnly: emergencyOnly ?? this.emergencyOnly,
      weeklyReport: weeklyReport ?? this.weeklyReport,
      vitalSignsReminder: vitalSignsReminder ?? this.vitalSignsReminder,
    );
  }

  @override
  List<Object> get props =>
      [dailyFollowUp, emergencyOnly, weeklyReport, vitalSignsReminder];
}
