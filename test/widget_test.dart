import 'package:flutter_test/flutter_test.dart';

import 'package:calculator/main.dart';

void main() {
  testWidgets('Calculator loads and renders the display', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    // The initial display shows 0.
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Typing 7 + 3 = shows 10', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tester.tap(find.text('7'));
    await tester.tap(find.text('+'));
    await tester.tap(find.text('3'));
    await tester.tap(find.text('='));
    await tester.pump();

    expect(find.text('10'), findsOneWidget);
  });
}
