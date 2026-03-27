library;

import 'package:equatable/equatable.dart';
import '../../domain/entities/medical_profile_entity.dart';

class ProfileSetupState extends Equatable {
  final int currentStep;
  final MedicalProfileEntity profile;
  final bool isSaving;
  final String? errorMessage;

  const ProfileSetupState({
    this.currentStep = 0,
    required this.profile,
    this.isSaving = false,
    this.errorMessage,
  });

  ProfileSetupState copyWith({
    int? currentStep,
    MedicalProfileEntity? profile,
    bool? isSaving,
    String? errorMessage,
  }) =>
      ProfileSetupState(
        currentStep: currentStep ?? this.currentStep,
        profile: profile ?? this.profile,
        isSaving: isSaving ?? this.isSaving,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props =>
      [currentStep, profile, isSaving, errorMessage];
}
