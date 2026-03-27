library;

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_patient_usecase.dart';
import 'patient_state.dart';

class PatientCubit extends Cubit<PatientState> {
  final GetPatientUseCase _getPatient;

  PatientCubit({required GetPatientUseCase getPatient})
      : _getPatient = getPatient,
        super(const PatientInitial());

  Future<void> loadPatient(String patientId) async {
    emit(const PatientLoading());

    final result = await _getPatient(GetPatientParams(patientId: patientId));

    result.fold(
      (failure) => emit(PatientError(failure.message)),
      (patient) => emit(PatientLoaded(patient)),
    );
  }

  void reset() => emit(const PatientInitial());
}
