/// نظام التصميم — متوافق مع Stitch AI "The Digital Sanctuary"
library;

import 'dart:ui';

import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────
/// ألوان تطبيق يمينك — Stitch Design Tokens
/// ─────────────────────────────────────────────
class AppColors {
  AppColors._();

  // الألوان الأساسية (Primary — أزرق بحري سعودي)
  static const primary = Color(0xFF00386C);
  static const primaryContainer = Color(0xFF1A4F8B);
  static const primaryFixed = Color(0xFFD5E3FF);
  static const primaryFixedDim = Color(0xFFA6C8FF);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onPrimaryContainer = Color(0xFF9BC2FF);

  // الألوان الثانوية (Secondary — أزرق ثقة)
  static const secondary = Color(0xFF006491);
  static const secondaryContainer = Color(0xFF85CBFD);
  static const secondaryFixed = Color(0xFFC9E6FF);
  static const onSecondary = Color(0xFFFFFFFF);
  static const onSecondaryContainer = Color(0xFF00567D);

  // الألوان الثالثية (Tertiary — ذهبي صحراوي دافئ)
  static const tertiary = Color(0xFF552E00);
  static const tertiaryContainer = Color(0xFF764100);
  static const tertiaryFixed = Color(0xFFFFDCC0);
  static const tertiaryFixedDim = Color(0xFFFFB875);
  static const onTertiary = Color(0xFFFFFFFF);
  static const onTertiaryContainer = Color(0xFFFFAE60);

  // الأسطح والخلفيات (Tonal Layering)
  static const surface = Color(0xFFF7F9FF);
  static const surfaceContainerLow = Color(0xFFF1F4FA);
  static const surfaceContainer = Color(0xFFEBEEF4);
  static const surfaceContainerHigh = Color(0xFFE5E8EE);
  static const surfaceContainerHighest = Color(0xFFDFE3E8);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceDim = Color(0xFFD7DAE0);
  static const surfaceBright = Color(0xFFF7F9FF);

  // النصوص
  static const onSurface = Color(0xFF181C20);
  static const onSurfaceVariant = Color(0xFF424750);
  static const onBackground = Color(0xFF181C20);
  static const inverseSurface = Color(0xFF2D3135);
  static const inverseOnSurface = Color(0xFFEEF1F7);

  // الحدود (Ghost Borders)
  static const outline = Color(0xFF737781);
  static const outlineVariant = Color(0xFFC2C6D1);

  // حالات النظام
  static const error = Color(0xFFBA1A1A);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onError = Color(0xFFFFFFFF);
  static const onErrorContainer = Color(0xFF93000A);

  // ألوان دلالية (Semantic — مبنية على النظام)
  static const success = Color(0xFF27AE60);
  static const successLight = Color(0xFFEAFAF1);
  static const warning = Color(0xFFF39C12);
  static const warningLight = Color(0xFFFEF9E7);

  // Shimmer
  static const shimmerBase = Color(0xFFE0E0E0);
  static const shimmerHighlight = Color(0xFFF5F5F5);

  // ─── Aliases للتوافق مع الكود الحالي ───
  static const background = surface;
  static const textPrimary = onSurface;
  static const textSecondary = onSurfaceVariant;
  static const textMuted = outline;
  static const border = outlineVariant;
  static const accent = secondary;
  static const primaryLight = primaryFixed;
  static const primaryDark = primary;
  static const danger = error;
  static const dangerLight = errorContainer;
}

/// ─────────────────────────────────────────────
/// الأبعاد — 4px/8px baseline مع مساحات سخية
/// ─────────────────────────────────────────────
class AppSpacing {
  AppSpacing._();

  static const double xs = 4; // Scale 1
  static const double sm = 8; // Scale 2
  static const double md = 16; // Scale 4
  static const double lg = 20; // Scale 5
  static const double xl = 24; // Scale 6
  static const double xxl = 32; // Scale 8
  static const double xxxl = 48; // Scale 12

  static const cardPadding = EdgeInsets.all(xl);
  static const screenPadding = EdgeInsets.all(lg);
  static const tabletScreenPadding = EdgeInsets.all(xxl);
  static const sectionGap = SizedBox(height: xxl);
}

/// ─────────────────────────────────────────────
/// أنماط النصوص — Cairo للعربي + Editorial Scale
/// ─────────────────────────────────────────────
class AppTextStyles {
  AppTextStyles._();

  static const _arabic = 'Cairo';

  // Display — لحظات المعلومات الكبيرة
  static const displayLg = TextStyle(
    fontFamily: _arabic,
    fontSize: 56,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
    height: 1.1,
  );

  // Headlines — نقاط دخول الأقسام
  static const headlineMd = TextStyle(
    fontFamily: _arabic,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
    height: 1.3,
  );

  // Titles — عناوين الكروت
  static const titleLg = TextStyle(
    fontFamily: _arabic,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.3,
  );

  // Body — نص القراءة الأساسي
  static const bodyLg = TextStyle(
    fontFamily: _arabic,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
    height: 1.6,
  );

