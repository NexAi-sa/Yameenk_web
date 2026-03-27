library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase extends UseCase<AuthEntity, VerifyOtpParams> {
  final AuthRepository repository;
  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, AuthEntity>> call(VerifyOtpParams params) {
    return repository.verifyOtp(params.phone, params.code);
  }
}

class VerifyOtpParams extends Equatable {
  final String phone;
  final String code;
  const VerifyOtpParams({required this.phone, required this.code});

  @override
  List<Object> get props => [phone, code];
}
