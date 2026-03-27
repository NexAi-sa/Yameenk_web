import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/theme.dart';
import '../../core/responsive_scaffold.dart';
import '../../main.dart';
import '../../features/reports/domain/entities/health_report_entity.dart';
import '../../features/reports/presentation/cubit/reports_cubit.dart';
import '../../features/reports/presentation/cubit/reports_state.dart';
import '../../widgets/plus_gate.dart';

/// شاشة التقارير الصحية — Health Reports
class HealthReportsScreen extends StatelessWidget {
  const HealthReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    return PlusGate(
      featureName: l.reports_title,
      child: Scaffold(
        appBar: AppBar(title: Text(l.reports_title)),
        body: BlocBuilder<ReportsCubit, ReportsState>(
          builder: (context, state) {
            if (state is ReportsLoading || state is ReportsInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ReportGenerating) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(l.reports_generating,
                        style: AppTextStyles.heading3),
                    const SizedBox(height: 8),
                    const SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(),
                    ),
                  ],
                ),
              );
            }
            if (state is ReportsError) {
              return Center(child: Text(l.common_error(state.message)));
            }
            final reports =
                state is ReportsLoaded ? state.reports : <HealthReportEntity>[];
            return ResponsiveCenter(
              maxWidth: 800,
              child: ListView(
                padding: AppSpacing.screenPadding,
                children: [
                  // Quick summary (first report)
                  if (reports.isNotEmpty) ...[
                    _SummaryCard(report: reports.first),
                    const SizedBox(height: AppSpacing.xl),
                  ],

                  // Smart insights
                  if (reports.isNotEmpty &&
                      reports.first.insights.isNotEmpty) ...[
                    Text(l.reports_insights, style: AppTextStyles.heading2),
                    const SizedBox(height: AppSpacing.md),
                    ...reports.first.insights
                        .map((i) => _InsightCard(insight: i)),
                    const SizedBox(height: AppSpacing.xl),
                  ],

                  // Reports list
                  Text(l.reports_previous, style: AppTextStyles.heading2),
                  const SizedBox(height: AppSpacing.md),
                  ...reports.map((r) => _ReportListTile(report: r)),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Quick Summary ──
class _SummaryCard extends StatelessWidget {
  final HealthReportEntity report;
  const _SummaryCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = report.summary;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: AppGradients.primary,
        borderRadius: BorderRadius.circular(AppDesign.cardRadiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_outlined,
                  color: Colors.white, size: 24),
              const SizedBox(width: AppSpacing.sm),
              Text(report.title,
                  style: AppTextStyles.heading3.copyWith(color: Colors.white)),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _SummaryStatBadge(
                  label: l.reports_sugar,
                  value: '${s.avgBloodSugar.toInt()}'),
              const SizedBox(width: AppSpacing.md),
              _SummaryStatBadge(
                  label: l.reports_pressure,
                  value: '${s.avgSystolic.toInt()}/${s.avgDiastolic.toInt()}'),
              const SizedBox(width: AppSpacing.md),
              _SummaryStatBadge(
                  label: l.reports_readingsCount,
                  value: '${s.readingsCount}'),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Medication adherence
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.reports_medAdherence,
                        style: AppTextStyles.caption
                            .copyWith(color: Colors.white70)),
                    const SizedBox(height: AppSpacing.xs),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: s.medicationAdherence,
                        minHeight: 12,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation(
                            AppColors.tertiaryFixedDim),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                '${(s.medicationAdherence * 100).toInt()}%',
                style: AppTextStyles.heading3.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStatBadge extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryStatBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: AppTextStyles.heading3.copyWith(color: Colors.white)),
            const SizedBox(height: 2),
            Text(label,
                style: AppTextStyles.caption.copyWith(color: Colors.white60)),
          ],
        ),
      ),
    );
  }
}

// ── AI Insight Card ──
class _InsightCard extends StatelessWidget {
  final ReportInsightEntity insight;
  const _InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    final (bgColor, iconColor, icon) = switch (insight.type) {
      InsightType.positive => (
          AppColors.successLight,
          AppColors.success,
          Icons.trending_up_rounded
        ),
      InsightType.warning => (
          AppColors.warningLight,
          AppColors.warning,
          Icons.warning_amber_rounded
        ),
      InsightType.info => (
          AppColors.tertiaryFixed,
          AppColors.tertiaryContainer,
          Icons.lightbulb_outline_rounded
        ),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDesign.cardRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(insight.title,
                    style: AppTextStyles.label.copyWith(color: iconColor)),
                const SizedBox(height: 4),
                Text(insight.description, style: AppTextStyles.bodyMd),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Report List Tile ──
class _ReportListTile extends StatelessWidget {
  final HealthReportEntity report;
  const _ReportListTile({required this.report});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final daysAgo = DateTime.now().difference(report.generatedAt).inDays;
    final timeLabel = daysAgo == 0
        ? l.reports_today
        : daysAgo == 1
            ? l.reports_yesterday
            : l.reports_daysAgo(daysAgo);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDesign.cardRadius),
        boxShadow: [AppDesign.ambientShadow],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDesign.cardRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDesign.cardRadius),
          onTap: () {
            // TODO: open report details
          },
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryFixed,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.description_outlined,
                      color: AppColors.secondary),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(report.title, style: AppTextStyles.heading3),
                      Text('${report.period} — $timeLabel',
                          style: AppTextStyles.caption),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l.reports_insightsCount(report.insights.length),
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                const Icon(Icons.chevron_left,
                    color: AppColors.outline, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
