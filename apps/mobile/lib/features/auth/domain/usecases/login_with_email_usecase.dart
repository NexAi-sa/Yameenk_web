library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithEmailUseCase extends UseCase<AuthEntity, LoginWithEmailParams> {
  final AuthRepository repository;
  LoginWithEmailUseCase(this.repository);

  @override
  Future<Either<Failure, AuthEntity>> call(LoginWithEmailParams params) {
    return repository.loginWithEmail(params.email, params.password);
  }
}

class LoginWithEmailParams extends Equatable {
  final String email;
  final String password;
  const LoginWithEmailParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
