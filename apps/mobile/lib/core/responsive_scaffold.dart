/// غلاف استجابة — يحدّ عرض المحتوى تلقائياً على التابلت
library;

import 'package:flutter/material.dart';
import 'responsive_utils.dart';

/// يغلف المحتوى بـ Center + ConstrainedBox لتحديد العرض الأقصى
/// يُستخدم في body الشاشات لمنع التمدد على التابلت
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  final Widget child;

  /// الحد الأقصى للعرض. إذا لم يُحدد، يستخدم `responsiveMaxWidth`
  final double? maxWidth;

  /// padding إضافي حول المحتوى
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final effectiveMaxWidth = maxWidth ?? context.responsiveMaxWidth;

    Widget content = child;

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    // على الجوال لا نحتاج constraint — يتمدد بالكامل
    if (context.isMobile && maxWidth == null) {
      return content;
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
        child: content,
      ),
    );
  }
}

/// نسخة Sliver من ResponsiveCenter للاستخدام مع CustomScrollView
class ResponsiveSliverCenter extends StatelessWidget {
  const ResponsiveSliverCenter({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ResponsiveCenter(
        maxWidth: maxWidth,
        padding: padding,
        child: child,
      ),
    );
  }
}
