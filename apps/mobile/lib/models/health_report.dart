/// نموذج التقارير الصحية — Health Report
library;

class HealthReport {
  final String id;
  final String title;
  final String period;
  final DateTime generatedAt;
  final ReportSummary summary;
  final List<ReportInsight> insights;

  const HealthReport({
    required this.id,
    required this.title,
    required this.period,
    required this.generatedAt,
    required this.summary,
    this.insights = const [],
  });

  factory HealthReport.fromJson(Map<String, dynamic> json) => HealthReport(
        id: json['id'] as String,
        title: json['title'] as String,
        period: json['period'] as String,
        generatedAt: DateTime.parse(json['generated_at'] as String),
        summary:
            ReportSummary.fromJson(json['summary'] as Map<String, dynamic>),
        insights: (json['insights'] as List?)
                ?.map((e) => ReportInsight.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  /// بيانات وهمية للتطوير
  static List<HealthReport> mockList() => [
        HealthReport(
          id: 'r-001',
          title: 'التقرير الأسبوعي',
          period: 'أسبوعي',
          generatedAt: DateTime.now().subtract(const Duration(days: 1)),
          summary: const ReportSummary(
            avgBloodSugar: 128,
            avgSystolic: 135,
            avgDiastolic: 82,
            readingsCount: 14,
            medicationAdherence: 0.85,
          ),
          insights: const [
            ReportInsight(
              title: 'تحسن ملحوظ',
              description: 'معدل السكر انخفض بنسبة ١٢٪ مقارنة بالأسبوع الماضي',
              type: InsightType.positive,
            ),
            ReportInsight(
              title: 'تنبيه ضغط الدم',
              description: 'قراءتان تجاوزتا الحد الأعلى — يُنصح بمراجعة الطبيب',
              type: InsightType.warning,
            ),
            ReportInsight(
              title: 'الالتزام بالأدوية',
              description: 'نسبة الالتزام ٨٥٪ — جيد، حاول الوصول لـ ٩٥٪',
              type: InsightType.info,
            ),
          ],
        ),
        HealthReport(
          id: 'r-002',
          title: 'التقرير الشهري',
          period: 'شهري',
          generatedAt: DateTime.now().subtract(const Duration(days: 7)),
          summary: const ReportSummary(
            avgBloodSugar: 135,
            avgSystolic: 138,
            avgDiastolic: 85,
            readingsCount: 56,
            medicationAdherence: 0.78,
          ),
          insights: const [
            ReportInsight(
              title: 'نمط مرتفع صباحاً',
              description: 'قراءات السكر الصباحية أعلى من المعدل بـ ١٥٪',
              type: InsightType.warning,
            ),
            ReportInsight(
              title: 'استقرار ضغط الدم',
              description: 'ضغط الدم مستقر نسبياً خلال الشهر',
              type: InsightType.positive,
            ),
          ],
        ),
      ];
}

class ReportSummary {
  final double avgBloodSugar;
  final double avgSystolic;
  final double avgDiastolic;
  final int readingsCount;
  final double medicationAdherence;

  const ReportSummary({
    required this.avgBloodSugar,
    required this.avgSystolic,
    required this.avgDiastolic,
    required this.readingsCount,
    required this.medicationAdherence,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> json) => ReportSummary(
        avgBloodSugar: (json['avg_blood_sugar'] as num).toDouble(),
        avgSystolic: (json['avg_systolic'] as num).toDouble(),
        avgDiastolic: (json['avg_diastolic'] as num).toDouble(),
        readingsCount: json['readings_count'] as int,
        medicationAdherence: (json['medication_adherence'] as num).toDouble(),
      );
}

enum InsightType { positive, warning, info }

class ReportInsight {
  final String title;
  final String description;
  final InsightType type;

  const ReportInsight({
    required this.title,
    required this.description,
    required this.type,
  });

  factory ReportInsight.fromJson(Map<String, dynamic> json) => ReportInsight(
        title: json['title'] as String,
        description: json['description'] as String,
        type: InsightType.values.byName(json['type'] as String),
      );
}
