library;

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/reading_entity.dart';
import '../../domain/repositories/readings_repository.dart';
import '../datasources/readings_remote_datasource.dart';
import '../models/reading_model.dart';

class ReadingsRepositoryImpl implements ReadingsRepository {
  final ReadingsRemoteDataSource dataSource;
  ReadingsRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<ReadingEntity>>> getReadings(
    String patientId, {
    int days = 7,
  }) async {
    try {
      final data = await dataSource.getReadings(patientId, days: days);
      final readings = data
          .map((e) => ReadingModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(readings);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> recordReading({
    required String patientId,
    required String type,
    double? value,
    int? systolic,
    int? diastolic,
    String? context,
  }) async {
    try {
      await dataSource.recordReading(
        patientId: patientId,
        type: type,
        value: value,
        systolic: systolic,
        diastolic: diastolic,
        context: context,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }
}
