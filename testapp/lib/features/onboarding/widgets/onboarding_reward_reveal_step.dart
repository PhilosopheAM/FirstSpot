/// Last Updated: 2026-04-21
/// 最后更新: 2026-04-21
///
/// Module: Onboarding Reward Reveal Step (Step 05)
/// 模块: 首开引导 - 奖励揭示与概念卡收下仪式
///
/// Dependencies: flutter/material.dart
///
/// Author: AI
/// Email: 11911421@mail.sustech.edu.cn

import 'dart:math' as math;
import 'package:flutter/material.dart';

class OnboardingRewardRevealStep extends StatefulWidget {
  const OnboardingRewardRevealStep({
    super.key,
    required this.onComplete,
  });

  final VoidCallback onComplete;

  @override
  State<OnboardingRewardRevealStep> createState() =>
      _OnboardingRewardRevealStepState();
}

class _OnboardingRewardRevealStepState extends State<OnboardingRewardRevealStep>
    with TickerProviderStateMixin {
  bool _isCardFlipped = false;
  bool _canCollectCard = false;
  bool _isCardCollected = false;
  
  late final AnimationController _cardRiseController;
  late final AnimationController _cardFloatController;
  late final Animation<Offset> _cardRiseAnimation;

  @override
  void initState() {
    super.initState();
    _cardRiseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _cardFloatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _cardRiseAnimation = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardRiseController,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void dispose() {
    _cardRiseController.dispose();
    _cardFloatController.dispose();
    super.dispose();
  }

  void _handleCardTap() {
    if (!_isCardFlipped) {
      setState(() {
        _isCardFlipped = true;
        _canCollectCard = false;
      });
      // TODO: 播放 assets/audio/card_flip.wav
      Future.delayed(const Duration(milliseconds: 650), () {
        if (mounted && _isCardFlipped && !_isCardCollected) {
          setState(() {
            _canCollectCard = true;
          });
        }
      });
    } else if (_canCollectCard && !_isCardCollected) {
      setState(() {
        _isCardCollected = true;
      });
      // TODO: 播放 assets/audio/card_unlock_gentle.wav
      Future.delayed(const Duration(milliseconds: 520), () {
        if (mounted) {
          widget.onComplete();
        }
      });
    }
  }

  Widget _buildCardFront() {
    return Container(
      width: 240,
      height: 340,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E8EC), width: 4),
      ),
      child: Column(
        children: [
          const Text('CARD-01', style: TextStyle(color: Color(0xFFB0B9C0))),
          const Spacer(),
          const Text('🏢', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 24),
          const Text(
            '市场门口的第一步',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1F2328),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '白卡 (Common)',
            style: TextStyle(color: Color(0xFF8A948E)),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      width: 240,
      height: 340,
      decoration: BoxDecoration(
        color: const Color(0xFF1F2328),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4CC38A), width: 4),
      ),
      child: const Center(
        child: Text('?', style: TextStyle(fontSize: 60, color: Color(0xFF4CC38A))),
      ),
    );
  }

  Widget _buildPhase1() {
    return GestureDetector(
      onTap: _handleCardTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        color: Colors.black87,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _cardRiseAnimation,
              child: AnimatedBuilder(
                animation: _cardFloatController,
                builder: (BuildContext context, Widget? child) {
                  final double floatDy = _isCardFlipped && !_isCardCollected
                      ? math.sin(_cardFloatController.value * math.pi * 2) * 7
                      : 0;
                  return Transform.translate(
                    offset: Offset(0, floatDy),
                    child: child,
                  );
                },
                child: AnimatedScale(
                  scale: _isCardCollected ? 0.72 : 1,
                  duration: const Duration(milliseconds: 420),
                  curve: Curves.easeInBack,
                  child: AnimatedOpacity(
                    opacity: _isCardCollected ? 0 : 1,
                    duration: const Duration(milliseconds: 420),
                    curve: Curves.easeOut,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0,
                        end: _isCardFlipped ? math.pi : 0,
                      ),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOutCubic,
                      builder: (BuildContext context, double angle, Widget? child) {
                        final bool showRevealedCard = angle > math.pi / 2;
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.0014)
                            ..rotateY(angle),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(showRevealedCard ? math.pi : 0),
                            child: showRevealedCard ? _buildCardFront() : _buildCardBack(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              _isCardFlipped ? '你获得了第一张概念卡\n点击屏幕收下卡片' : '点击翻转卡片',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPhase1(),
    );
  }
}
