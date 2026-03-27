import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../features/locale/presentation/cubit/locale_cubit.dart';
import '../../widgets/app_logo.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. الخلفية المتدرجة (Ambient Background)
          const _AmbientBackground(),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxl,
                vertical: AppSpacing.xl,
              ),
              child: Column(
                children: [
                  // 2. زر تبديل اللغة (Top Right in RTL)
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
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // 3. كتلة الهوية (Logo & Brand)
                  Column(
                    children: [
                      // Logo Container
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [AppDesign.ambientShadow],
                        ),
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: const AppLogo(size: 100),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      
                      // Textual Brand
                      Text(
                        'يمينك',
                        style: AppTextStyles.displayLg.copyWith(
                          color: AppColors.primary,
                          fontSize: 48,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        height: 4,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.tertiaryFixedDim,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSpacing.xxxl),
                  
                  // 4. Tagline
                  Text(
                    'سندك الذكي لرعاية من تحب..',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLg.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'طمأنينة لك، وعناية تليق بهم.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLg.copyWith(
                      color: AppColors.secondary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // 5. أزرار الأكشن (Action Cluster)
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => context.go('/register'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: const Text('ابدأ الآن', style: TextStyle(fontSize: 20)),
                      ),

                    ],
                  ),
                  
                  const SizedBox(height: AppSpacing.xxxl),
                  
                  // 6. العناصر الزخرفية في الأسفل
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.verified_user_outlined, 
                            color: AppColors.outlineVariant.withValues(alpha: 0.4), size: 32),
                          const SizedBox(width: AppSpacing.xl),
                          Icon(Icons.health_and_safety_outlined, 
                            color: AppColors.outlineVariant.withValues(alpha: 0.4), size: 32),
                          const SizedBox(width: AppSpacing.xl),
                          Icon(Icons.favorite_outline, 
                            color: AppColors.outlineVariant.withValues(alpha: 0.4), size: 32),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Care Reimagined • Yameenak Saudi Arabia',
                        style: AppTextStyles.labelMd.copyWith(
                          color: Colors.grey.withValues(alpha: 0.6),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
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
