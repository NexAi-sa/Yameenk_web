library;

import 'package:equatable/equatable.dart';
import '../../domain/entities/health_report_entity.dart';

abstract class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {
  const ReportsInitial();
}

class ReportsLoading extends ReportsState {
  const ReportsLoading();
}

class ReportsLoaded extends ReportsState {
  final List<HealthReportEntity> reports;
  const ReportsLoaded(this.reports);

  @override
  List<Object?> get props => [reports];
}

class ReportsError extends ReportsState {
  final String message;
  const ReportsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ReportGenerating extends ReportsState {
  const ReportGenerating();
}
