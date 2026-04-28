// Last Updated: 2026-04-29
// 最后更新: 2026-04-29
//
// Module: Vault Page - card and badge collectibles after learning progress
// 模块: 金库页面 - 学习进度后的卡片与徽章收藏品
//
// Dependencies: flutter/material.dart, guidance user progress and collectible models
// 依赖: flutter/material.dart, 投资者教育用户进度与收藏品模型
//
// Author: AI
// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

import '../../learning_guidance/data/guidance_user_progress.dart';
import '../../learning_guidance/domain/guidance_models.dart';

enum _VaultCollectionMode { cards, badges }

class VaultPage extends StatefulWidget {
  const VaultPage({super.key});

  @override
  State<VaultPage> createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  final PageController _pageController = PageController(viewportFraction: 0.82);
  _VaultCollectionMode _mode = _VaultCollectionMode.cards;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    guidanceUserProgress.load();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: AnimatedBuilder(
          animation: guidanceUserProgress,
          builder: (BuildContext context, Widget? child) {
            final List<GuidanceLesson> cards = guidanceUserProgress.earnedCards;
            final List<GuidanceBadgeReward> badges =
                guidanceUserProgress.earnedBadges;
            final int itemCount = _mode == _VaultCollectionMode.cards
                ? cards.length
                : badges.length;
            final int safeIndex = itemCount == 0
                ? 0
                : _currentIndex.clamp(0, itemCount - 1);
            if (safeIndex != _currentIndex) {
              _currentIndex = safeIndex;
            }

            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    _mode == _VaultCollectionMode.cards
                        ? '这里存放你完成章节学习后收获的章节卡片。'
                        : '这里存放你首次完成关键任务后收获的成就徽章。',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF5D696F),
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: itemCount == 0
                      ? _VaultEmptyState(mode: _mode)
                      : PageView.builder(
                          controller: _pageController,
                          itemCount: itemCount,
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
                                  final double page =
                                      _pageController.page ??
                                      _currentIndex.toDouble();
                                  scale = (1 - (page - index).abs() * 0.08)
                                      .clamp(0.92, 1.0);
                                }
                                return Transform.scale(
                                  scale: scale,
                                  child: child,
                                );
                              },
                              child: _mode == _VaultCollectionMode.cards
                                  ? _VaultCard(lesson: cards[index])
                                  : _VaultBadge(reward: badges[index]),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 12),
                _VaultPageIndicator(current: safeIndex, count: itemCount),
                const SizedBox(height: 14),
                Text(
                  _buildFooterLabel(
                    cards: cards,
                    badges: badges,
                    index: safeIndex,
                  ),
                  style: const TextStyle(
                    color: Color(0xFF8A948E),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                _VaultModeSelector(mode: _mode, onChanged: _switchMode),
                const SizedBox(height: 18),
              ],
            );
          },
        ),
      ),
    );
  }

  String _buildFooterLabel({
    required List<GuidanceLesson> cards,
    required List<GuidanceBadgeReward> badges,
    required int index,
  }) {
    if (_mode == _VaultCollectionMode.cards) {
      if (cards.isEmpty) {
        return '尚未获得章节卡片';
      }
      final GuidanceLesson card = cards[index];
      return '卡片 ${index + 1} / ${cards.length} · CARD-${card.chapterNumber.toString().padLeft(2, '0')}';
    }
    if (badges.isEmpty) {
      return '尚未获得成就徽章';
    }
    return '徽章 ${index + 1} / ${badges.length} · ${badges[index].title}';
  }

  void _switchMode(_VaultCollectionMode mode) {
    if (_mode == mode) {
      return;
    }
    setState(() {
      _mode = mode;
      _currentIndex = 0;
    });
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
  }
}

class _VaultModeSelector extends StatelessWidget {
  const _VaultModeSelector({required this.mode, required this.onChanged});

  final _VaultCollectionMode mode;
  final ValueChanged<_VaultCollectionMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 52,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFDDE7E1)),
        ),
        child: Row(
          children: <Widget>[
            _VaultModeButton(
              selected: mode == _VaultCollectionMode.cards,
              label: '卡片',
              icon: Icons.style_rounded,
              onTap: () => onChanged(_VaultCollectionMode.cards),
            ),
            _VaultModeButton(
              selected: mode == _VaultCollectionMode.badges,
              label: '徽章',
              icon: Icons.workspace_premium_rounded,
              onTap: () => onChanged(_VaultCollectionMode.badges),
            ),
          ],
        ),
      ),
    );
  }
}

class _VaultModeButton extends StatelessWidget {
  const _VaultModeButton({
    required this.selected,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final bool selected;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFF0CC) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 18,
                color: selected
                    ? const Color(0xFFB45309)
                    : const Color(0xFF5D696F),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? const Color(0xFFB45309)
                      : const Color(0xFF5D696F),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VaultEmptyState extends StatelessWidget {
  const _VaultEmptyState({required this.mode});

  final _VaultCollectionMode mode;

  @override
  Widget build(BuildContext context) {
    final bool isCardMode = mode == _VaultCollectionMode.cards;
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFDDE7E1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              isCardMode
                  ? Icons.style_rounded
                  : Icons.workspace_premium_rounded,
              color: const Color(0xFF8A948E),
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              isCardMode ? '还没有章节卡片' : '还没有成就徽章',
              style: const TextStyle(
                color: Color(0xFF162025),
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isCardMode ? '完成任一章节学习后会收获章节主视觉卡片。' : '首次完成关键学习任务后会收获徽章。',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF5D696F),
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
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

class _VaultBadge extends StatelessWidget {
  const _VaultBadge({required this.reward});

  final GuidanceBadgeReward reward;

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
            colors: <Color>[Color(0xFFFFFCF4), Color(0xFFE9F6EF)],
          ),
          border: Border.all(color: const Color(0xFF70B88A), width: 3),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF1F7A4D).withValues(alpha: 0.12),
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
                    const Text(
                      'BADGE',
                      style: TextStyle(
                        color: Color(0xFF1F7A4D),
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    _RarityChip(label: '成就'),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.asset(
                      reward.assetPath,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
                child: Column(
                  children: <Widget>[
                    Text(
                      reward.title,
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
                      reward.triggerLabel,
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
    if (count == 0) {
      return const SizedBox(height: 8);
    }
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
