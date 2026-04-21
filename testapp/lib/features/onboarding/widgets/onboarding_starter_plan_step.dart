/// Last Updated: 2026-04-21
/// 最后更新: 2026-04-21
///
/// Module: Onboarding Starter Plan Step
/// 模块: 首开引导 - 起步计划步骤
///
/// Dependencies: flutter/material.dart, onboarding_models, bouncy_button
///
/// Author: Harry Chen (Modified by AI)
/// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

import '../domain/onboarding_models.dart';
import 'bouncy_button.dart';

class OnboardingStarterPlanStep extends StatelessWidget {
  const OnboardingStarterPlanStep({
    super.key,
    required this.answers,
    required this.onComplete,
  });

  final OnboardingProfileAnswers answers;
  final VoidCallback onComplete;

  String _getPlanTitle() {
    switch (answers.savings) {
      case SavingsRange.lessThan200:
      case SavingsRange.between200And500:
        return '微小但确定的开始';
      case SavingsRange.between500And1000:
      case SavingsRange.moreThan1000:
        return '稳健的资产配置起步';
      case null:
        return '你的专属起步计划';
    }
  }

  String _getPlanAction() {
    switch (answers.volatility) {
      case VolatilityFeeling.scared:
        return '建议从保本的固定收益类资产开始，先体会每月都有利息的安心感。';
      case VolatilityFeeling.acceptSmall:
        return '建议 80% 放入稳健理财，20% 尝试购买宽基指数基金，感受市场的脉搏。';
      case VolatilityFeeling.acceptLarge:
        return '建议采用定投策略，每月固定买入指数基金，通过时间平摊成本。';
      case null:
        return '建立良好的储蓄和记账习惯。';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAF8),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          '3 / 3',
          style: TextStyle(
            color: Color(0xFFB0B9C0),
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
            // Progress bar (all 3 filled)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1FA95B), // all green
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 24),
                    const Text(
                      '为你定制的起步计划',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF162025),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '不用着急，你可以按自己的节奏慢慢来。',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8A959E),
                      ),
                    ),
                    const Spacer(),

                    // 计划卡片
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFFE5E9EC),
                          width: 3,
                        ),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Color(0xFFE5E9EC),
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1FA95B),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              '首月目标 🎯',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _getPlanTitle(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF162025),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _getPlanAction(),
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5D696F),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF1FA95B).withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Icon(Icons.shield_outlined,
                                    size: 24, color: Color(0xFF1FA95B)),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '第一条规则：不要亏掉你的本金。',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1FA95B),
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            
            // 底部反馈与按钮区
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE5E9EC),
                    width: 2,
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: BouncyButton(
                  onPressed: onComplete,
                  child: const Text(
                    '进入首页，查看今日新手任务',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
