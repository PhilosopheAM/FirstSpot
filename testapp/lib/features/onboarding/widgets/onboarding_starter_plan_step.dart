/// Last Updated: 2026-04-21
/// 最后更新: 2026-04-21
///
/// Module: Onboarding Starter Plan Step (Step 04)
/// 模块: 首开引导 - 起步计划步骤 (3D卡片生成)
///
/// Dependencies: flutter/material.dart, onboarding_models, bouncy_button
///
/// Author: AI
/// Email: 11911421@mail.sustech.edu.cn

import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../domain/onboarding_models.dart';
import 'bouncy_button.dart';
import 'xp_flyup.dart';

class OnboardingStarterPlanStep extends StatefulWidget {
  const OnboardingStarterPlanStep({
    super.key,
    required this.answers,
    required this.onComplete,
  });

  final OnboardingProfileAnswers answers;
  final VoidCallback onComplete;

  @override
  State<OnboardingStarterPlanStep> createState() =>
      _OnboardingStarterPlanStepState();
}

class _OnboardingStarterPlanStepState extends State<OnboardingStarterPlanStep>
    with SingleTickerProviderStateMixin {
  bool _isFlipped = false;
  bool _isSaved = false;
  late final AnimationController _generateController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _generateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();
    // 播放 assets/audio/card_assemble.mp3
    _audioPlayer.play(AssetSource('audio/card_assemble.mp3'));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _generateController.dispose();
    super.dispose();
  }

  String _getRecommendedAmount() {
    switch (widget.answers.savings) {
      case SavingsRange.lessThan500:
        return '¥ 100';
      case SavingsRange.between500And2000:
        return '¥ 300';
      case SavingsRange.between2000And5000:
        return '¥ 1000';
      case SavingsRange.moreThan5000:
        return '¥ 2000';
      case null:
        return '¥ 300';
    }
  }

  String _getRiskLevel() {
    switch (widget.answers.volatility) {
      case VolatilityFeeling.scared:
        return '☀️☁️☁️ (极度保守)';
      case VolatilityFeeling.acceptSmall:
        return '☀️☀️☁️ (稳健为主)';
      case VolatilityFeeling.acceptLarge:
        return '☀️☀️☀️ (平衡配置)';
      case null:
        return '☀️☀️☁️';
    }
  }

  void _handleSave() {
    setState(() {
      _isSaved = true;
    });
    // 播放 assets/audio/save_coin.wav
    _audioPlayer.play(AssetSource('audio/save_coin.wav'));
    // TODO: 触发触感 success
    showXpFlyup(context, 20);
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  Widget _buildCardFront() {
    return Container(
      width: 280,
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF9F0), Color(0xFFE8F5E9)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF4CC38A), width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 10),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🎓', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                '为 [${widget.answers.identity?.label ?? '你'}] 的\n第一桶金计划',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F2328),
                ),
              ),
            ],
          ),
          const Spacer(),
          const Text(
            '建议每月投入',
            style: TextStyle(fontSize: 14, color: Color(0xFF5B5B5B)),
          ),
          AnimatedBuilder(
            animation: _generateController,
            builder: (context, child) {
              return Opacity(
                opacity: _generateController.value,
                child: Text(
                  _getRecommendedAmount(),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF4CC38A),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            '建议工具',
            style: TextStyle(fontSize: 14, color: Color(0xFF5B5B5B)),
          ),
          const Text(
            '宽基 ETF 定投',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2328),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '风险等级',
            style: TextStyle(fontSize: 14, color: Color(0xFF5B5B5B)),
          ),
          Text(
            _getRiskLevel(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFFFFB547),
            ),
          ),
          const Spacer(),
          const Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '2026-04-21',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFB0B9C0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      width: 280,
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2328),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF4CC38A), width: 3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            '为什么这样推荐？',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 24),
          Text(
            '根据你的储蓄情况，我们只建议拿出 30% 作为投资本金。宽基 ETF 能帮你分散风险，适合不想盯盘的你。慢慢来，比较快。',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFFB0B9C0),
            ),
          ),
          SizedBox(height: 40),
          Text(
            '— Myo 🐾',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF4CC38A),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              '根据你的回答，我们做了这个',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1F2328),
              ),
            ),
            const Spacer(),
            
            // 3D Card
            GestureDetector(
              onTap: () {
                setState(() {
                  _isFlipped = !_isFlipped;
                });
                // 播放 assets/audio/card_flip.wav
                _audioPlayer.play(AssetSource('audio/card_flip.wav'));
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOutBack,
                transform: Matrix4.translationValues(
                  _isSaved ? 200 : 0,
                  _isSaved ? -400 : 0,
                  0,
                )..scale(_isSaved ? 0.2 : 1.0),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: 0,
                    end: _isFlipped ? math.pi : 0,
                  ),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOutCubic,
                  builder: (BuildContext context, double angle, Widget? child) {
                    final bool showBack = angle > math.pi / 2;
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.0014)
                        ..rotateY(angle),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(showBack ? math.pi : 0),
                        child: showBack ? _buildCardBack() : _buildCardFront(),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            const Spacer(),
            
            // 底部按钮区
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: BouncyButton(
                      onPressed: _isSaved ? null : _handleSave,
                      color: const Color(0xFF4CC38A),
                      shadowColor: const Color(0xFF3BA06E),
                      borderRadius: 28,
                      child: const Text(
                        '存进小金库',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      _generateController.reset();
                      _generateController.forward();
                    },
                    child: const Text(
                      '再看一次',
                      style: TextStyle(
                        color: Color(0xFF8A948E),
                        fontWeight: FontWeight.w600,
                      ),
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
