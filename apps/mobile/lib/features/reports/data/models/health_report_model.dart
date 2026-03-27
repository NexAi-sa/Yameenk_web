library;

import '../../domain/entities/health_report_entity.dart';

class HealthReportModel extends HealthReportEntity {
  const HealthReportModel({
    required super.id,
    required super.title,
    required super.period,
    required super.generatedAt,
    required super.summary,
    super.insights,
  });

  factory HealthReportModel.fromJson(Map<String, dynamic> json) =>
      HealthReportModel(
        id: json['id'] as String,
        title: json['title'] as String,
        period: json['period'] as String,
        generatedAt: DateTime.parse(json['generated_at'] as String),
        summary: ReportSummaryModel.fromJson(
            json['summary'] as Map<String, dynamic>),
        insights: (json['insights'] as List?)
                ?.map((e) => ReportInsightModel.fromJson(
                    e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  static List<HealthReportModel> mockList() => [
        HealthReportModel(
          id: 'r-001',
          title: 'التقرير الأسبوعي',
          period: 'أسبوعي',
          generatedAt: DateTime.now().subtract(const Duration(days: 1)),
          summary: const ReportSummaryModel(
            avgBloodSugar: 128,
            avgSystolic: 135,
            avgDiastolic: 82,
            readingsCount: 14,
            medicationAdherence: 0.85,
          ),
          insights: const [
            ReportInsightModel(
              title: 'تحسن ملحوظ',
              description:
                  'معدل السكر انخفض بنسبة ١٢٪ مقارنة بالأسبوع الماضي',
              type: InsightType.positive,
            ),
            ReportInsightModel(
              title: 'تنبيه ضغط الدم',
              description:
                  'قراءتان تجاوزتا الحد الأعلى — يُنصح بمراجعة الطبيب',
              type: InsightType.warning,
            ),
          ],
        ),
        HealthReportModel(
          id: 'r-002',
          title: 'التقرير الشهري',
          period: 'شهري',
          generatedAt: DateTime.now().subtract(const Duration(days: 7)),
          summary: const ReportSummaryModel(
            avgBloodSugar: 135,
            avgSystolic: 138,
            avgDiastolic: 85,
            readingsCount: 56,
            medicationAdherence: 0.78,
          ),
          insights: const [
            ReportInsightModel(
              title: 'استقرار ضغط الدم',
              description: 'ضغط الدم مستقر نسبياً خلال الشهر',
              type: InsightType.positive,
            ),
          ],
        ),
      ];
}

class ReportSummaryModel extends ReportSummaryEntity {
  const ReportSummaryModel({
    required super.avgBloodSugar,
    required super.avgSystolic,
    required super.avgDiastolic,
    required super.readingsCount,
    required super.medicationAdherence,
  });

  factory ReportSummaryModel.fromJson(Map<String, dynamic> json) =>
      ReportSummaryModel(
        avgBloodSugar:
            (json['avg_blood_sugar'] as num).toDouble(),
        avgSystolic: (json['avg_systolic'] as num).toDouble(),
        avgDiastolic: (json['avg_diastolic'] as num).toDouble(),
        readingsCount: json['readings_count'] as int,
        medicationAdherence:
            (json['medication_adherence'] as num).toDouble(),
      );
}

class ReportInsightModel extends ReportInsightEntity {
  const ReportInsightModel({
    required super.title,
    required super.description,
    required super.type,
  });

  factory ReportInsightModel.fromJson(Map<String, dynamic> json) =>
      ReportInsightModel(
        title: json['title'] as String,
        description: json['description'] as String,
        type: InsightType.values.byName(json['type'] as String),
      );
}
