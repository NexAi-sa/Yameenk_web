library;

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/patient_entity.dart';

abstract class PatientRepository {
  Future<Either<Failure, PatientEntity>> getPatient(String patientId);
}
