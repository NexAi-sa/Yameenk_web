library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/medical_profile_entity.dart';
import '../repositories/medical_profile_repository.dart';

class SaveMedicalProfileUseCase
    extends UseCase<void, SaveMedicalProfileParams> {
  final MedicalProfileRepository repository;
  SaveMedicalProfileUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveMedicalProfileParams params) {
    return repository.saveMedicalProfile(params.profile);
  }
}

class SaveMedicalProfileParams extends Equatable {
  final MedicalProfileEntity profile;
  const SaveMedicalProfileParams({required this.profile});

  @override
  List<Object> get props => [profile];
}
