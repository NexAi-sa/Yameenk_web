/// شاشة اشتراك يمينك بلس — مطابقة لتصميم Stitch AI
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/theme.dart';
import '../../core/responsive_scaffold.dart';
import '../../main.dart';
import '../../features/subscription/presentation/cubit/subscription_cubit.dart';
import '../../features/subscription/presentation/cubit/subscription_state.dart';

class YameenakPlusScreen extends StatefulWidget {
  const YameenakPlusScreen({super.key});

  @override
  State<YameenakPlusScreen> createState() => _YameenakPlusScreenState();
}

class _YameenakPlusScreenState extends State<YameenakPlusScreen> {
  SubscriptionPlan _selectedPlan = SubscriptionPlan.yearlyPlus;

  Future<void> _subscribe() async {
    final successMsg = context.l10n.plus_welcomeMsg;
    final success =
        await context.read<SubscriptionCubit>().subscribe(_selectedPlan);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMsg, textAlign: TextAlign.right),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      builder: (context, subState) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // ──── Header gradient ────
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: AppGradients.loginBackground,
                  ),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    MediaQuery.of(context).padding.top + AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.xxl,
                  ),
                  child: Column(
                    children: [
                      // Close button
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded,
                              color: Colors.white),
                          style: IconButton.styleFrom(
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Plus icon
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.stars_rounded,
                            size: 48, color: Colors.white),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        l.plus_upgradeTitle,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        l.plus_upgradeSubtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.85),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // ──── Content ────
              SliverToBoxAdapter(
                child: ResponsiveCenter(
                  maxWidth: 700,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    transform: Matrix4.translationValues(0, -24, 0),
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.xl,
                      AppSpacing.lg,
                      AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ──── Membership features ────
                        Text(
                          l.plus_features,
                          style: AppTextStyles.heading3,
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        _FeatureCard(
                          icon: Icons.chat_rounded,
                          color: AppColors.success,
                          title: l.plus_whatsappTitle,
                          description: l.plus_whatsappDesc,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _FeatureCard(
                          icon: Icons.psychology_rounded,
                          color: AppColors.secondary,
                          title: l.plus_aiTitle,
                          description: l.plus_aiDesc,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _FeatureCard(
                          icon: Icons.monitor_heart_rounded,
                          color: AppColors.tertiaryFixedDim,
                          title: l.plus_monitorTitle,
                          description: l.plus_monitorDesc,
                        ),

                        const SizedBox(height: AppSpacing.xxl),

                        // ──── Plans ────
                        Text(
                          l.plus_choosePlan,
                          style: AppTextStyles.heading3,
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Yearly
                        _PlanCard(
                          title: l.plus_yearly,
                          price: l.plus_yearlyPrice,
                          period: l.plus_perYear,
                          badge: l.plus_save29,
                          isSelected:
                              _selectedPlan == SubscriptionPlan.yearlyPlus,
                          onTap: () => setState(
                              () => _selectedPlan =
                                  SubscriptionPlan.yearlyPlus),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Monthly
                        _PlanCard(
                          title: l.plus_monthly,
                          price: l.plus_monthlyPrice,
                          period: l.plus_perMonth,
                          isSelected:
                              _selectedPlan == SubscriptionPlan.monthlyPlus,
                          onTap: () => setState(
                              () => _selectedPlan =
                                  SubscriptionPlan.monthlyPlus),
                        ),

                        const SizedBox(height: AppSpacing.xxl),

                        // ──── Subscribe button ────
                        ElevatedButton(
                          onPressed:
                              subState.isLoading ? null : _subscribe,
                          style: ElevatedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: subState.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  l.plus_subscribe,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Terms
                        Text(
                          l.plus_terms,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textMuted,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ──── Feature card ────
class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDesign.cardRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style:
                      AppTextStyles.label.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
        ],
      ),
    );
  }
}

// ──── Plan card ────
class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final String? badge;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.period,
    this.badge,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryFixed.withValues(alpha: 0.3)
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppDesign.cardRadius),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Radio
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? AppColors.primary : AppColors.outline,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const Spacer(),
            // Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    if (badge != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          badge!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(title, style: AppTextStyles.label),
                  ],
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: price,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      TextSpan(
                        text: ' $period',
                        style: const TextStyle(
                          fontSize: 13,
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
    );
  }
}
