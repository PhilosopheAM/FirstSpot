/// Last Updated: 2026-04-25
/// 最后更新: 2026-04-25
///
/// Module: XP flyup overlay - non-blocking top-right reward feedback
/// 模块: XP 向上飘动反馈 - 不遮挡底部交互的右上角奖励动效
///
/// Dependencies: flutter/material.dart
///
/// Author: AI
/// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

void showXpFlyup(BuildContext context, int amount) {
  final OverlayState? overlay = Overlay.maybeOf(context);
  if (overlay == null) {
    return;
  }

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (BuildContext context) {
      final double safeTop = MediaQuery.paddingOf(context).top;
      return Positioned(
        top: safeTop + 56,
        right: 24,
        child: IgnorePointer(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 1250),
            curve: Curves.easeOutCubic,
            onEnd: entry.remove,
            builder: (BuildContext context, double value, Widget? child) {
              final double opacity = (1 - value).clamp(0.0, 1.0);
              return Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: Offset(0, -130 * value),
                  child: Transform.scale(
                    scale: 1 + 0.08 * (1 - value),
                    child: child,
                  ),
                ),
              );
            },
            child: _XpFlyupPill(amount: amount),
          ),
        ),
      );
    },
  );

  overlay.insert(entry);
}

class _XpFlyupPill extends StatelessWidget {
  const _XpFlyupPill({required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9F0),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFFFB547), width: 2),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFFFFB547).withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              '✦',
              style: TextStyle(
                color: Color(0xFFFFB547),
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '+$amount XP',
              style: const TextStyle(
                color: Color(0xFFB45309),
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
