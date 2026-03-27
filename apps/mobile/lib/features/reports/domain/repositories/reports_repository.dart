library;

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/health_report_entity.dart';

abstract class ReportsRepository {
  Future<Either<Failure, List<HealthReportEntity>>> getReports(
      String patientId);
  Future<Either<Failure, HealthReportEntity>> generateReport(
      String patientId);
}
