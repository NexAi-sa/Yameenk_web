library;

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/health_service_entity.dart';
import '../../domain/repositories/services_repository.dart';
import '../datasources/services_remote_datasource.dart';
import '../models/health_service_model.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final ServicesRemoteDataSource _dataSource;
  ServicesRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<HealthServiceEntity>>> getServices() async {
    try {
      final data = await _dataSource.getServices();
      final services = data
          .map((e) =>
              HealthServiceModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(services);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }
}
