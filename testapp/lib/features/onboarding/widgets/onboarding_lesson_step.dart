/// Last Updated: 2026-04-10
/// 最后更新: 2026-04-10
///
/// Module: Onboarding Mini Lesson Step
/// 模块: 首开引导 - 迷你教学步骤
///
/// Dependencies: flutter/material.dart
/// 依赖: flutter/material.dart
///
/// Author: Harry Chen
/// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

class OnboardingMiniLessonStep extends StatefulWidget {
  const OnboardingMiniLessonStep({
    super.key,
    required this.onNext,
  });

  final VoidCallback onNext;

  @override
  State<OnboardingMiniLessonStep> createState() => _OnboardingMiniLessonStepState();
}

class _OnboardingMiniLessonStepState extends State<OnboardingMiniLessonStep> {
  int _currentCardIndex = 0;

  final List<Map<String, String>> _lessons = const [
    {
      'title': '什么是本金？',
      'desc': '这是你投入的初始资金。比如你放入了 10,000 元，这就是你的本金。',
      'icon': '💰',
      'color': '0xFFE8F5E9',
    },
    {
      'title': '什么是涨跌？',
      'desc': '市场的价格每天都在变化。涨了，你的钱就变多了；跌了，你的钱就变少了。',
      'icon': '📈',
      'color': '0xFFE3F2FD',
    },
    {
      'title': '什么是盈亏？',
      'desc': '现在的钱减去本金，就是你的盈亏。\n例如：10,500(现值) - 10,000(本金) = 500元盈利。',
      'icon': '⚖️',
      'color': '0xFFFFF3E0',
    },
  ];

  void _nextCard() {
    if (_currentCardIndex < _lessons.length - 1) {
      setState(() {
        _currentCardIndex++;
      });
    } else {
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final lesson = _lessons[_currentCardIndex];
    final bool isLast = _currentCardIndex == _lessons.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAF8),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          '步骤 2/3',
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
                '投资的 3 个基础概念',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF162025),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '搞懂这些，你就比 80% 的小白强了。',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF5D696F),
                ),
              ),
              const Spacer(),
              
              // 教学卡片
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.05, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  key: ValueKey<int>(_currentCardIndex),
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 24,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Color(int.parse(lesson['color']!)),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            lesson['icon']!,
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        lesson['title']!,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF162025),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        lesson['desc']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Color(0xFF5D696F),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const Spacer(),
              
              // 进度点
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_lessons.length, (index) {
                  final bool isActive = index == _currentCardIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: isActive ? 24 : 8,
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFF1FA95B) : const Color(0xFFE5E9EC),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              
              // 按钮
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _nextCard,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1FA95B),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isLast ? '太棒了，生成我的起步计划' : '我懂了，下一个',
                    style: const TextStyle(
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
