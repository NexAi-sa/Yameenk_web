/// شاشة إخلاء المسؤولية الطبية — Medical Disclaimer (App Store §1.4.1)
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/theme.dart';
import '../../core/responsive_scaffold.dart';
import '../../main.dart';

/// Key used to persist the user's acceptance of the medical disclaimer.
const kMedicalDisclaimerAcceptedKey = 'medical_disclaimer_accepted';

/// Checks if the user has already accepted the medical disclaimer.
Future<bool> hasMedicalDisclaimerBeenAccepted() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(kMedicalDisclaimerAcceptedKey) ?? false;
}

class MedicalDisclaimerScreen extends StatelessWidget {
  final VoidCallback onAccepted;
  const MedicalDisclaimerScreen({super.key, required this.onAccepted});

  Future<void> _accept(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kMedicalDisclaimerAcceptedKey, true);
    onAccepted();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 600,
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              children: [
                const Spacer(flex: 1),

                // Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.medical_information_rounded,
                    size: 56,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Title
                Text(
                  l.disclaimer_title,
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Disclaimer body
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppDesign.cardRadius),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      _DisclaimerPoint(
                        icon: Icons.info_outline_rounded,
                        text: l.disclaimer_point1,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _DisclaimerPoint(
                        icon: Icons.person_search_rounded,
                        text: l.disclaimer_point2,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _DisclaimerPoint(
                        icon: Icons.local_hospital_rounded,
                        text: l.disclaimer_point3,
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 2),

                // Accept button
                ElevatedButton(
                  onPressed: () => _accept(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: Text(
                    l.disclaimer_accept,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l.disclaimer_footer,
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
    );
  }
}

class _DisclaimerPoint extends StatelessWidget {
  final IconData icon;
  final String text;
  const _DisclaimerPoint({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: AppColors.warning),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMd.copyWith(
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
