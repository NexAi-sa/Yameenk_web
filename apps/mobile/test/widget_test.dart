import 'package:flutter_test/flutter_test.dart';
import 'package:yameenak_mobile/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const YameenakApp());
    expect(find.text('يمينك'), findsWidgets);
  });
}
