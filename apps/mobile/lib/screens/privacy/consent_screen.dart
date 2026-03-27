/// شاشة الموافقة الصريحة (PDPL Consent)
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/theme.dart';
import '../../core/responsive_scaffold.dart';
import '../../main.dart';
import '../../features/privacy/domain/entities/consent_entity.dart';
import '../../features/privacy/presentation/cubit/consent_cubit.dart';
import '../../features/privacy/presentation/cubit/consent_state.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    return BlocBuilder<ConsentCubit, ConsentState>(
      builder: (context, state) {
        final consents = state is ConsentLoaded
            ? state.consent.consents
            : <ConsentType, bool>{};
        final isLoading = state is ConsentSubmitting;

        return Scaffold(
          body: SafeArea(
            child: ResponsiveCenter(
              maxWidth: 600,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.xl),

                    // Shield icon
                    const Icon(Icons.shield_outlined,
                        size: 64, color: AppColors.primary),
                    const SizedBox(height: AppSpacing.lg),

                    Text(l.consent_protectTitle,
                        style: AppTextStyles.heading1,
                        textAlign: TextAlign.center),
                    const SizedBox(height: AppSpacing.sm),
                    Text(l.consent_protectSubtitle,
                        style: AppTextStyles.bodySecondary,
                        textAlign: TextAlign.center),

                    const SizedBox(height: AppSpacing.xl),

                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Essential consents
                            _SectionHeader(
                              title: l.consent_essential,
                              subtitle: l.consent_essentialSub,
                              color: AppColors.primary,
                            ),
                            ...ConsentType.values
                                .where((t) => t.isEssential)
                                .map((t) => _ConsentTile(
                                      type: t,
                                      value: consents[t] ?? false,
                                      onChanged: (v) => context
                                          .read<ConsentCubit>()
                                          .toggle(t, v),
                                    )),

                            const SizedBox(height: AppSpacing.xl),

                            // Optional consents
                            _SectionHeader(
                              title: l.consent_optional,
                              subtitle: l.consent_optionalSub,
                              color: AppColors.secondary,
                            ),
                            ...ConsentType.values
                                .where((t) => !t.isEssential)
                                .map((t) => _ConsentTile(
                                      type: t,
                                      value: consents[t] ?? false,
                                      onChanged: (v) => context
                                          .read<ConsentCubit>()
                                          .toggle(t, v),
                                    )),

                            const SizedBox(height: AppSpacing.lg),

                            // Privacy policy link
                            TextButton.icon(
                              onPressed: () => context.push('/privacy-settings'),
                              icon: const Icon(Icons.privacy_tip_outlined),
                              label: Text(l.consent_readPrivacy),
                            ),

                            Text(l.consent_withdrawNote,
                                style: AppTextStyles.caption,
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Submit button
                    ElevatedButton(
                      onPressed: isLoading ? null : () => _submit(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(l.consent_agreeStart,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _submit(BuildContext context) async {
    final cubit = context.read<ConsentCubit>();
    final state = cubit.state;
    if (state is! ConsentLoaded) return;

    if (!state.consent.essentialConsentsGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.consent_errorRequired,
              textAlign: TextAlign.right),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final errorMsg = context.l10n.consent_errorSave;
    final success = await cubit.submit();
    if (!mounted) return;
    if (success) {
      // Persist consent acceptance for the route guard (PDPL).
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('pdpl_consent_completed_sp', true);
      if (!mounted) return;
      this.context.go('/family');
    } else {
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          content: Text(errorMsg, textAlign: TextAlign.right),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(title, style: AppTextStyles.heading3),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(subtitle, style: AppTextStyles.caption),
          ),
        ],
      ),
    );
  }
}

class _ConsentTile extends StatelessWidget {
  final ConsentType type;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ConsentTile({
    required this.type,
    required this.value,
    required this.onChanged,
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
      _ => type.label,
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
      _ => type.description,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDesign.cardRadius),
      ),
      child: SwitchListTile(
        title: Text(_localizedLabel(context), style: AppTextStyles.label),
        subtitle: Text(_localizedDesc(context),
            style: AppTextStyles.caption.copyWith(height: 1.4)),
        value: value,
        onChanged: onChanged,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.cardRadius),
        ),
      ),
    );
  }
}
