library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/medical_profile_entity.dart';
import '../repositories/medical_profile_repository.dart';

class GetMedicalProfileUseCase
    extends UseCase<MedicalProfileEntity, GetMedicalProfileParams> {
  final MedicalProfileRepository repository;
  GetMedicalProfileUseCase(this.repository);

  @override
  Future<Either<Failure, MedicalProfileEntity>> call(
      GetMedicalProfileParams params) {
    return repository.getMedicalProfile(params.patientId);
  }
}

class GetMedicalProfileParams extends Equatable {
  final String patientId;
  const GetMedicalProfileParams({required this.patientId});

  @override
  List<Object> get props => [patientId];
}
