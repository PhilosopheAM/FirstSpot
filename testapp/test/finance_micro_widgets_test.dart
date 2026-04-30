import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testapp/features/finance_micro_widgets/widgets/compound_daily_gain_widget.dart';

void main() {
  testWidgets(
    'compound principal manual input closes without controller error',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: CompoundDailyGainWidget()),
          ),
        ),
      );

      await tester.tap(find.text('本金 Principal'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '20000');
      await tester.tap(find.widgetWithText(FilledButton, '确认'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('¥2.0万'), findsWidgets);
    },
  );
}
