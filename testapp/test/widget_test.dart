// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testapp/main.dart';

void main() {
  testWidgets('Hola page day/night toggle', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // 初始：白底黑字，显示 Hola!
    final Scaffold initialScaffold =
        tester.widget<Scaffold>(find.byType(Scaffold));
    expect(initialScaffold.backgroundColor, Colors.white);
    expect(find.text('Hola!'), findsOneWidget);

    // 点击 Day，变为黑底白字
    await tester.tap(find.text('Day'));
    await tester.pump();
    final Scaffold dayScaffold =
        tester.widget<Scaffold>(find.byType(Scaffold));
    expect(dayScaffold.backgroundColor, Colors.black);

    // 再点击 Night，恢复白底黑字
    await tester.tap(find.text('Night'));
    await tester.pump();
    final Scaffold nightScaffold =
        tester.widget<Scaffold>(find.byType(Scaffold));
    expect(nightScaffold.backgroundColor, Colors.white);
  });
}
