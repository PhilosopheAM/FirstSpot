import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:testapp/features/onboarding/domain/onboarding_models.dart';
import 'package:testapp/features/onboarding/pages/first_open_gate_page.dart';
import 'package:testapp/features/onboarding/pages/home_dashboard_page.dart';
import 'package:testapp/features/onboarding/pages/onboarding_flow_page.dart';
import 'package:testapp/features/onboarding/widgets/onboarding_profile_step.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createTestApp(Widget child) {
    return MaterialApp(home: child);
  }

  Future<void> finishLaunchAnimation(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 2300));
    await tester.pump();
  }

  group('FirstOpenGatePage Tests', () {
    testWidgets('Should route to OnboardingFlowPage on first launch', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp(const FirstOpenGatePage()));
      await finishLaunchAnimation(tester);

      expect(find.byType(OnboardingFlowPage), findsOneWidget);
      expect(find.text('进入新手村'), findsOneWidget);
    });

    testWidgets('Should route to HomeDashboardPage if onboarding completed', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({'hasCompletedOnboarding': true});

      await tester.pumpWidget(createTestApp(const FirstOpenGatePage()));
      await finishLaunchAnimation(tester);

      expect(find.byType(HomeDashboardPage), findsOneWidget);
      expect(find.text('我的小金库'), findsOneWidget);
    });

    testWidgets('Should route to HomeDashboardPage if onboarding skipped', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({'hasSkippedOnboarding': true});

      await tester.pumpWidget(createTestApp(const FirstOpenGatePage()));
      await finishLaunchAnimation(tester);

      expect(find.byType(HomeDashboardPage), findsOneWidget);
      expect(find.text('我的小金库'), findsOneWidget);
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
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();

      expect(find.byType(HomeDashboardPage), findsOneWidget);
    });

    testWidgets(
      'Next button is disabled in ProfileStep until all questions answered',
      (WidgetTester tester) async {
        final answers = OnboardingProfileAnswers();

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

        expect(find.text('1 / 3'), findsOneWidget);
        expect(find.text('请先回答完上面的问题'), findsOneWidget);

        await tester.tap(find.text('在校学生').first);
        await tester.pump();
        await tester.tap(find.text('<200').first);
        await tester.pump();
        expect(find.text('请先回答完上面的问题'), findsOneWidget);

        final Finder volatilityOption = find.text('小起伏还能接受').first;
        await tester.ensureVisible(volatilityOption);
        await tester.pump();
        await tester.tap(volatilityOption);
        await tester.pump();

        expect(find.text('下一步：看看投资到底在干嘛'), findsOneWidget);
      },
    );
  });
}
