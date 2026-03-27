library;

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/medical_profile_entity.dart';
import '../../domain/usecases/save_medical_profile_usecase.dart';
import 'profile_setup_state.dart';

class ProfileSetupCubit extends Cubit<ProfileSetupState> {
  final SaveMedicalProfileUseCase _saveProfile;

  ProfileSetupCubit({
    required SaveMedicalProfileUseCase saveProfile,
    required String patientId,
  })  : _saveProfile = saveProfile,
        super(ProfileSetupState(
            profile: MedicalProfileEntity.empty(patientId)));

  void updateProfile(MedicalProfileEntity profile) {
    emit(state.copyWith(profile: profile));
  }

  void nextStep() {
    if (state.currentStep < 3) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void goToStep(int step) {
    emit(state.copyWith(currentStep: step.clamp(0, 3)));
  }

  Future<void> submit() async {
    emit(state.copyWith(isSaving: true));

    final result = await _saveProfile(
        SaveMedicalProfileParams(profile: state.profile));

    result.fold(
      (failure) =>
          emit(state.copyWith(isSaving: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isSaving: false)),
    );
  }
}
