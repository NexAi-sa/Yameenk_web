library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reading_entity.dart';
import '../repositories/readings_repository.dart';

class GetReadingsUseCase
    extends UseCase<List<ReadingEntity>, GetReadingsParams> {
  final ReadingsRepository repository;
  GetReadingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ReadingEntity>>> call(
      GetReadingsParams params) {
    return repository.getReadings(params.patientId, days: params.days);
  }
}

class GetReadingsParams extends Equatable {
  final String patientId;
  final int days;
  const GetReadingsParams({required this.patientId, this.days = 7});

  @override
  List<Object> get props => [patientId, days];
}
