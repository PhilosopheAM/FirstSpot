// Last Updated: 2026-04-21
// 最后更新: 2026-04-21
//
// Module: Onboarding Welcome Step
// 模块: 首开引导 - 欢迎步骤
//
// Dependencies: flutter/material.dart, bouncy_button
//
// Author: Harry Chen (Modified by AI)
// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';
import 'bouncy_button.dart';

class OnboardingWelcomeStep extends StatefulWidget {
  const OnboardingWelcomeStep({
    super.key,
    required this.onNext,
    required this.onSkip,
  });

  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  State<OnboardingWelcomeStep> createState() => _OnboardingWelcomeStepState();
}

class _OnboardingWelcomeStepState extends State<OnboardingWelcomeStep>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: widget.onSkip,
                child: const Text(
                  '稍后再说',
                  style: TextStyle(
                    color: Color(0xFF8A959E),
                    fontSize: 16, // slightly bigger and bolder
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 24),
                    Center(
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 148,
                          height: 148,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(
                                0xFF1FA95B,
                              ).withValues(alpha: 0.2),
                              width: 8,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.monetization_on_rounded,
                              size: 92,
                              color: Color(0xFF1FA95B),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 56),
                    const Text(
                      '为年轻人攒下\n第一桶金',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36, // Bigger for impact
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF162025),
                        height: 1.3,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '不荐股、不加杠杆，\n只陪你一起学会看懂钱的游戏规则。',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: Color(0xFF5D696F),
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: BouncyButton(
                      onPressed: widget.onNext,
                      child: const Text(
                        '进入新手村',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '后续可以随时在设置里退出新手村模式',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFB0B9C0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