  static const bodyMd = TextStyle(
    fontFamily: _arabic,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
    height: 1.5,
  );

  // Labels — البيانات الوصفية
  static const labelMd = TextStyle(
    fontFamily: _arabic,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.outline,
    height: 1.4,
    letterSpacing: 0.5,
  );

  static const labelLg = TextStyle(
    fontFamily: _arabic,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    height: 1.3,
  );

  // ─── Aliases للتوافق مع الكود القديم ───
  static const heading1 = headlineMd;
  static const heading2 = titleLg;
  static const heading3 = TextStyle(
    fontFamily: _arabic,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.3,
  );
  static const body = bodyLg;
  static const bodySecondary = TextStyle(
    fontFamily: _arabic,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
    height: 1.5,
  );
  static const caption = labelMd;
  static const label = labelLg;
  static const stat = displayLg;
}

/// ─────────────────────────────────────────────
/// التدرجات — Glass & Gradient Rule
/// ─────────────────────────────────────────────
class AppGradients {
  AppGradients._();

  /// تدرج الأزرار الرئيسية: primary → primaryContainer
  static const primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.primaryContainer],
  );

  /// تدرج شاشة تسجيل الدخول
  static const loginBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.primary, Color(0xFF0C2D54)],
  );

  /// تدرج أشرطة التقدم الذكية
  static const progressBar = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [AppColors.secondary, AppColors.secondaryFixed],
  );
}

/// ─────────────────────────────────────────────
/// ثوابت التصميم — No-Line Rule + Rounded
/// ─────────────────────────────────────────────
class AppDesign {
  AppDesign._();

  // زوايا مدورة
  static const double cardRadius = 16; // lg
  static const double cardRadiusXl = 24; // xl
  static const double buttonRadius = 100; // full — أزرار مدورة بالكامل
  static const double inputRadius = 12; // md
  static const double buttonHeight = 56;

  // ظلال Ambient (لون Primary مع شفافية منخفضة)
  static final ambientShadow = BoxShadow(
    color: AppColors.primary.withValues(alpha: 0.06),
    blurRadius: 40,
    offset: const Offset(0, 12),
  );

  // Ghost Border (15% opacity — استخدام فقط عند الضرورة)
  static final ghostBorder = Border.all(
    color: AppColors.outlineVariant.withValues(alpha: 0.15),
    width: 1,
  );

  /// Glassmorphism decoration للعناصر العائمة
  static BoxDecoration glassDecoration({
    double opacity = 0.75,
    double blurRadius = 20,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      color: AppColors.surface.withValues(alpha: opacity),
      borderRadius: borderRadius ?? BorderRadius.circular(cardRadius),
      border: Border.all(
        color: AppColors.outlineVariant.withValues(alpha: 0.1),
      ),
    );
  }
}

/// ─────────────────────────────────────────────
/// Glass Effect Widget Helper
/// ─────────────────────────────────────────────
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.opacity = 0.75,
    this.blurRadius = 20,
    this.borderRadius,
    this.padding,
  });

  final Widget child;
  final double opacity;
  final double blurRadius;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(AppDesign.cardRadius);
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
        child: Container(
          padding: padding,
          decoration: AppDesign.glassDecoration(
            opacity: opacity,
            blurRadius: blurRadius,
            borderRadius: radius,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────────
/// بناء الثيم الكامل
/// ─────────────────────────────────────────────
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryContainer,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryContainer,
      tertiary: AppColors.tertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      error: AppColors.error,
      errorContainer: AppColors.errorContainer,
      surface: AppColors.surface,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onTertiary: AppColors.onTertiary,
      onError: AppColors.onError,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      inverseSurface: AppColors.inverseSurface,
      onInverseSurface: AppColors.inverseOnSurface,
      surfaceContainerLowest: AppColors.surfaceContainerLowest,
      surfaceContainerLow: AppColors.surfaceContainerLow,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
    ),
    scaffoldBackgroundColor: AppColors.surface,
    fontFamily: 'Cairo',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: AppColors.onPrimary,
        minimumSize: const Size(double.infinity, AppDesign.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.buttonRadius),
        ),
        elevation: 0,
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, AppDesign.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.buttonRadius),
        ),
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDesign.inputRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDesign.inputRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDesign.inputRadius),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDesign.inputRadius),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      filled: true,
      fillColor: AppColors.surfaceContainerLow,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceContainerLowest,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesign.cardRadius),
      ),
      margin: EdgeInsets.zero,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.tertiaryFixedDim,
      labelStyle: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.tertiary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesign.cardRadius),
      ),
      side: BorderSide.none,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.onPrimary;
        }
        return AppColors.outline;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryContainer;
        }
        return AppColors.surfaceContainerHigh;
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.secondary,
      linearTrackColor: AppColors.surfaceContainerHigh,
      linearMinHeight: 12,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.outline,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    dividerTheme: const DividerThemeData(
      color: Colors.transparent,
      thickness: 0,
    ),
  );
}
