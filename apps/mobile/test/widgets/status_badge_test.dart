import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yameenak_mobile/widgets/status_badge.dart';

void main() {
  group('StatusBadge', () {
    Widget buildBadge(HealthStatus status) {
      return MaterialApp(
        home: Scaffold(body: StatusBadge(status: status)),
      );
    }

    testWidgets('shows "طبيعي" for normal status', (tester) async {
      await tester.pumpWidget(buildBadge(HealthStatus.normal));
      expect(find.text('طبيعي'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('shows "يحتاج متابعة" for needsAttention status',
        (tester) async {
      await tester.pumpWidget(buildBadge(HealthStatus.needsAttention));
      expect(find.text('يحتاج متابعة'), findsOneWidget);
      expect(find.byIcon(Icons.warning_rounded), findsOneWidget);
    });

    testWidgets('shows "تنبيه" for critical status', (tester) async {
      await tester.pumpWidget(buildBadge(HealthStatus.alert));
      expect(find.text('تنبيه'), findsOneWidget);
      expect(find.byIcon(Icons.error_rounded), findsOneWidget);
    });
  });
}
