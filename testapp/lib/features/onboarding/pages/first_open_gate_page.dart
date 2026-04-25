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
  final OnboardingPreferencesService _prefsService =
      OnboardingPreferencesService();

  bool _isLoading = true;
  bool _shouldShowOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final bool shouldShow = await _prefsService.shouldShowOnboarding();
    if (!mounted) {
      return;
    }

    setState(() {
      _shouldShowOnboarding = shouldShow;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7FAF8),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF1FA95B)),
        ),
      );
    }

    if (_shouldShowOnboarding) {
      return const OnboardingFlowPage();
    }

    return const HomeDashboardPage();
  }
}
