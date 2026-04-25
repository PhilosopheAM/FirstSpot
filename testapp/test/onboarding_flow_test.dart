import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:testapp/features/onboarding/domain/onboarding_models.dart';
import 'package:testapp/features/onboarding/pages/first_open_gate_page.dart';
import 'package:testapp/features/onboarding/pages/home_dashboard_page.dart';
import 'package:testapp/features/onboarding/pages/onboarding_flow_page.dart';
import 'package:testapp/features/onboarding/widgets/onboarding_profile_step.dart';
import 'package:testapp/features/onboarding/widgets/onboarding_welcome_step.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  Widget createTestApp(Widget child) {
    return MaterialApp(home: child);
  }

  group('FirstOpenGatePage Tests', () {
    testWidgets('Should route to OnboardingFlowPage on first launch', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp(const FirstOpenGatePage()));
      await tester.pump();

      expect(find.byType(OnboardingFlowPage), findsOneWidget);
      expect(find.byType(OnboardingWelcomeStep), findsOneWidget);
    });

    testWidgets('Should route to HomeDashboardPage if onboarding completed', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'hasCompletedOnboarding': true,
      });

      await tester.pumpWidget(createTestApp(const FirstOpenGatePage()));
      await tester.pump();

      expect(find.byType(HomeDashboardPage), findsOneWidget);
    });

    testWidgets('Should route to HomeDashboardPage if onboarding skipped', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'hasSkippedOnboarding': true,
      });

      await tester.pumpWidget(createTestApp(const FirstOpenGatePage()));
      await tester.pump();

      expect(find.byType(HomeDashboardPage), findsOneWidget);
    });
  });

  group('Onboarding Flow Navigation Tests', () {
    testWidgets('Can skip onboarding from welcome step', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp(const OnboardingFlowPage()));
      await tester.pump();

      final Finder skipButton = find.text('稍后再说');
      expect(skipButton, findsOneWidget);

      await tester.tap(skipButton);
      await tester.pump(const Duration(milliseconds: 120));
      expect(find.text('要跳过新手引导吗？'), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, '跳过'));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(HomeDashboardPage), findsOneWidget);
    });

    testWidgets(
      'ProfileStep advances through current chat flow before enabling next',
      (WidgetTester tester) async {
        final OnboardingProfileAnswers answers = OnboardingProfileAnswers();

        await tester.pumpWidget(
          createTestApp(
            OnboardingProfileLiteStep(
              answers: answers,
              onAnswersChanged: (_) {},
              onNext: () {},
            ),
          ),
        );
        await tester.pump();

        expect(find.text('先认识一下！你现在主要在做什么？'), findsOneWidget);
        expect(find.text('请先回答完上面的问题'), findsOneWidget);

        await tester.tap(find.text('在校学生'));
        await tester.pump(const Duration(milliseconds: 700));

        expect(find.text('好的，那你大概每个月能攒下多少？不用精确～'), findsOneWidget);

        await tester.tap(find.text('<500'));
        await tester.pump(const Duration(milliseconds: 700));

        expect(find.text('看到账户有涨有跌时，你更像哪一种？'), findsOneWidget);

        await tester.scrollUntilVisible(find.textContaining('一点点亏'), 120);
        await tester.tap(find.textContaining('一点点亏'));
        await tester.pump(const Duration(milliseconds: 700));

        expect(find.text('下一步：看看投资到底在干嘛'), findsOneWidget);
      },
    );
  });
}
