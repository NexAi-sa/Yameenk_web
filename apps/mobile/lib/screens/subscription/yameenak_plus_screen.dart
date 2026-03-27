/// شاشة اشتراك يمينك بلس — نسخة مضغوطة لسكرين شوت أبل ستور
library;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/theme.dart';
import '../../main.dart';
import '../../features/subscription/presentation/cubit/subscription_cubit.dart';
import '../../features/subscription/presentation/cubit/subscription_state.dart';

// ─── URLs ───
const _termsUrl = 'https://yameenak.com/terms';
const _privacyUrl = 'https://yameenak.com/privacy';

class YameenakPlusScreen extends StatelessWidget {
  const YameenakPlusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      builder: (context, subState) {
        return Scaffold(
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ──── Header gradient (مضغوط) ────
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: AppGradients.loginBackground,
                    ),
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      MediaQuery.of(context).padding.top + AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.xl,
                    ),
                    child: Column(
                      children: [
                        // Close button
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded,
                                color: Colors.white, size: 22),
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.15),
                              padding: const EdgeInsets.all(6),
                              minimumSize: const Size(32, 32),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        // Plus icon (مصغّر)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.stars_rounded,
                              size: 36, color: Colors.white),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          l.plus_upgradeTitle,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l.plus_upgradeSubtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // ──── Content card ────
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    transform: Matrix4.translationValues(0, -20, 0),
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ──── مميزات العضوية (compact) ────
                        Text(
                          l.plus_features,
                          style: AppTextStyles.heading3.copyWith(fontSize: 16),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: AppSpacing.sm),

                        _CompactFeatureRow(
                          icon: Icons.chat_rounded,
                          color: AppColors.success,
                          title: l.plus_whatsappTitle,
                          description: l.plus_whatsappDesc,
                        ),
                        const SizedBox(height: 6),
                        _CompactFeatureRow(
                          icon: Icons.psychology_rounded,
                          color: AppColors.secondary,
                          title: l.plus_aiTitle,
                          description: l.plus_aiDesc,
                        ),
                        const SizedBox(height: 6),
                        _CompactFeatureRow(
                          icon: Icons.monitor_heart_rounded,
                          color: AppColors.tertiaryFixedDim,
                          title: l.plus_monitorTitle,
                          description: l.plus_monitorDesc,
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // ──── الخطة الشهرية (وحيدة) ────
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(
                                AppDesign.cardRadius),
                            border: Border.all(
                              color: AppColors.primary
                                  .withValues(alpha: 0.5),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Radio (selected)
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 11,
                                    height: 11,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(l.plus_monthly,
                                      style: AppTextStyles.label),
                                  const SizedBox(height: 2),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: l.plus_monthlyPrice,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' ${l.plus_perMonth}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // ──── Subscribe button ────
                        ElevatedButton(
                          onPressed: subState.isLoading
                              ? null
                              : () async {
                                  final successMsg = l.plus_welcomeMsg;
                                  final cubit =
                                      context.read<SubscriptionCubit>();
                                  final success = await cubit
                                      .subscribe(SubscriptionPlan.monthlyPlus);
                                  if (!context.mounted) return;
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(successMsg,
                                            textAlign: TextAlign.right),
                                        backgroundColor: AppColors.success,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: subState.isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  l.plus_subscribe,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // ──── روابط الشروط والخصوصية ────
                        Center(
                          child: Text.rich(
                            TextSpan(
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 11,
                              ),
                              children: [
                                TextSpan(text: '${l.plus_terms.split('.').first}. '),
                                TextSpan(
                                  text: l.plus_termsLink,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () =>
                                        launchUrl(Uri.parse(_termsUrl)),
                                ),
                                const TextSpan(text: ' · '),
                                TextSpan(
                                  text: l.plus_privacyLink,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () =>
                                        launchUrl(Uri.parse(_privacyUrl)),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // ──── معلومات أبل المهمة ────
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.outline.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    l.plus_appleInfo,
                                    style: AppTextStyles.caption.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(Icons.info_outline_rounded,
                                      size: 16,
                                      color: AppColors.textSecondary),
                                ],
                              ),
                              const SizedBox(height: 6),
                              _AppleInfoBullet(text: l.plus_autoRenew),
                              const SizedBox(height: 4),
                              _AppleInfoBullet(text: l.plus_cancelInfo),
                              const SizedBox(height: 4),
                              _AppleInfoBullet(text: l.plus_noRefund),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSpacing.md),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ──── Compact feature row ────
class _CompactFeatureRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;

  const _CompactFeatureRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                ),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ──── Apple info bullet ────
class _AppleInfoBullet extends StatelessWidget {
  final String text;
  const _AppleInfoBullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
                fontSize: 10.5,
                height: 1.4,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }
}
