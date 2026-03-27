library;

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/reading_entity.dart';

abstract class ReadingsRepository {
  Future<Either<Failure, List<ReadingEntity>>> getReadings(
    String patientId, {
    int days = 7,
  });

  Future<Either<Failure, void>> recordReading({
    required String patientId,
    required String type,
    double? value,
    int? systolic,
    int? diastolic,
    String? context,
  });
}
