library;

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/consent_entity.dart';

abstract class ConsentRepository {
  Future<Either<Failure, bool>> hasCompletedConsent();
  Future<Either<Failure, List<Map<String, dynamic>>>> getConsents();
  Future<Either<Failure, void>> submitConsents(
      Map<ConsentType, bool> consents);
  Future<Either<Failure, void>> revokeConsent(ConsentType type);
}
