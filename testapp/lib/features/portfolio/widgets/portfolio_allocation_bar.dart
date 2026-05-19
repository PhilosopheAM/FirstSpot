// Last Updated: 2026-05-19
// 最后更新: 2026-05-19
//
// Module: Portfolio allocation bar - stacked type breakdown
// 模块: 持仓大类堆叠条
//
// Dependencies: flutter/material.dart, portfolio_models, portfolio_theme
// 依赖: flutter/material.dart, portfolio_models, portfolio_theme
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

import '../domain/portfolio_models.dart';
import '../utils/portfolio_format.dart';
import 'portfolio_theme.dart';

class PortfolioAllocationBar extends StatelessWidget {
  const PortfolioAllocationBar({super.key, required this.slices});

  final List<PortfolioAllocationSlice> slices;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: SizedBox(
            height: 10,
            child: slices.isEmpty
                ? Container(color: PortfolioTheme.border)
                : Row(
                    children: slices
                        .map(
                          (PortfolioAllocationSlice s) => Expanded(
                            flex: (s.fraction * 1000).round().clamp(1, 1000),
                            child: Container(
                              color: PortfolioTheme.assetTypeColor(s.assetType),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: slices
              .map(
                (PortfolioAllocationSlice s) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: PortfolioTheme.assetTypeColor(s.assetType),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${s.assetType.labelZh} ${formatPortfolioPercent(s.fraction, digits: 0)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: PortfolioTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
