/// Last Updated: 2026-04-10
/// 最后更新: 2026-04-10
///
/// Module: Onboarding Starter Plan Step
/// 模块: 首开引导 - 起步计划步骤
///
/// Dependencies: flutter/material.dart, onboarding_models
/// 依赖: flutter/material.dart, onboarding_models
///
/// Author: Harry Chen
/// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

import '../domain/onboarding_models.dart';

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
          '步骤 3/3',
          style: TextStyle(
            color: Color(0xFF8A959E),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 16),
              const Text(
                '为你定制的起步计划',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF162025),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '不用着急，你可以按自己的节奏慢慢来。',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF5D696F),
                ),
              ),
              const SizedBox(height: 32),
              
              // 计划卡片
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFF1FA95B), width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '首月目标',
                            style: TextStyle(
                              color: Color(0xFF1FA95B),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _getPlanTitle(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF162025),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _getPlanAction(),
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Color(0xFF5D696F),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7FAF8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const <Widget>[
                          Icon(Icons.shield_outlined, size: 20, color: Color(0xFF1FA95B)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '第一条规则：不要亏掉你的本金',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1FA95B),
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
              
              // 按钮
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onComplete,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1FA95B),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '进入首页，查看今日新手任务',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
