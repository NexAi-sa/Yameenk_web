library;

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/consent_entity.dart';
import '../../domain/repositories/consent_repository.dart';
import '../datasources/consent_remote_datasource.dart';

class ConsentRepositoryImpl implements ConsentRepository {
  final ConsentRemoteDataSource dataSource;
  ConsentRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, bool>> hasCompletedConsent() async {
    try {
      return Right(await dataSource.hasCompletedConsent());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getConsents() async {
    try {
      return Right(await dataSource.getConsents());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> submitConsents(
      Map<ConsentType, bool> consents) async {
    try {
      final list = consents.entries
          .map((e) => {'type': e.key.apiKey, 'granted': e.value})
          .toList();
      await dataSource.submitConsents(list);
      await dataSource.markConsentCompleted();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> revokeConsent(ConsentType type) async {
    try {
      await dataSource.revokeConsent(type.apiKey);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }
}
