library;

import 'package:equatable/equatable.dart';
import '../../domain/entities/medical_profile_entity.dart';

abstract class MedicalProfileState extends Equatable {
  const MedicalProfileState();

  @override
  List<Object?> get props => [];
}

class MedicalProfileInitial extends MedicalProfileState {
  const MedicalProfileInitial();
}

class MedicalProfileLoading extends MedicalProfileState {
  const MedicalProfileLoading();
}

class MedicalProfileLoaded extends MedicalProfileState {
  final MedicalProfileEntity profile;
  const MedicalProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class MedicalProfileError extends MedicalProfileState {
  final String message;
  const MedicalProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class MedicalProfileSaving extends MedicalProfileState {
  const MedicalProfileSaving();
}

class MedicalProfileSaved extends MedicalProfileState {
  const MedicalProfileSaved();
}
