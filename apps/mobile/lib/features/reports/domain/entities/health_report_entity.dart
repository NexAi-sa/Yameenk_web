library;

import 'package:equatable/equatable.dart';

enum InsightType { positive, warning, info }

class HealthReportEntity extends Equatable {
  final String id;
  final String title;
  final String period;
  final DateTime generatedAt;
  final ReportSummaryEntity summary;
  final List<ReportInsightEntity> insights;

  const HealthReportEntity({
    required this.id,
    required this.title,
    required this.period,
    required this.generatedAt,
    required this.summary,
    this.insights = const [],
  });

  @override
  List<Object> get props => [id, title, period, generatedAt, summary];
}

class ReportSummaryEntity extends Equatable {
  final double avgBloodSugar;
  final double avgSystolic;
  final double avgDiastolic;
  final int readingsCount;
  final double medicationAdherence;

  const ReportSummaryEntity({
    required this.avgBloodSugar,
    required this.avgSystolic,
    required this.avgDiastolic,
    required this.readingsCount,
    required this.medicationAdherence,
  });

  @override
  List<Object> get props => [
        avgBloodSugar,
        avgSystolic,
        avgDiastolic,
        readingsCount,
        medicationAdherence,
      ];
}

class ReportInsightEntity extends Equatable {
  final String title;
  final String description;
  final InsightType type;

  const ReportInsightEntity({
    required this.title,
    required this.description,
    required this.type,
  });

  @override
  List<Object> get props => [title, description, type];
}
