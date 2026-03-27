/// بوابة يمينك بلس — تمنع الوصول لمميزات مدفوعة بدون اشتراك
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../app/theme.dart';
import '../main.dart';
import '../providers/subscription_provider.dart';

class PlusGate extends ConsumerWidget {
  final Widget child;
  final String featureName;

  const PlusGate({
    super.key,
    required this.child,
    required this.featureName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlus = ref.watch(isPlusProvider);
    if (isPlus) return child;

    final l = context.l10n;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.tertiaryFixed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.stars_rounded,
                    size: 48, color: AppColors.tertiaryFixedDim),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(l.gate_exclusive,
                  style: AppTextStyles.heading2, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l.gate_subscribeFor(featureName),
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/plus'),
                  icon: const Icon(Icons.stars_rounded),
                  label: Text(l.gate_upgrade),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(l.common_back),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
