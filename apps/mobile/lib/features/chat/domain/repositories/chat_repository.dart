library;

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class ChatRepository {
  Future<Either<Failure, String>> sendMessage(
      String patientId, String message);
}
