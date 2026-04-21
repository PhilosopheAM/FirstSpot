/// Last Updated: 2026-04-10
/// 最后更新: 2026-04-10
///
/// Module: Widget tests for first open onboarding flow
/// 模块: 首开引导流程 Widget 测试
///
/// Dependencies: flutter_test, onboarding steps, first_open_gate_page
/// 依赖: flutter_test, 各首开步骤组件, first_open_gate_page
///
/// Author: Harry Chen
/// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:testapp/features/onboarding/pages/first_open_gate_page.dart';
import 'package:testapp/features/onboarding/pages/home_dashboard_page.dart';
import 'package:testapp/features/onboarding/pages/onboarding_flow_page.dart';

void main() {
  setUp(() {
    // 注入空的 SharedPreferences 以隔离每次测试
    SharedPreferences.setMockInitialValues({});
  });

  Widget createTestApp(Widget child) {
    return MaterialApp(
      home: child,
    );
  }

  group('FirstOpenGatePage Tests', () {
    testWidgets('Should route to OnboardingFlowPage on first launch', (WidgetTester tester) async {
      // 没有任何持久化数据，默认为首开
      await tester.pumpWidget(createTestApp(const FirstOpenGatePage()));
      
      // 等待异步检查完成并触发重绘
      await tester.pumpAndSettle();

      // 首开应该展示 OnboardingFlowPage，能看到第一页的按钮
      expect(find.byType(OnboardingFlowPage), findsOneWidget);
      expect(find.text('进入新手村'), findsOneWidget);
    });

    testWidgets('Should route to HomeDashboardPage if onboarding completed', (WidgetTester tester) async {
      // 模拟已经完成过引导
      SharedPreferences.setMockInitialValues({
        'hasCompletedOnboarding': true,
      });

      await tester.pumpWidget(createTestApp(const FirstOpenGatePage()));
      await tester.pumpAndSettle();

      // 应该直接跳过 onboarding，进入首页
      expect(find.byType(HomeDashboardPage), findsOneWidget);
      expect(find.text('我的小金库'), findsOneWidget);
    });

    testWidgets('Should route to HomeDashboardPage if onboarding skipped', (WidgetTester tester) async {
      // 模拟跳过了引导
      SharedPreferences.setMockInitialValues({
        'hasSkippedOnboarding': true,
      });

      await tester.pumpWidget(createTestApp(const FirstOpenGatePage()));
      await tester.pumpAndSettle();

      expect(find.byType(HomeDashboardPage), findsOneWidget);
      expect(find.text('我的小金库'), findsOneWidget);
    });
  });

  group('Onboarding Flow Navigation Tests', () {
    testWidgets('Can skip onboarding from welcome step', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const OnboardingFlowPage()));
      await tester.pumpAndSettle();

      // 找到“稍后再说”按钮并点击
      final Finder skipButton = find.text('稍后再说');
      expect(skipButton, findsOneWidget);
      await tester.tap(skipButton);
      await tester.pumpAndSettle();

      // 跳过应该立刻进入首页
      expect(find.byType(HomeDashboardPage), findsOneWidget);
    });

    testWidgets('Next button is disabled in ProfileStep until all questions answered', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const OnboardingFlowPage()));
      await tester.pumpAndSettle();

      // 点击“进入新手村”
      await tester.tap(find.text('进入新手村'));
      await tester.pumpAndSettle();

      // 进入 ProfileLiteStep
      expect(find.text('步骤 1/3'), findsOneWidget);
      
      // 刚进入时按钮应该是禁用状态文案
      expect(find.text('请先回答完上面的问题'), findsOneWidget);

      // 只选择两个，未完成时仍然禁用
      await tester.tap(find.text('在校学生').first);
      await tester.pump();
      await tester.tap(find.text('<200').first);
      await tester.pump();
      expect(find.text('请先回答完上面的问题'), findsOneWidget);

      // 选择最后一个
      await tester.tap(find.text('小起伏还能接受').first);
      await tester.pump();
      
      // 所有题目回答完后，按钮应该变成激活状态
      expect(find.text('下一步：看看投资到底在干嘛'), findsOneWidget);
    });
  });
}
