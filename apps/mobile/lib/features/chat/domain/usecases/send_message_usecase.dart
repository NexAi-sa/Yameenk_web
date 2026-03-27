library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase extends UseCase<String, SendMessageParams> {
  final ChatRepository repository;
  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(SendMessageParams params) {
    return repository.sendMessage(params.patientId, params.message);
  }
}

class SendMessageParams extends Equatable {
  final String patientId;
  final String message;
  const SendMessageParams({required this.patientId, required this.message});

  @override
  List<Object> get props => [patientId, message];
}
