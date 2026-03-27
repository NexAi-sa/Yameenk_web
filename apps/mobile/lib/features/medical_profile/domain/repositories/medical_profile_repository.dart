library;

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/medical_profile_entity.dart';

abstract class MedicalProfileRepository {
  Future<Either<Failure, MedicalProfileEntity>> getMedicalProfile(
      String patientId);
  Future<Either<Failure, void>> saveMedicalProfile(
      MedicalProfileEntity profile);
}
