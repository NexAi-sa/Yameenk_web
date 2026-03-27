/// شاشة إعدادات الخصوصية — Privacy Settings (PDPL)
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme.dart';
import '../../core/responsive_scaffold.dart';
import '../../main.dart';
import '../../services/api_service.dart';
import '../../services/consent_service.dart';
import '../../providers/auth_provider.dart';

class PrivacySettingsScreen extends ConsumerWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consentState = ref.watch(consentProvider);
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l.privacy_title)),
      body: ResponsiveCenter(
        maxWidth: 700,
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            // PDPL header
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppDesign.cardRadius),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.privacy_pdplTitle,
                            style: AppTextStyles.heading3),
                        const SizedBox(height: 4),
                        Text(l.privacy_pdplSubtitle,
                            style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  const Icon(Icons.shield_outlined,
                      size: 40, color: AppColors.primary),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Manage consents
            Text(l.privacy_manageConsents, style: AppTextStyles.heading2),
            const SizedBox(height: AppSpacing.md),

            ...ConsentType.values.map((t) => _ConsentSettingsTile(
                  type: t,
                  value: consentState.consents[t] ?? false,
                  ref: ref,
                )),

            const SizedBox(height: AppSpacing.xl),

            // Your rights
            Text(l.privacy_yourRights, style: AppTextStyles.heading2),
            const SizedBox(height: AppSpacing.md),

            _RightsTile(
              icon: Icons.download_rounded,
              title: l.privacy_downloadData,
              subtitle: l.privacy_downloadDataSub,
              onTap: () => _exportData(context, ref),
            ),

            _RightsTile(
              icon: Icons.delete_forever_rounded,
              title: l.privacy_deleteAccount,
              subtitle: l.privacy_deleteAccountSub,
              danger: true,
              onTap: () => _showDeleteDialog(context, ref),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Privacy policy link
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.open_in_new_rounded),
              label: Text(l.privacy_policy),
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    try {
      final api = ref.read(apiServiceProvider);
      final patientId = ref.read(authProvider).patientId;
      final data = await api.exportPatientData(patientId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l.privacy_exportSuccess(data.keys.length),
              textAlign: TextAlign.right,
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.privacy_exportError, textAlign: TextAlign.right),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.privacy_deleteTitle),
        content: Text(l.privacy_deleteMsg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.common_cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _confirmDelete(context, ref);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text(l.privacy_deleteConfirm),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.privacy_deleteFinalTitle),
        content: Text(l.privacy_deleteFinalMsg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.common_cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                final api = ref.read(apiServiceProvider);
                await api.deleteAccount();
                await ref.read(consentProvider.notifier).reset();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.privacy_deleteError,
                          textAlign: TextAlign.right),
                      backgroundColor: AppColors.danger,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                }
              }
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: Text(l.privacy_deleteFinal),
          ),
        ],
      ),
    );
  }
}

class _ConsentSettingsTile extends StatelessWidget {
  final ConsentType type;
  final bool value;
  final WidgetRef ref;

  const _ConsentSettingsTile({
    required this.type,
    required this.value,
    required this.ref,
  });

  String _localizedLabel(BuildContext context) {
    final l = context.l10n;
    return switch (type) {
      ConsentType.healthDataCollection => l.consent_type_healthData,
      ConsentType.aiAnalysis => l.consent_type_ai,
      ConsentType.whatsappNotifications => l.consent_type_whatsapp,
      ConsentType.pushNotifications => l.consent_type_push,
      ConsentType.analytics => l.consent_type_analytics,
      ConsentType.marketing => l.consent_type_marketing,
    };
  }

  String _localizedDesc(BuildContext context) {
    final l = context.l10n;
    return switch (type) {
      ConsentType.healthDataCollection => l.consent_type_healthDataDesc,
      ConsentType.aiAnalysis => l.consent_type_aiDesc,
      ConsentType.whatsappNotifications => l.consent_type_whatsappDesc,
      ConsentType.pushNotifications => l.consent_type_pushDesc,
      ConsentType.analytics => l.consent_type_analyticsDesc,
      ConsentType.marketing => l.consent_type_marketingDesc,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDesign.cardRadius),
      ),
      child: SwitchListTile(
        title: Row(
          children: [
            Text(_localizedLabel(context), style: AppTextStyles.label),
            if (type.isEssential) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(l.privacy_essential,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.primary)),
              ),
            ],
          ],
        ),
        subtitle: Text(_localizedDesc(context),
            style: AppTextStyles.caption.copyWith(height: 1.4)),
        value: value,
        onChanged: (v) async {
          if (v) {
            ref.read(consentProvider.notifier).toggleConsent(type, true);
          } else {
            final success =
                await ref.read(consentProvider.notifier).revokeConsent(type);
            if (success && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    l.privacy_consentRevoked(_localizedLabel(context)),
                    textAlign: TextAlign.right,
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            }
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.cardRadius),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
      ),
    );
  }
}

class _RightsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool danger;
  final VoidCallback onTap;

  const _RightsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.danger = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.danger : AppColors.primary;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDesign.cardRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDesign.cardRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.label),
                      Text(subtitle, style: AppTextStyles.caption),
                    ],
                  ),
                ),
                Icon(Icons.chevron_left, color: AppColors.outline, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
