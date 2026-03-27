library;

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/patient_entity.dart';
import '../../domain/repositories/patient_repository.dart';
import '../datasources/patient_remote_datasource.dart';
import '../models/patient_model.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource dataSource;
  PatientRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, PatientEntity>> getPatient(String patientId) async {
    try {
      final json = await dataSource.getPatient(patientId);
      return Right(PatientModel.fromJson(json));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }
}
