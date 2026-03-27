library;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/app_images.dart';
import '../../../../app/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../locale/presentation/cubit/locale_cubit.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _AmbientBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxl,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                children: [
                  // زر تبديل اللغة
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        context.read<LocaleCubit>().toggleLocale();
                      },
                      icon: const Icon(Icons.language, size: 20),
                      label: Text(S.of(context).language_toggle),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.surfaceContainerLow,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),

                  // الشعار بدون خلفية
                  Image.asset(
                    AppImages.logoNoBg,
                    width: 180,
                    height: 180,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.health_and_safety_outlined,
                      size: 80,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // اسم التطبيق
                  Text(
                    S.of(context).appTitle,
                    style: AppTextStyles.displayLg.copyWith(
                      color: AppColors.primary,
                      fontSize: 42,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    S.of(context).welcome_subtitle,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Tagline
                  Text(
                    S.of(context).welcome_tagline,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLg.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    S.of(context).welcome_tagline2,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLg.copyWith(
                      color: AppColors.secondary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(flex: 3),

                  // أزرار الأكشن
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.go('/register'),
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18)),
                          child: Text(S.of(context).welcome_getStarted,
                              style: const TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => context.go('/login'),
                          style: OutlinedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(vertical: 18),
                            side: const BorderSide(
                                color: AppColors.primary, width: 1.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                          ),
                          child: Text(S.of(context).login_title,
                              style: const TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // العناصر الزخرفية
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified_user_outlined,
                          color:
                              AppColors.outlineVariant.withValues(alpha: 0.4),
                          size: 28),
                      const SizedBox(width: AppSpacing.xl),
                      Icon(Icons.health_and_safety_outlined,
                          color:
                              AppColors.outlineVariant.withValues(alpha: 0.4),
                          size: 28),
                      const SizedBox(width: AppSpacing.xl),
                      Icon(Icons.favorite_outline,
                          color:
                              AppColors.outlineVariant.withValues(alpha: 0.4),
                          size: 28),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    S.of(context).welcome_footer,
                    style: AppTextStyles.labelMd.copyWith(
                      color: Colors.grey.withValues(alpha: 0.6),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            width: 400,
            height: 400,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryFixed.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            width: 350,
            height: 350,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondaryFixed.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
