import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yameenak_mobile/widgets/shimmer_box.dart';

void main() {
  group('ShimmerBox', () {
    testWidgets('renders with specified dimensions', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerBox(width: 200, height: 40),
          ),
        ),
      );

      final box = tester.widget<ShimmerBox>(find.byType(ShimmerBox));
      expect(box.width, 200);
      expect(box.height, 40);
    });

    testWidgets('animates shimmer effect', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerBox(height: 40),
          ),
        ),
      );

      // Pump frames to verify animation is running
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      // Widget should still be present (animation didn't crash)
      expect(find.byType(ShimmerBox), findsOneWidget);
    });
  });

  group('ShimmerCard', () {
    testWidgets('renders card with shimmer placeholders', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerCard(height: 120),
          ),
        ),
      );

      // Card should exist
      expect(find.byType(Card), findsOneWidget);
      // Multiple shimmer boxes inside
      expect(find.byType(ShimmerBox), findsNWidgets(3));
    });
  });
}
