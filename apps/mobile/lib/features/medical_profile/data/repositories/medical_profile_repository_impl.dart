library;

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/medical_profile_entity.dart';
import '../../domain/repositories/medical_profile_repository.dart';
import '../datasources/medical_profile_remote_datasource.dart';
import '../models/medical_profile_model.dart';

class MedicalProfileRepositoryImpl implements MedicalProfileRepository {
  final MedicalProfileDataSource dataSource;
  MedicalProfileRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, MedicalProfileEntity>> getMedicalProfile(
      String patientId) async {
    // Local-first: return cache immediately, then sync from server
    final cached = await dataSource.getCachedProfile();
    try {
      final remote = await dataSource.getMedicalProfile(patientId);
      await dataSource.cacheProfile(remote);
      return Right(remote);
    } on ServerException catch (e) {
      if (cached != null) return Right(cached);
      return Left(ServerFailure(e.message));
    } on NetworkException {
      if (cached != null) return Right(cached);
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveMedicalProfile(
      MedicalProfileEntity profile) async {
    final model = _toModel(profile);
    // Optimistic local save first
    await dataSource.cacheProfile(model);
    try {
      await dataSource.saveMedicalProfile(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  MedicalProfileModel _toModel(MedicalProfileEntity entity) {
    if (entity is MedicalProfileModel) return entity;
    return MedicalProfileModel(
      patientId: entity.patientId,
      fullName: entity.fullName,
      age: entity.age,
      bloodType: entity.bloodType,
      gender: entity.gender,
      height: entity.height,
      weight: entity.weight,
      diseases: entity.diseases,
      allergies: entity.allergies,
      medications: entity.medications,
      emergencyContacts: entity.emergencyContacts,
      notificationPreferences: entity.notificationPreferences,
    );
  }
}
