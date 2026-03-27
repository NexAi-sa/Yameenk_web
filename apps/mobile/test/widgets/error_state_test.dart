import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yameenak_mobile/widgets/error_state.dart';

void main() {
  group('ErrorStateWidget', () {
    testWidgets('shows message and icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(message: 'حدث خطأ'),
          ),
        ),
      );

      expect(find.text('حدث خطأ'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    });

    testWidgets('shows detail text when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              message: 'حدث خطأ',
              detail: 'تحقق من الاتصال',
            ),
          ),
        ),
      );

      expect(find.text('تحقق من الاتصال'), findsOneWidget);
    });

    testWidgets('hides retry button when onRetry is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(message: 'حدث خطأ'),
          ),
        ),
      );

      expect(find.byType(OutlinedButton), findsNothing);
    });

    testWidgets('shows retry button and fires callback', (tester) async {
      var retried = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              message: 'حدث خطأ',
              onRetry: () => retried = true,
            ),
          ),
        ),
      );

      expect(find.text('حاول مرة أخرى'), findsOneWidget);

      await tester.tap(find.byType(OutlinedButton));
      expect(retried, isTrue);
    });
  });
}
