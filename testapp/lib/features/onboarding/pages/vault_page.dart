// Last Updated: 2026-04-25
// 最后更新: 2026-04-25
//
// Module: Vault Page - concept card collection after onboarding
// 模块: 金库页面 - 首开后可查看已获得概念卡
//
// Dependencies: flutter/material.dart, guidance lesson data
// 依赖: flutter/material.dart, 投资者教育章节数据
//
// Author: AI
// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

import '../../learning_guidance/data/guidance_lessons.dart';
import '../../learning_guidance/domain/guidance_models.dart';

class VaultPage extends StatefulWidget {
  const VaultPage({super.key});

  @override
  State<VaultPage> createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  final PageController _pageController = PageController(viewportFraction: 0.82);

  // V1 onboarding completion grants CARD-01. Future chapter completions can
  // append to this list while keeping oldest-to-newest PageView ordering.
  late final List<GuidanceLesson> _earnedCards = <GuidanceLesson>[
    guidanceLessons.first,
  ];

  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GuidanceLesson currentCard = _earnedCards[_currentIndex];
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAF8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF162025)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '金库',
          style: TextStyle(
            color: Color(0xFF162025),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '这里存放你已经获得的概念卡。向左或向右滑动，按获得时间查看。',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF5D696F),
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _earnedCards.length,
                onPageChanged: (int index) {
                  setState(() => _currentIndex = index);
                },
                physics: const ClampingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (BuildContext context, Widget? child) {
                      double scale = 1;
                      if (_pageController.hasClients &&
                          _pageController.position.haveDimensions) {
                        final double page = _pageController.page ?? _currentIndex.toDouble();
                        scale = (1 - (page - index).abs() * 0.08).clamp(0.92, 1.0);
                      }
                      return Transform.scale(scale: scale, child: child);
                    },
                    child: _VaultCard(lesson: _earnedCards[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            _VaultPageIndicator(
              current: _currentIndex,
              count: _earnedCards.length,
            ),
            const SizedBox(height: 14),
            Text(
              '最早获得：CARD-01 · 当前：CARD-${currentCard.chapterNumber.toString().padLeft(2, '0')}',
              style: const TextStyle(
                color: Color(0xFF8A948E),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _VaultCard extends StatelessWidget {
  const _VaultCard({required this.lesson});

  final GuidanceLesson lesson;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xFFFFF9F0), Color(0xFFE8F5E9)],
          ),
          border: Border.all(color: const Color(0xFFFFB547), width: 3),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFFB45309).withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 10),
                child: Row(
                  children: <Widget>[
                    Text(
                      'CARD-${lesson.chapterNumber.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Color(0xFFB45309),
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    _RarityChip(label: lesson.rarity),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.asset(
                      lesson.heroAsset,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
                child: Column(
                  children: <Widget>[
                    Text(
                      lesson.cardName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF162025),
                        fontSize: 22,
                        height: 1.2,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lesson.subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF5D696F),
                        height: 1.4,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RarityChip extends StatelessWidget {
  const _RarityChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFFFB547)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFB45309),
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _VaultPageIndicator extends StatelessWidget {
  const _VaultPageIndicator({required this.current, required this.count});

  final int current;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(count, (int index) {
        final bool active = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? const Color(0xFFFFB547) : const Color(0xFFDDE7E1),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
