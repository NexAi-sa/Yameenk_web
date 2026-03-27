library;

import 'package:equatable/equatable.dart';
import '../../domain/entities/patient_entity.dart';

abstract class PatientState extends Equatable {
  const PatientState();

  @override
  List<Object?> get props => [];
}

class PatientInitial extends PatientState {
  const PatientInitial();
}

class PatientLoading extends PatientState {
  const PatientLoading();
}

class PatientLoaded extends PatientState {
  final PatientEntity patient;
  const PatientLoaded(this.patient);

  @override
  List<Object?> get props => [patient];
}

class PatientError extends PatientState {
  final String message;
  const PatientError(this.message);

  @override
  List<Object?> get props => [message];
}
