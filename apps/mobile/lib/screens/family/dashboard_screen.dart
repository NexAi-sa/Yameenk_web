/// لوحة تحكم الأسرة — الشاشة الرئيسية
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../main.dart';
import '../../models/patient.dart';
import '../../models/reading.dart';
import '../../providers/patient_provider.dart';
import '../../widgets/error_state.dart';

class FamilyDashboardScreen extends ConsumerWidget {
  const FamilyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientAsync = ref.watch(patientProvider);
    final readingsAsync = ref.watch(weekReadingsProvider);
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
            style: AppTextStyles.heading3.copyWith(color: AppColors.primary)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.primary),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(patientProvider);
          ref.invalidate(weekReadingsProvider);
        },
        child: patientAsync.when(
          data: (patient) => _DashboardContent(
            patient: patient,
            readingsAsync: readingsAsync,
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorStateWidget(
            message: l.dashboard_errorLoad,
            onRetry: () => ref.invalidate(patientProvider),
          ),
        ),
      ),
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final Patient patient;
  final AsyncValue<List<HealthReading>> readingsAsync;

  const _DashboardContent({required this.patient, required this.readingsAsync});

  @override
  Widget build(BuildContext context) {
    final readings = readingsAsync.valueOrNull ?? [];
    final l = context.l10n;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 16),
        // 1. Complete Profile Alert
        if (patient.profileCompletionPercent < 100) _buildAlertBanner(context),

        const SizedBox(height: 24),
        // 2. Dashboard Title
        Text(l.dashboard_greeting,
            style: AppTextStyles.heading2.copyWith(color: AppColors.primary)),
        const SizedBox(height: 16),

        // 3. Patient Status Card
        _buildStatusCard(context),

        const SizedBox(height: 24),
        // 4. Vitals Grid
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l.dashboard_readingLabel, style: AppTextStyles.heading3),
            const Text('Last updated: 5m ago',
                style: TextStyle(fontSize: 10, color: AppColors.outline)),
          ],
        ),
        const SizedBox(height: 12),
        _VitalsGrid(readings: readings),

        const SizedBox(height: 24),
        // 5. Quick Actions
        _buildAIAction(context),

        const SizedBox(height: 24),
        // 6. Recent Activities
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Activities',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            TextButton(
                onPressed: () {},
                child: const Text('View All', style: TextStyle(fontSize: 12))),
          ],
        ),
        _buildActivitiesList(),
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
          const Expanded(
            child: Text(
              'Complete your medical profile now for smart monitoring and accurate emergency alerts.',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => context.go('/patient/setup'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.tertiary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Complete',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
                Text('${patient.name}\'s Status', style: AppTextStyles.caption),
                const Text('Stable and Excellent Today',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.primary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(100),
                border:
                    Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.2))),
            child: const Row(
              children: [
                _PulseIndicator(),
                SizedBox(width: 6),
                Text('Stable Pulse',
                    style: TextStyle(
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.bold,
                        fontSize: 11)),
              ],
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
          border: Border.all(color: AppColors.secondary.withValues(alpha: 0.1)),
        ),
        child: Stack(
          children: [
            const Positioned(
              left: -10,
              top: -10,
              child: Opacity(
                opacity: 0.05,
                child: Icon(Icons.smart_toy, size: 100, color: AppColors.secondary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Talk to AI Assistant',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.primary)),
                        Text('Quick medical consultation with AI',
                            style:
                                TextStyle(fontSize: 12, color: AppColors.outline)),
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

  Widget _buildActivitiesList() {
    final items = [
      (
        icon: Icons.medication,
        color: Colors.blue,
        title: 'Taken Insulin (Metformin)',
        time: '1h ago',
        status: 'Completed',
        statusColor: const Color(0xFF10B981)
      ),
      (
        icon: Icons.calendar_today,
        color: Colors.amber,
        title: 'Routine Checkup - Dr. Ahmed',
        time: 'Tomorrow 10:00 AM',
        status: 'Upcoming',
        statusColor: AppColors.secondary
      ),
      (
        icon: Icons.fitness_center,
        color: Colors.purple,
        title: 'Physical Therapy Session',
        time: 'Today 05:00 PM',
        status: 'Pending',
        statusColor: Colors.amber
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
                        color: AppColors.outlineVariant.withValues(alpha: 0.1))),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.1),
                          shape: BoxShape.circle),
                      child: Icon(item.icon, color: item.color, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(item.time,
                              style: const TextStyle(
                                  fontSize: 10, color: AppColors.outline)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: item.statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8)),
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
  final List<HealthReading> readings;
  const _VitalsGrid({required this.readings});

  @override
  Widget build(BuildContext context) {
    // Condition logic: Always show Sugar and Pressure, conditional for Pulse and Oxygen
    final hasHeartRate = readings.any((r) => r.type == ReadingType.heartRate);
    final hasOxygen =
        readings.any((r) => r.type == ReadingType.oxygenSaturation);

    final List<Widget> cards = [
      const _VitalCard(
        title: 'B. Pressure',
        icon: Icons.monitor_heart,
        iconColor: Colors.red,
        value: '120/80',
        unit: 'mmHg',
      ),
      const _VitalCard(
        title: 'B. Sugar',
        icon: Icons.water_drop,
        iconColor: Colors.amber,
        value: '95',
        unit: 'mg/dL',
      ),
      if (hasHeartRate || true) // Placeholder true for design demo consistency if needed
        const _VitalCard(
          title: 'Heart Rate',
          icon: Icons.favorite,
          iconColor: Color(0xFFF43F5E),
          value: '72',
          unit: 'bpm',
        ),
      if (hasOxygen || true)
        const _VitalCard(
          title: 'Oxygen',
          icon: Icons.air,
          iconColor: Colors.blue,
          value: '98%',
          unit: 'SpO2',
        ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.2,
      children: cards,
    );
  }
}

class _VitalCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String value;
  final String unit;

  const _VitalCard(
      {required this.title,
      required this.icon,
      required this.iconColor,
      required this.value,
      required this.unit});

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
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(6)),
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
                  fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primary)),
          Text(unit, style: const TextStyle(fontSize: 10, color: AppColors.outline)),
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
          decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 40,
              offset: const Offset(0, -12))
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBtn(icon: Icons.home_rounded, label: 'Home', isActive: true),
          _NavBtn(icon: Icons.smart_toy_outlined, label: 'Assistant'),
          _NavBtn(icon: Icons.medical_services_outlined, label: 'Services'),
          _NavBtn(icon: Icons.description_outlined, label: 'Reports'),
          _NavBtn(icon: Icons.person_outline_rounded, label: 'Profile'),
        ],
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  const _NavBtn(
      {required this.icon, required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: isActive
              ? BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16))
              : null,
          child: Icon(icon,
              color: isActive ? AppColors.primary : AppColors.outline, size: 24),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? AppColors.primary : AppColors.outline)),
      ],
    );
  }
}
