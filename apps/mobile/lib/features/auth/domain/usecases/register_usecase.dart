library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase extends UseCase<AuthEntity, RegisterParams> {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, AuthEntity>> call(RegisterParams params) {
    return repository.register(params.name, params.email, params.password);
  }
}

class RegisterParams extends Equatable {
  final String name;
  final String email;
  final String password;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}
