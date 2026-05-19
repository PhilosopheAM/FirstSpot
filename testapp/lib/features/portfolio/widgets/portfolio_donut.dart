// Last Updated: 2026-05-19
// 最后更新: 2026-05-19
//
// Module: Portfolio donut - position count ring (Figma DonutCluster)
// 模块: 持仓环形图 - 展示持仓只数（对齐 Figma 环心）
//
// Dependencies: flutter/material.dart, portfolio_theme
// 依赖: flutter/material.dart, portfolio_theme
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

import 'portfolio_theme.dart';

class PortfolioDonut extends StatelessWidget {
  const PortfolioDonut({super.key, required this.positionCount});

  final int positionCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 132,
      height: 132,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: const Size(132, 132),
            painter: _DonutRingPainter(),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '$positionCount',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: PortfolioTheme.textPrimary,
                ),
              ),
              const Text(
                '只持仓',
                style: TextStyle(
                  fontSize: 10,
                  color: PortfolioTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double outer = size.width / 2;
    final double inner = outer * 0.55;
    final Paint ring = Paint()
      ..color = PortfolioTheme.primaryBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = outer - inner;
    canvas.drawCircle(center, (outer + inner) / 2, ring);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
