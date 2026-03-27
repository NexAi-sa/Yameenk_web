library;

import 'package:equatable/equatable.dart';

class PatientEntity extends Equatable {
  final String id;
  final String name;
  final int age;
  final List<String> conditions;
  final PatientLimitsEntity limits;
  final String? bloodType;
  final double? height;
  final double? weight;
  final List<String>? allergies;

  const PatientEntity({
    required this.id,
    required this.name,
    required this.age,
    required this.conditions,
    required this.limits,
    this.bloodType,
    this.height,
    this.weight,
    this.allergies,
  });

  int get profileCompletionPercent {
    int filled = 0;
    const total = 5;
    if (name.isNotEmpty) filled++;
    if (conditions.isNotEmpty) filled++;
    if (bloodType != null) filled++;
    if (height != null) filled++;
    if (weight != null) filled++;
    return ((filled / total) * 100).round();
  }

  @override
  List<Object?> get props =>
      [id, name, age, conditions, limits, bloodType, height, weight, allergies];
}

class PatientLimitsEntity extends Equatable {
  final int bloodSugarMin;
  final int bloodSugarMax;
  final int systolicMax;
  final int diastolicMax;

  const PatientLimitsEntity({
    this.bloodSugarMin = 70,
    this.bloodSugarMax = 140,
    this.systolicMax = 140,
    this.diastolicMax = 90,
  });

  @override
  List<Object> get props =>
      [bloodSugarMin, bloodSugarMax, systolicMax, diastolicMax];
}
