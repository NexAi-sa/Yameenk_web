/// رسم بياني مصغّر — يعرض قراءات آخر 7 أيام
///
/// مصدر البيانات: [weekReadingsProvider] في `patient_provider.dart`
/// يستدعي [ApiService.getReadings] (GET /readings?patient_id=X&days=7)
/// إذا لم يتوفر خادم (backend)، ستُعرض حالة "لا توجد قراءات"
library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../app/theme.dart';
import '../models/reading.dart';

class ReadingSparkline extends StatelessWidget {
  final List<HealthReading> readings;
  final double height;
  final double? minLimit;
  final double? maxLimit;

  const ReadingSparkline({
    super.key,
    required this.readings,
    this.height = 80,
    this.minLimit,
    this.maxLimit,
  });

  @override
  Widget build(BuildContext context) {
    if (readings.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(
          child: Text('لا توجد قراءات', style: AppTextStyles.caption),
        ),
      );
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < readings.length; i++) {
      spots.add(FlSpot(i.toDouble(), readings[i].value));
    }

    final values = readings.map((r) => r.value);
    final minY = (values.reduce((a, b) => a < b ? a : b) - 20)
        .clamp(0.0, double.infinity);
    final maxY = values.reduce((a, b) => a > b ? a : b) + 20;

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minY: minY,
          maxY: maxY,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots.map((spot) {
                return LineTooltipItem(
                  spot.y.toInt().toString(),
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),
          ),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              if (maxLimit != null)
                HorizontalLine(
                  y: maxLimit!,
                  color: AppColors.danger.withValues(alpha: 0.3),
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              if (minLimit != null)
                HorizontalLine(
                  y: minLimit!,
                  color: AppColors.danger.withValues(alpha: 0.3),
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
            ],
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: AppColors.primary,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  final reading = readings[index];
                  return FlDotCirclePainter(
                    radius: 4,
                    color:
                        reading.isNormal ? AppColors.success : AppColors.danger,
                    strokeWidth: 2,
                    strokeColor: AppColors.surface,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      ),
    );
  }
}
