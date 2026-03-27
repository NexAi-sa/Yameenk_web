library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/feature_flags.dart';
import '../../../../main.dart';
import '../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../../features/auth/presentation/cubit/auth_state.dart';
import '../../../../features/patient/domain/entities/patient_entity.dart';
import '../../../../features/patient/presentation/cubit/patient_cubit.dart';
import '../../../../features/patient/presentation/cubit/patient_state.dart';
import '../../../../features/readings/domain/entities/reading_entity.dart';
import '../../../../features/readings/presentation/cubit/readings_cubit.dart';
import '../../../../features/readings/presentation/cubit/readings_state.dart';
import '../../../../widgets/error_state.dart';

class FamilyDashboardPage extends StatefulWidget {
  const FamilyDashboardPage({super.key});

  @override
  State<FamilyDashboardPage> createState() => _FamilyDashboardPageState();
}

class _FamilyDashboardPageState extends State<FamilyDashboardPage> {
  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated || authState.patientId.isEmpty) {
      // Guard: no valid session → redirect to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) GoRouter.of(context).go('/welcome');
      });
      return;
    }
    context.read<PatientCubit>().loadPatient(authState.patientId);
    context.read<ReadingsCubit>().loadReadings(authState.patientId);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 56,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: CircleAvatar(
            backgroundColor: AppColors.secondaryContainer,
            child: Icon(Icons.person, color: AppColors.secondary),
          ),
        ),
        title: Text(l.appTitle,
            style:
                AppTextStyles.heading3.copyWith(color: AppColors.primary)),
        actions: [
          if (FeatureFlags.kNotificationsEnabled)
            IconButton(
              icon: const Icon(Icons.notifications_outlined,
                  color: AppColors.primary),
              onPressed: () {
                // TODO: navigate to notifications screen when implemented
                context.push('/notifications');
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<PatientCubit, PatientState>(
        builder: (context, patientState) {
          if (patientState is PatientInitial) {
            // Data hasn't been requested yet — trigger load & show spinner
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _loadDashboardData();
            });
            return const Center(child: CircularProgressIndicator());
          }
          if (patientState is PatientLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (patientState is PatientError) {
            return ErrorStateWidget(
              message: l.dashboard_errorLoad,
              onRetry: () => _loadDashboardData(),
            );
          }
          if (patientState is PatientLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<PatientCubit>()
                    .loadPatient(patientState.patient.id);
                context
                    .read<ReadingsCubit>()
                    .loadReadings(patientState.patient.id);
              },
              child: BlocBuilder<ReadingsCubit, ReadingsState>(
                builder: (context, readingsState) {
                  final readings = readingsState is ReadingsLoaded
                      ? readingsState.readings
                      : <ReadingEntity>[];
                  return _DashboardContent(
                    patient: patientState.patient,
                    readings: readings,
                  );
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final PatientEntity patient;
  final List<ReadingEntity> readings;

  const _DashboardContent(
      {required this.patient, required this.readings});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 16),
        if (patient.profileCompletionPercent < 100)
          _buildAlertBanner(context),
        const SizedBox(height: 24),
        Text(l.dashboard_greeting,
            style:
                AppTextStyles.heading2.copyWith(color: AppColors.primary)),
        const SizedBox(height: 16),
        _buildStatusCard(context),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l.dashboard_readingLabel, style: AppTextStyles.heading3),
            Text(l.dashboard_lastUpdated,
                style: const TextStyle(
                    fontSize: 10, color: AppColors.outline)),
          ],
        ),
        const SizedBox(height: 12),
        _VitalsGrid(readings: readings),
        const SizedBox(height: 24),
        _buildAIAction(context),
        if (FeatureFlags.showRecentActivities) ...[
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l.dashboard_recentActivities,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
              TextButton(
                onPressed: () => context.go('/patient/reports'),
                child: Text(l.dashboard_viewAll,
                    style: const TextStyle(fontSize: 12))),
            ],
          ),
          // TODO(#7): replace with real ActivityCubit data when endpoint is ready
          _buildActivitiesList(context),
        ],
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildAlertBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [AppColors.tertiary, AppColors.tertiaryContainer]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: AppColors.tertiary.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.medical_information,
                color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.l10n.dashboard_completeProfileBanner,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => context.go('/patient/profile/setup'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.tertiary,
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(context.l10n.dashboard_completeBtn,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [AppDesign.ambientShadow],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                    color: AppColors.secondaryFixed,
                    borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.elderly,
                    color: AppColors.secondary, size: 32),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle,
                      color: Color(0xFF10B981), size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.dashboard_patientStatus(patient.name),
                    style: AppTextStyles.caption),
                Text(context.l10n.dashboard_statusExcellent,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.primary)),
              ],
            ),
          ),
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      color: const Color(0xFF10B981)
                          .withValues(alpha: 0.2))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _PulseIndicator(),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(context.l10n.dashboard_stablePulse,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.bold,
                            fontSize: 11)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIAction(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/family/chat'),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.1)),
        ),
        child: Stack(
          children: [
            const Positioned(
              left: -10,
              top: -10,
              child: Opacity(
                opacity: 0.05,
                child: Icon(Icons.smart_toy,
                    size: 100, color: AppColors.secondary),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.dashboard_talkToAI,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.primary)),
                        Text(context.l10n.dashboard_aiSubtitle,
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.outline)),
                      ],
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                        color: AppColors.secondaryFixed,
                        borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.chat_bubble,
                        color: AppColors.secondary, size: 24),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitiesList(BuildContext context) {
    final l = context.l10n;
    final items = [
      (
        icon: Icons.medication,
        color: Colors.blue,
        title: l.dashboard_actInsulin,
        time: l.dashboard_act1hAgo,
        status: l.dashboard_actCompleted,
        statusColor: const Color(0xFF10B981)
      ),
      (
        icon: Icons.calendar_today,
        color: Colors.amber,
        title: l.dashboard_actCheckup,
        time: l.dashboard_actTomorrow,
        status: l.dashboard_actUpcoming,
        statusColor: AppColors.secondary
      ),
    ];

    return Column(
      children: items
          .map((item) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppColors.outlineVariant
                            .withValues(alpha: 0.1))),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.1),
                          shape: BoxShape.circle),
                      child: Icon(item.icon,
                          color: item.color, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(item.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                          Text(item.time,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.outline)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: item.statusColor
                              .withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(8)),
                      child: Text(item.status,
                          style: TextStyle(
                              color: item.statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 10)),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _VitalsGrid extends StatelessWidget {
  final List<ReadingEntity> readings;
  const _VitalsGrid({required this.readings});

  /// Metadata for each vital type: (title, icon, iconColor, defaultUnit).
  static Map<ReadingType, (String, IconData, Color, String)> _vitalMeta(S l) => {
    ReadingType.bloodPressure: (l.dashboard_vitalBP, Icons.monitor_heart, Colors.red, 'mmHg'),
    ReadingType.bloodSugar: (l.dashboard_vitalSugar, Icons.water_drop, Colors.amber, 'mg/dL'),
    ReadingType.heartRate: (l.dashboard_vitalHR, Icons.favorite, const Color(0xFFF43F5E), 'bpm'),
    ReadingType.oxygenSaturation: (l.dashboard_vitalO2, Icons.air, Colors.blue, 'SpO₂'),
  };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    // Build a lookup: most recent reading per type.
    final latest = <ReadingType, ReadingEntity>{};
    for (final r in readings) {
      final existing = latest[r.type];
      if (existing == null || r.recordedAt.isAfter(existing.recordedAt)) {
        latest[r.type] = r;
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 12) / 2;
        final cardHeight = cardWidth / 1.2;
        final aspectRatio = cardWidth / cardHeight.clamp(100, 160);

        return GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: aspectRatio,
          children: _vitalMeta(l).entries.map((e) {
            final (title, icon, color, defaultUnit) = e.value;
            final reading = latest[e.key];

            return _VitalCard(
              title: title,
              icon: icon,
              iconColor: color,
              value: reading?.displayValue ?? '--',
              unit: reading?.unit ?? defaultUnit,
            );
          }).toList(),
        );
      },
    );
  }
}

class _VitalCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String value;
  final String unit;

  const _VitalCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6)),
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.outline)),
              ),
            ],
          ),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary)),
          Text(unit,
              style: const TextStyle(
                  fontSize: 10, color: AppColors.outline)),
        ],
      ),
    );
  }
}

class _PulseIndicator extends StatefulWidget {
  const _PulseIndicator();

  @override
  State<_PulseIndicator> createState() => _PulseIndicatorState();
}

class _PulseIndicatorState extends State<_PulseIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 1))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 0.8, end: 1.2).animate(_controller),
      child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
              color: Color(0xFF10B981), shape: BoxShape.circle)),
    );
  }
}


