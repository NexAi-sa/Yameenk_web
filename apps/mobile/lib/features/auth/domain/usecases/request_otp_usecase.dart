library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class RequestOtpUseCase extends UseCase<void, RequestOtpParams> {
  final AuthRepository repository;
  RequestOtpUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RequestOtpParams params) {
    return repository.requestOtp(params.phone);
  }
}

class RequestOtpParams extends Equatable {
  final String phone;
  const RequestOtpParams({required this.phone});

  @override
  List<Object> get props => [phone];
}
