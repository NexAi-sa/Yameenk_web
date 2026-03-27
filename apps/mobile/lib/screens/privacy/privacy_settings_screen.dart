/// شاشة إعدادات الخصوصية — Privacy Settings (PDPL)
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/theme.dart';
import '../../core/responsive_scaffold.dart';
import '../../main.dart';
import '../../features/privacy/domain/entities/consent_entity.dart';
import '../../features/privacy/presentation/cubit/consent_cubit.dart';
import '../../features/privacy/presentation/cubit/consent_state.dart';

class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l.privacy_title)),
      body: BlocBuilder<ConsentCubit, ConsentState>(
        builder: (context, state) {
          final consents = state is ConsentLoaded
              ? state.consent.consents
              : <ConsentType, bool>{};

          return ResponsiveCenter(
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

                const SizedBox(height: AppSpacing.md),

                // No data selling banner (App Store §5.1.2)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppDesign.cardRadius),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_user_rounded,
                          size: 20, color: AppColors.success),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          l.privacy_noDataSelling,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Manage consents
                Text(l.privacy_manageConsents, style: AppTextStyles.heading2),
                const SizedBox(height: AppSpacing.md),

                ...ConsentType.values.map((t) => _ConsentSettingsTile(
                      type: t,
                      value: consents[t] ?? false,
                    )),

                const SizedBox(height: AppSpacing.xl),

                // Your rights
                Text(l.privacy_yourRights, style: AppTextStyles.heading2),
                const SizedBox(height: AppSpacing.md),

                _RightsTile(
                  icon: Icons.download_rounded,
                  title: l.privacy_downloadData,
                  subtitle: l.privacy_downloadDataSub,
                  onTap: () => _exportData(context),
                ),

                _RightsTile(
                  icon: Icons.delete_forever_rounded,
                  title: l.privacy_deleteAccount,
                  subtitle: l.privacy_deleteAccountSub,
                  danger: true,
                  onTap: () => _showDeleteDialog(context),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Privacy policy link
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l.privacy_exportError,
                            textAlign: TextAlign.right),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: Text(l.privacy_policy),
                ),

                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          );
        },
      ),
    );
  }

  void _exportData(BuildContext context) {
    // TODO: implement data export via API
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.privacy_exportError,
            textAlign: TextAlign.right),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
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
              _confirmDelete(context);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text(l.privacy_deleteConfirm),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
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
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: implement account deletion via API
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
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
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

  const _ConsentSettingsTile({
    required this.type,
    required this.value,
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
    final label = _localizedLabel(context);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDesign.cardRadius),
      ),
      child: SwitchListTile(
        title: Row(
          children: [
            Text(label, style: AppTextStyles.label),
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
            context.read<ConsentCubit>().toggle(type, true);
          } else {
            await context.read<ConsentCubit>().revoke(type);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.l10n.privacy_consentRevoked(label),
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
