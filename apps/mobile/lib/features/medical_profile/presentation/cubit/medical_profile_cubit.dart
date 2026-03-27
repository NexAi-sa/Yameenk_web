library;

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/medical_profile_entity.dart';
import '../../domain/usecases/get_medical_profile_usecase.dart';
import '../../domain/usecases/save_medical_profile_usecase.dart';
import 'medical_profile_state.dart';

class MedicalProfileCubit extends Cubit<MedicalProfileState> {
  final GetMedicalProfileUseCase _getProfile;
  final SaveMedicalProfileUseCase _saveProfile;

  MedicalProfileCubit({
    required GetMedicalProfileUseCase getProfile,
    required SaveMedicalProfileUseCase saveProfile,
  })  : _getProfile = getProfile,
        _saveProfile = saveProfile,
        super(const MedicalProfileInitial());

  Future<void> load(String patientId) async {
    emit(const MedicalProfileLoading());

    final result = await _getProfile(
        GetMedicalProfileParams(patientId: patientId));

    result.fold(
      (failure) => emit(MedicalProfileError(failure.message)),
      (profile) => emit(MedicalProfileLoaded(profile)),
    );
  }

  Future<void> save(MedicalProfileEntity profile) async {
    emit(const MedicalProfileSaving());

    final result =
        await _saveProfile(SaveMedicalProfileParams(profile: profile));

    result.fold(
      (failure) => emit(MedicalProfileError(failure.message)),
      (_) => emit(const MedicalProfileSaved()),
    );
  }
}
