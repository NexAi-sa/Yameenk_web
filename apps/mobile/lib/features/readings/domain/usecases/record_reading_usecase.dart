library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/readings_repository.dart';

class RecordReadingUseCase extends UseCase<void, RecordReadingParams> {
  final ReadingsRepository repository;
  RecordReadingUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RecordReadingParams params) {
    return repository.recordReading(
      patientId: params.patientId,
      type: params.type,
      value: params.value,
      systolic: params.systolic,
      diastolic: params.diastolic,
      context: params.readingContext,
    );
  }
}

class RecordReadingParams extends Equatable {
  final String patientId;
  final String type;
  final double? value;
  final int? systolic;
  final int? diastolic;
  final String? readingContext;

  const RecordReadingParams({
    required this.patientId,
    required this.type,
    this.value,
    this.systolic,
    this.diastolic,
    this.readingContext,
  });

  @override
  List<Object?> get props =>
      [patientId, type, value, systolic, diastolic, readingContext];
}
