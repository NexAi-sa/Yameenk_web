library;

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, void>> requestOtp(String phone) async {
    try {
      await dataSource.requestOtp(phone);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> verifyOtp(
      String phone, String code) async {
    try {
      final json = await dataSource.verifyOtp(phone, code);
      return Right(AuthModel.fromJson(json));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> register(
      String name, String email, String password) async {
    try {
      final json = await dataSource.register(name, email, password);
      return Right(AuthModel.fromJson(json));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> hasCompletedConsent() async {
    try {
      final result = await dataSource.hasCompletedConsent();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await dataSource.logout();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
