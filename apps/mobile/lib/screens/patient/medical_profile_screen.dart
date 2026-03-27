/// الملف الطبي — Medical Profile
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../core/responsive_scaffold.dart';
import '../../main.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/medical_profile/domain/entities/medical_profile_entity.dart';
import '../../features/medical_profile/presentation/cubit/medical_profile_cubit.dart';
import '../../features/medical_profile/presentation/cubit/medical_profile_state.dart';

class MedicalProfileScreen extends StatefulWidget {
  const MedicalProfileScreen({super.key});

  @override
  State<MedicalProfileScreen> createState() => _MedicalProfileScreenState();
}

class _MedicalProfileScreenState extends State<MedicalProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-load profile when screen opens
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.read<MedicalProfileCubit>().load(authState.patientId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l.profile_title)),
      body: BlocBuilder<MedicalProfileCubit, MedicalProfileState>(
        builder: (context, state) {
          if (state is MedicalProfileLoading ||
              state is MedicalProfileInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MedicalProfileError) {
            return Center(child: Text(l.common_error(state.message)));
          }
          if (state is! MedicalProfileLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final profile = state.profile;
          final completionPercent =
              (profile.completionPercent * 100).round();

          return ResponsiveCenter(
            maxWidth: 800,
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Completion banner
                  if (completionPercent < 100)
                    _CompletionBanner(
                      percent: completionPercent,
                      onTap: () =>
                          context.go('/patient/profile/setup'),
                    ),

                  const SizedBox(height: AppSpacing.md),

                  // Basic info
                  _BasicInfoCard(profile: profile),

                  const SizedBox(height: AppSpacing.md),

                  // Diseases
                  _SectionCard(
                    title: l.profile_diseases,
                    icon: Icons.medical_information_outlined,
                    emptyText: l.profile_diseasesEmpty,
                    items: profile.diseases.map((d) => d.name).toList(),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Allergies
                  _SectionCard(
                    title: l.profile_allergies,
                    icon: Icons.warning_amber_rounded,
                    emptyText: l.profile_allergiesEmpty,
                    items:
                        profile.allergies.map((a) => a.name).toList(),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Medications
                  _MedicationsCard(
                      medications: profile.medications),

                  const SizedBox(height: AppSpacing.md),

                  // Emergency contacts
                  _EmergencyCard(
                      contacts: profile.emergencyContacts),

                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CompletionBanner extends StatelessWidget {
  final int percent;
  final VoidCallback onTap;

  const _CompletionBanner({required this.percent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: AppGradients.primary,
          borderRadius: BorderRadius.circular(AppDesign.cardRadius),
        ),
        child: Row(
          children: [
            const Icon(Icons.arrow_back_ios_rounded,
                color: Colors.white, size: 18),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  l.profile_completeBanner,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l.profile_completePercent(percent),
                  style:
                      TextStyle(color: Colors.white.withValues(alpha: 0.85)),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.assignment_outlined,
                  color: Colors.white, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}

class _BasicInfoCard extends StatelessWidget {
  final MedicalProfileEntity profile;

  const _BasicInfoCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name + avatar
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    profile.fullName.isNotEmpty
                        ? profile.fullName[0]
                        : '؟',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.fullName,
                          style: AppTextStyles.heading3),
                      Text(l.common_years(profile.age),
                          style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            // Stats
            Row(
              children: [
                Expanded(
                    child: _InfoChip(
                        label: l.profile_bloodType,
                        value: profile.bloodType ?? '—')),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                    child: _InfoChip(
                        label: l.profile_height,
                        value: profile.height != null
                            ? '${profile.height!.toStringAsFixed(0)} ${l.common_cm}'
                            : '—')),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                    child: _InfoChip(
                        label: l.profile_weight,
                        value: profile.weight != null
                            ? '${profile.weight!.toStringAsFixed(0)} ${l.common_kg}'
                            : '—')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: AppTextStyles.heading3),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String emptyText;
  final List<String> items;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.emptyText,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, size: 22, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(title, style: AppTextStyles.heading3),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (items.isEmpty)
              Text(emptyText,
                  style: AppTextStyles.bodySecondary,
                  textAlign: TextAlign.center)
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: items
                    .map((item) => Chip(
                          label: Text(item),
                          backgroundColor: AppColors.primaryLight,
                          labelStyle: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                          ),
                          shape: const StadiumBorder(),
                          side: BorderSide.none,
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _MedicationsCard extends StatelessWidget {
  final List<MedicationEntity> medications;

  const _MedicationsCard({required this.medications});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.medication_rounded,
                    size: 22, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(l.profile_medications, style: AppTextStyles.heading3),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (medications.isEmpty)
              Text(l.profile_medicationsEmpty,
                  style: AppTextStyles.bodySecondary,
                  textAlign: TextAlign.center)
            else
              ...medications.map((m) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.name, style: AppTextStyles.label),
                        Text('${m.dosage} — ${m.frequency}',
                            style: AppTextStyles.caption),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  final List<EmergencyContactEntity> contacts;

  const _EmergencyCard({required this.contacts});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.emergency_outlined,
                    size: 22, color: AppColors.danger),
                const SizedBox(width: AppSpacing.sm),
                Text(l.profile_emergency, style: AppTextStyles.heading3),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (contacts.isEmpty)
              Text(l.profile_emergencyEmpty,
                  style: AppTextStyles.bodySecondary,
                  textAlign: TextAlign.center)
            else
              ...contacts.map((c) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.call_rounded,
                            size: 20, color: AppColors.success),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.name, style: AppTextStyles.label),
                              Text('${c.phone} — ${c.relation}',
                                  style: AppTextStyles.caption),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
