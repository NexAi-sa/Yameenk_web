library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

/// Base interface for all use cases.
/// [Type] is the return type, [Params] is the input parameters type.
abstract class UseCase<Output, Params> {
  Future<Either<Failure, Output>> call(Params params);
}

/// Use this when the use case takes no parameters.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object> get props => [];
}
