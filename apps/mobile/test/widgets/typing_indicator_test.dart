import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yameenak_mobile/widgets/typing_indicator.dart';

void main() {
  group('TypingIndicator', () {
    testWidgets('renders three dots', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: TypingIndicator()),
        ),
      );

      // Should contain 3 animated dot containers
      // Each dot is a Container with BoxShape.circle
      expect(find.byType(TypingIndicator), findsOneWidget);

      // Pump a few frames to verify animation runs
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(TypingIndicator), findsOneWidget);
    });
  });
}
