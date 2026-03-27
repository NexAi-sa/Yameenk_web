library;

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource dataSource;
  ChatRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, String>> sendMessage(
      String patientId, String message) async {
    try {
      final response = await dataSource.sendMessage(patientId, message);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }
}
