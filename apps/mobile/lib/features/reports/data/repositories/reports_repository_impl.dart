library;

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/health_report_entity.dart';
import '../../domain/repositories/reports_repository.dart';
import '../datasources/reports_remote_datasource.dart';
import '../models/health_report_model.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsRemoteDataSource _dataSource;
  ReportsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<HealthReportEntity>>> getReports(
      String patientId) async {
    try {
      final data = await _dataSource.getReports(patientId);
      final reports = data
          .map((e) =>
              HealthReportModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(reports);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, HealthReportEntity>> generateReport(
      String patientId) async {
    try {
      final data = await _dataSource.generateReport(patientId);
      return Right(HealthReportModel.fromJson(data));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }
}
