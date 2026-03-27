/// أدوات الاستجابة — Responsive Utilities
/// breakpoints + extensions للتعامل مع أحجام الشاشات المختلفة
library;

import 'package:flutter/widgets.dart';

/// نقاط الانتقال بين أحجام الشاشات
class AppBreakpoints {
  AppBreakpoints._();

  /// تابلت: 600px وأعلى
  static const double tablet = 600;

  /// ديسكتوب: 1024px وأعلى
  static const double desktop = 1024;
}

/// Extension على BuildContext للوصول السريع لمعلومات الشاشة
extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isTablet => screenWidth >= AppBreakpoints.tablet;
  bool get isDesktop => screenWidth >= AppBreakpoints.desktop;
  bool get isMobile => screenWidth < AppBreakpoints.tablet;

  /// عدد أعمدة Grid المناسب لحجم الشاشة
  int get responsiveGridCount {
    if (isDesktop) return 4;
    if (isTablet) return 3;
    return 2;
  }

  /// الحد الأقصى لعرض المحتوى
  double get responsiveMaxWidth {
    if (isDesktop) return 900;
    if (isTablet) return 800;
    return double.infinity;
  }

  /// الحد الأقصى لعرض النماذج (forms)
  double get responsiveFormMaxWidth {
    if (isDesktop) return 700;
    if (isTablet) return 600;
    return double.infinity;
  }

  /// padding الشاشة المناسب
  EdgeInsets get responsiveScreenPadding {
    if (isTablet) return const EdgeInsets.all(32);
    return const EdgeInsets.all(20);
  }
}
