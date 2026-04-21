/// Last Updated: 2026-04-21
/// 最后更新: 2026-04-21
///
/// Module: Onboarding Profile Lite Step
/// 模块: 首开引导 - 轻量画像收集步骤
///
/// Dependencies: flutter/material.dart, onboarding_models, bouncy_button
///
/// Author: Harry Chen (Modified by AI)
/// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

import '../domain/onboarding_models.dart';
import 'bouncy_button.dart';

class OnboardingProfileLiteStep extends StatefulWidget {
  const OnboardingProfileLiteStep({
    super.key,
    required this.answers,
    required this.onNext,
    required this.onAnswersChanged,
  });

  final OnboardingProfileAnswers answers;
  final VoidCallback onNext;
  final ValueChanged<OnboardingProfileAnswers> onAnswersChanged;

  @override
  State<OnboardingProfileLiteStep> createState() =>
      _OnboardingProfileLiteStepState();
}

class _OnboardingProfileLiteStepState extends State<OnboardingProfileLiteStep> {
  String? _currentFeedback;

  void _updateIdentity(UserIdentityType? type) {
    if (type == null) return;
    setState(() {
      _currentFeedback = type.feedback;
    });
    widget.answers.identity = type;
    widget.onAnswersChanged(widget.answers);
  }

  void _updateSavings(SavingsRange? range) {
    if (range == null) return;
    setState(() {
      _currentFeedback = range.feedback;
    });
    widget.answers.savings = range;
    widget.onAnswersChanged(widget.answers);
  }

  void _updateVolatility(VolatilityFeeling? feeling) {
    if (feeling == null) return;
    setState(() {
      _currentFeedback = feeling.feedback;
    });
    widget.answers.volatility = feeling;
    widget.onAnswersChanged(widget.answers);
  }

  Widget _buildGamifiedOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1FA95B) : const Color(0xFFE5E9EC),
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            if (!isSelected)
              const BoxShadow(
                color: Color(0xFFE5E9EC),
                offset: Offset(0, 3),
              ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? const Color(0xFF1FA95B) : const Color(0xFF5D696F),
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAF8),
        elevation: 0,
        automaticallyImplyLeading: false, // 依赖父级PageView管控后退
        title: const Text(
          '1 / 3',
          style: TextStyle(
            color: Color(0xFFB0B9C0), // Softer color for Gamified feel
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // A Duolingo-like segmented progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: List.generate(3, (index) {
                  final isFilled = index < 1;
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 12,
                      decoration: BoxDecoration(
                        color: isFilled
                            ? const Color(0xFF1FA95B)
                            : const Color(0xFFE5E9EC),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 24),
                    const Text(
                      '先聊聊你的第一桶金，从哪来？',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF162025),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Q1: 身份
                    const Text(
                      '你现在主要的身份是？',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF162025),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: UserIdentityType.values.map((UserIdentityType type) {
                        final bool isSelected = widget.answers.identity == type;
                        return _buildGamifiedOption(
                          label: type.label,
                          isSelected: isSelected,
                          onTap: () => _updateIdentity(type),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 40),

                    // Q2: 攒钱
                    const Text(
                      '大概每月能攒下多少钱？',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF162025),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '不用太精确，一个大概范围就好。',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8A959E),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: SavingsRange.values.map((SavingsRange range) {
                        final bool isSelected = widget.answers.savings == range;
                        return _buildGamifiedOption(
                          label: range.label,
                          isSelected: isSelected,
                          onTap: () => _updateSavings(range),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 40),

                    // Q3: 波动
                    const Text(
                      '看到账户有涨有跌时，你更像是哪种？',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF162025),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...VolatilityFeeling.values.map((VolatilityFeeling feeling) {
                      final bool isSelected = widget.answers.volatility == feeling;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => _updateVolatility(feeling),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFE8F5E9)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF1FA95B)
                                    : const Color(0xFFE5E9EC),
                                width: isSelected ? 3 : 2,
                              ),
                              boxShadow: [
                                if (!isSelected)
                                  const BoxShadow(
                                    color: Color(0xFFE5E9EC),
                                    offset: Offset(0, 4),
                                  ),
                              ],
                            ),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  feeling.emoji,
                                  style: const TextStyle(fontSize: 28),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    feeling.label,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected
                                          ? FontWeight.w800
                                          : FontWeight.w700,
                                      color: isSelected
                                          ? const Color(0xFF1FA95B)
                                          : const Color(0xFF5D696F),
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF1FA95B),
                                    size: 24,
                                  )
                                else
                                  const SizedBox(width: 24),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 60), // 为底部反馈留出空间
                  ],
                ),
              ),
            ),
            
            // 底部反馈与按钮区
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE5E9EC),
                    width: 2,
                  ),
                ),
              ),
              child: Column(
                children: <Widget>[
                  if (_currentFeedback != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: Icon(
                              Icons.tips_and_updates_rounded,
                              size: 22,
                              color: Color(0xFF1FA95B),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _currentFeedback!,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF1FA95B),
                                fontWeight: FontWeight.w800,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: BouncyButton(
                      onPressed: widget.answers.isComplete ? widget.onNext : null,
                      child: Text(
                        widget.answers.isComplete ? '下一步：看看投资到底在干嘛' : '请先回答完上面的问题',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: widget.answers.isComplete
                              ? Colors.white
                              : const Color(0xFF8A959E),
                        ),
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
