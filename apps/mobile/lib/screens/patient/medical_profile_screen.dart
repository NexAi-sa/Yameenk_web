/// الملف الطبي — Medical Profile
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../core/responsive_scaffold.dart';
import '../../main.dart';
import '../../models/patient.dart';
import '../../providers/patient_provider.dart';

class MedicalProfileScreen extends ConsumerWidget {
  const MedicalProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientAsync = ref.watch(patientProvider);
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l.profile_title)),
      body: patientAsync.when(
        data: (patient) => ResponsiveCenter(
          maxWidth: 800,
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Completion banner
                if (patient.profileCompletionPercent < 100)
                  _CompletionBanner(
                    percent: patient.profileCompletionPercent,
                    onTap: () => context.go('/patient/profile/setup'),
                  ),

                const SizedBox(height: AppSpacing.md),

                // Basic info
                _BasicInfoCard(patient: patient),

                const SizedBox(height: AppSpacing.md),

                // Diseases
                _SectionCard(
                  title: l.profile_diseases,
                  icon: Icons.medical_information_outlined,
                  emptyText: l.profile_diseasesEmpty,
                  items: patient.conditions,
                ),

                const SizedBox(height: AppSpacing.md),

                // Allergies
                _SectionCard(
                  title: l.profile_allergies,
                  icon: Icons.warning_amber_rounded,
                  emptyText: l.profile_allergiesEmpty,
                  items: patient.allergies ?? [],
                ),

                const SizedBox(height: AppSpacing.md),

                // Medications
                _MedicationsCard(medications: patient.medications ?? []),

                const SizedBox(height: AppSpacing.md),

                // Emergency contacts
                _EmergencyCard(contacts: patient.emergencyContacts ?? []),

                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.common_error(e.toString()))),
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
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
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
  final Patient patient;

  const _BasicInfoCard({required this.patient});

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
                    patient.name.isNotEmpty ? patient.name[0] : '؟',
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
                      Text(patient.name, style: AppTextStyles.heading3),
                      Text(l.common_years(patient.age),
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
                        value: patient.bloodType ?? '—')),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                    child: _InfoChip(
                        label: l.profile_height,
                        value: patient.height != null
                            ? '${patient.height} ${l.common_cm}'
                            : '—')),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                    child: _InfoChip(
                        label: l.profile_weight,
                        value: patient.weight != null
                            ? '${patient.weight} ${l.common_kg}'
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
                          labelStyle: TextStyle(
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
  final List<Medication> medications;

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
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m.name, style: AppTextStyles.label),
                              Text('${m.dosage} — ${m.frequency}',
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

class _EmergencyCard extends StatelessWidget {
  final List<EmergencyContact> contacts;

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
