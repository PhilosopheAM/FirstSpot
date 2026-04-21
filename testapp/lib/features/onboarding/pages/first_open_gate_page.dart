/// Last Updated: 2026-04-10
/// 最后更新: 2026-04-10
///
/// Module: First open gate page - unified entry for routing
/// 模块: 首开判断分流页 - 统一的路由入口
///
/// Dependencies: flutter/material.dart, onboarding_preferences_service, onboarding_flow_page, home_dashboard_page
/// 依赖: flutter/material.dart, onboarding_preferences_service, onboarding_flow_page, home_dashboard_page
///
/// Author: Harry Chen
/// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

import '../data/onboarding_preferences_service.dart';
import 'home_dashboard_page.dart';
import 'onboarding_flow_page.dart';

class FirstOpenGatePage extends StatefulWidget {
  const FirstOpenGatePage({super.key});

  @override
  State<FirstOpenGatePage> createState() => _FirstOpenGatePageState();
}

class _FirstOpenGatePageState extends State<FirstOpenGatePage> {
  final OnboardingPreferencesService _prefsService = OnboardingPreferencesService();
  bool _isLoading = true;
  bool _shouldShowOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final bool shouldShow = await _prefsService.shouldShowOnboarding();
    if (mounted) {
      setState(() {
        _shouldShowOnboarding = shouldShow;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 异步加载时的极简 Loading / Splash 态
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7FAF8),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF1FA95B),
          ),
        ),
      );
    }

    if (_shouldShowOnboarding) {
      return const OnboardingFlowPage();
    } else {
      return const HomeDashboardPage();
    }
  }
}
