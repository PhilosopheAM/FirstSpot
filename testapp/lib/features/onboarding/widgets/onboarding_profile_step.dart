/// Last Updated: 2026-04-10
/// 最后更新: 2026-04-10
///
/// Module: Onboarding Profile Lite Step
/// 模块: 首开引导 - 轻量画像收集步骤
///
/// Dependencies: flutter/material.dart, onboarding_models
/// 依赖: flutter/material.dart, onboarding_models
///
/// Author: Harry Chen
/// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

import '../domain/onboarding_models.dart';

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
  State<OnboardingProfileLiteStep> createState() => _OnboardingProfileLiteStepState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAF8),
        elevation: 0,
        automaticallyImplyLeading: false, // 依赖父级PageView管控后退
        title: const Text(
          '步骤 1/3',
          style: TextStyle(
            color: Color(0xFF8A959E),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 16),
                    const Text(
                      '先聊聊你的第一桶金，从哪来？',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF162025),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Q1: 身份
                    const Text(
                      '你现在主要的身份是？',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF162025),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: UserIdentityType.values.map((UserIdentityType type) {
                        final bool isSelected = widget.answers.identity == type;
                        return ChoiceChip(
                          label: Text(type.label),
                          selected: isSelected,
                          onSelected: (_) => _updateIdentity(type),
                          selectedColor: const Color(0xFFE8F5E9),
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? const Color(0xFF1FA95B) : const Color(0xFF5D696F),
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? const Color(0xFF1FA95B) : const Color(0xFFE5E9EC),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),

                    // Q2: 攒钱
                    const Text(
                      '大概每月能攒下多少钱？',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF162025),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '不用太精确，一个大概范围就好。',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8A959E),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: SavingsRange.values.map((SavingsRange range) {
                        final bool isSelected = widget.answers.savings == range;
                        return ChoiceChip(
                          label: Text(range.label),
                          selected: isSelected,
                          onSelected: (_) => _updateSavings(range),
                          selectedColor: const Color(0xFFE8F5E9),
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? const Color(0xFF1FA95B) : const Color(0xFF5D696F),
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? const Color(0xFF1FA95B) : const Color(0xFFE5E9EC),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),

                    // Q3: 波动
                    const Text(
                      '看到账户有涨有跌时，你更像是哪种？',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF162025),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...VolatilityFeeling.values.map((VolatilityFeeling feeling) {
                      final bool isSelected = widget.answers.volatility == feeling;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () => _updateVolatility(feeling),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF1FA95B) : const Color(0xFFE5E9EC),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  feeling.emoji,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    feeling.label,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      color: isSelected ? const Color(0xFF162025) : const Color(0xFF5D696F),
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF1FA95B),
                                    size: 20,
                                  )
                                else
                                  const SizedBox(width: 20),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 80), // 为底部反馈留出空间
                  ],
                ),
              ),
            ),
            
            // 底部反馈与按钮区
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 20,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  if (_currentFeedback != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 18,
                            color: Color(0xFF1FA95B),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _currentFeedback!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1FA95B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: widget.answers.isComplete ? widget.onNext : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF1FA95B),
                        disabledBackgroundColor: const Color(0xFFE5E9EC),
                        disabledForegroundColor: const Color(0xFF8A959E),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        widget.answers.isComplete ? '下一步：看看投资到底在干嘛' : '请先回答完上面的问题',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
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
