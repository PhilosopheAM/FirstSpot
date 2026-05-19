// Last Updated: 2026-05-19
// 最后更新: 2026-05-19
//
// Module: Portfolio concentration section - Top1 / Top3 bars
// 模块: 持仓集中度区块 - 最大单一与前三累计
//
// Dependencies: flutter/material.dart, portfolio_format, portfolio_theme
// 依赖: flutter/material.dart, portfolio_format, portfolio_theme
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

import '../utils/portfolio_format.dart';
import 'portfolio_theme.dart';

class PortfolioConcentrationSection extends StatelessWidget {
  const PortfolioConcentrationSection({
    super.key,
    required this.top1Weight,
    required this.top3Weight,
  });

  final double top1Weight;
  final double top3Weight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          '集中度',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: PortfolioTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        _ConcentrationRow(
          label: '最大单一占比',
          fraction: top1Weight,
          fillColor: const Color(0xFFF2A54B),
        ),
        const SizedBox(height: 10),
        _ConcentrationRow(
          label: '前三累计占比',
          fraction: top3Weight,
          fillColor: PortfolioTheme.primaryBlue,
        ),
      ],
    );
  }
}

class _ConcentrationRow extends StatelessWidget {
  const _ConcentrationRow({
    required this.label,
    required this.fraction,
    required this.fillColor,
  });

  final String label;
  final double fraction;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: PortfolioTheme.textSecondary,
              ),
            ),
            Text(
              formatPortfolioPercent(fraction, digits: 0),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: PortfolioTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction.clamp(0, 1),
            minHeight: 8,
            backgroundColor: const Color(0xFFE6E9F0),
            color: fillColor,
          ),
        ),
      ],
    );
  }
}
