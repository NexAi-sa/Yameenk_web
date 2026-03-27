library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/patient_entity.dart';
import '../repositories/patient_repository.dart';

class GetPatientUseCase extends UseCase<PatientEntity, GetPatientParams> {
  final PatientRepository repository;
  GetPatientUseCase(this.repository);

  @override
  Future<Either<Failure, PatientEntity>> call(GetPatientParams params) {
    return repository.getPatient(params.patientId);
  }
}

class GetPatientParams extends Equatable {
  final String patientId;
  const GetPatientParams({required this.patientId});

  @override
  List<Object> get props => [patientId];
}
