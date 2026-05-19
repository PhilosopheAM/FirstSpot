// Last Updated: 2026-05-19
// 最后更新: 2026-05-19
//
// Module: Portfolio position row - list tile with weight bar
// 模块: 持仓列表行 - 含权重条
//
// Dependencies: flutter/material.dart, portfolio_models, portfolio_theme, portfolio_format
// 依赖: flutter/material.dart, portfolio_models, portfolio_theme, portfolio_format
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

import '../domain/portfolio_models.dart';
import '../utils/portfolio_format.dart';
import 'portfolio_theme.dart';

class PortfolioPositionRow extends StatelessWidget {
  const PortfolioPositionRow({
    super.key,
    required this.holding,
    required this.weight,
    required this.onTap,
  });

  final PortfolioHolding holding;
  final double weight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double day = holding.dayChangePercentOrZero;
    return Material(
      color: PortfolioTheme.cardBackground,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: PortfolioTheme.border),
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: PortfolioTheme.previewBlueBg,
                    child: Text(
                      holding.name.isNotEmpty ? holding.name[0] : '?',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: PortfolioTheme.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          holding.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: PortfolioTheme.textPrimary,
                          ),
                        ),
                        Text(
                          holding.symbol,
                          style: const TextStyle(
                            fontSize: 11,
                            color: PortfolioTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        formatPortfolioCny(holding.marketValue),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: PortfolioTheme.textPrimary,
                        ),
                      ),
                      Text(
                        formatSignedDayChange(day),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: PortfolioTheme.dayChangeColor(day),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: weight.clamp(0, 1),
                  minHeight: 6,
                  backgroundColor: const Color(0xFFEDF0F7),
                  color: PortfolioTheme.primaryBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
