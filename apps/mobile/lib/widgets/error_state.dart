/// حالة خطأ قابلة لإعادة المحاولة — Error State Widget
library;

import 'package:flutter/material.dart';
import '../app/theme.dart';
import '../main.dart';

class ErrorStateWidget extends StatelessWidget {
  final String? message;
  final String? detail;
  final IconData icon;
  final VoidCallback? onRetry;
  final String? buttonText;

  const ErrorStateWidget({
    super.key,
    this.message,
    this.detail,
    this.icon = Icons.error_outline_rounded,
    this.onRetry,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.dangerLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: AppColors.danger),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message ?? l.dashboard_errorLoad,
              style: AppTextStyles.heading3,
              textAlign: TextAlign.center,
            ),
            if (detail != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                detail!,
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(buttonText ?? l.common_retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
