library;

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> requestOtp(String phone);
  Future<Either<Failure, AuthEntity>> verifyOtp(String phone, String code);
  Future<Either<Failure, AuthEntity>> register(
      String name, String email, String password);
  Future<Either<Failure, AuthEntity>> loginWithEmail(
      String email, String password);
  Future<Either<Failure, bool>> hasCompletedConsent();
  Future<Either<Failure, void>> logout();
}
