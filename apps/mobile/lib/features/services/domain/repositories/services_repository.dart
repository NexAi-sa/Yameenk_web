library;

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/health_service_entity.dart';

/// Contract for health services repository.
abstract class ServicesRepository {
  /// Returns all available health services.
  Future<Either<Failure, List<HealthServiceEntity>>> getServices();
}
