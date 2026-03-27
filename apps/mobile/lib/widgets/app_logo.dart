/// شعار يمينك — يستخدم في شاشة الدخول والـ splash screen
library;

import 'package:flutter/material.dart';
import '../app/app_images.dart';
import '../app/theme.dart';

class AppLogo extends StatelessWidget {
  /// [size] عرض الشعار بالبكسل (الافتراضي 180)
  /// [showTagline] إظهار "نظام الرعاية المتكاملة" تحت الشعار
  const AppLogo({super.key, this.size = 180, this.showTagline = true});

  final double size;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          AppImages.logoFull,
          width: size,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _FallbackLogo(size: size),
        ),
      ],
    );
  }
}

/// يُعرض إذا لم يُضَف ملف الشعار بعد
class _FallbackLogo extends StatelessWidget {
  const _FallbackLogo({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.health_and_safety_outlined,
              size: 64, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            'يمينك',
            style: AppTextStyles.displayLg.copyWith(color: AppColors.primary),
          ),
          Text(
            'ameenak',
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.secondary),
          ),
          Text(
            'نظام الرعاية المتكاملة',
            style:
                AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
