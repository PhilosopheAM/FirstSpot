/// Last Updated: 2026-04-10
/// 最后更新: 2026-04-10
///
/// Module: Onboarding Flow Page - the container for all steps
/// 模块: 首开引导流程页 - 串联所有步骤的容器
///
/// Dependencies: flutter/material.dart, all onboarding steps, onboarding_preferences_service
/// 依赖: flutter/material.dart, onboarding_welcome_step, onboarding_profile_step, onboarding_lesson_step, onboarding_starter_plan_step, onboarding_preferences_service
///
/// Author: Harry Chen
/// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

import '../data/onboarding_preferences_service.dart';
import '../domain/onboarding_models.dart';
import 'home_dashboard_page.dart';
import '../widgets/onboarding_lesson_step.dart';
import '../widgets/onboarding_profile_step.dart';
import '../widgets/onboarding_starter_plan_step.dart';
import '../widgets/onboarding_welcome_step.dart';

class OnboardingFlowPage extends StatefulWidget {
  const OnboardingFlowPage({super.key});

  @override
  State<OnboardingFlowPage> createState() => _OnboardingFlowPageState();
}

class _OnboardingFlowPageState extends State<OnboardingFlowPage> {
  final PageController _pageController = PageController();
  final OnboardingPreferencesService _prefsService = OnboardingPreferencesService();
  final OnboardingProfileAnswers _answers = OnboardingProfileAnswers();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _completeOnboarding() async {
    await _prefsService.markOnboardingCompleted();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomeDashboardPage()),
      );
    }
  }

  Future<void> _skipOnboarding() async {
    await _prefsService.markOnboardingSkipped();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomeDashboardPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 使用 PageView 包装所有步骤，禁止手势滑动，只能通过按钮驱动
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          OnboardingWelcomeStep(
            onNext: _nextPage,
            onSkip: _skipOnboarding,
          ),
          OnboardingProfileLiteStep(
            answers: _answers,
            onAnswersChanged: (OnboardingProfileAnswers newAnswers) {
              // _answers 已经在子组件被修改，这里只需要触发自身（或子组件自身）的 rebuild
            },
            onNext: _nextPage,
          ),
          OnboardingMiniLessonStep(
            onNext: _nextPage,
          ),
          OnboardingStarterPlanStep(
            answers: _answers,
            onComplete: _completeOnboarding,
          ),
        ],
      ),
    );
  }
}
