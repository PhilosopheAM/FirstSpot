// Last Updated: 2026-05-21
// 最后更新: 2026-05-21
//
// Module: Portfolio detail sheet - holding drill-down bottom sheet
// 模块: 持仓详情底部弹层
//
// Dependencies: flutter/material.dart, portfolio_models, portfolio_theme, portfolio_format, portfolio_add_flow_page, portfolio_sparkline_chart
// 依赖: flutter/material.dart, portfolio_models, portfolio_theme, portfolio_format, portfolio_add_flow_page, portfolio_sparkline_chart
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

import '../domain/portfolio_models.dart';
import '../pages/portfolio_add_flow_page.dart';
import '../utils/portfolio_format.dart';
import 'portfolio_sparkline_chart.dart';
import 'portfolio_theme.dart';

/// Shows holding detail with edit / delete actions.
/// 展示单条持仓详情，支持编辑与删除。
Future<void> showPortfolioDetailSheet({
  required BuildContext context,
  required PortfolioHolding holding,
  required double weight,
  required Future<void> Function(String id) onDelete,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext sheetContext) {
      final double pl = holding.profitLossAmount;
      final double? plPct = holding.profitLossPercent;
      return SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: PortfolioTheme.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          holding.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: PortfolioTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${holding.symbol} · ${holding.assetType.labelZh}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: PortfolioTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: PortfolioTheme.previewBlueBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '占组合 ${formatPortfolioPercent(weight, digits: 0)}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: PortfolioTheme.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
              if (holding.note != null && holding.note!.isNotEmpty) ...<Widget>[
                const SizedBox(height: 6),
                Text(
                  holding.note!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: PortfolioTheme.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              PortfolioSparklineChart(
                symbol: holding.symbol,
                since: holding.tradeDate,
              ),
              const SizedBox(height: 14),
              _MetricGrid(
                leftLabel: '成本价',
                leftValue: formatPortfolioCny(holding.costPrice),
                rightLabel: '最新价',
                rightValue: formatPortfolioCny(holding.effectiveLastPrice),
              ),
              const SizedBox(height: 10),
              _MetricGrid(
                leftLabel: '数量',
                leftValue: '${holding.quantity.toStringAsFixed(holding.quantity % 1 == 0 ? 0 : 2)}',
                rightLabel: '浮动盈亏',
                rightValue: plPct == null
                    ? formatPortfolioCny(pl, showSign: true)
                    : '${formatPortfolioCny(pl, showSign: true)} (${pl >= 0 ? '+' : ''}${formatPortfolioPercent(plPct, digits: 2)})',
                rightValueColor: PortfolioTheme.plColor(pl),
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        Navigator.of(sheetContext).pop();
                        await Navigator.of(context).push<bool>(
                          MaterialPageRoute<bool>(
                            builder: (_) => PortfolioAddFlowPage(
                              editHolding: holding,
                            ),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF1F2438),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('编辑'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () async {
                      final bool? ok = await showDialog<bool>(
                        context: sheetContext,
                        builder: (BuildContext dCtx) => AlertDialog(
                          title: const Text('删除这条持仓？'),
                          content: const Text('删除后无法恢复，请确认。'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(dCtx, false),
                              child: const Text('取消'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(dCtx, true),
                              child: const Text(
                                '删除',
                                style: TextStyle(color: PortfolioTheme.priceUp),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (ok == true) {
                        await onDelete(holding.id);
                        if (sheetContext.mounted) {
                          Navigator.of(sheetContext).pop();
                        }
                      }
                    },
                    child: const Text(
                      '删除',
                      style: TextStyle(color: PortfolioTheme.priceUp),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
    this.rightValueColor,
  });

  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;
  final Color? rightValueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: _MetricCell(label: leftLabel, value: leftValue)),
        const SizedBox(width: 10),
        Expanded(
          child: _MetricCell(
            label: rightLabel,
            value: rightValue,
            valueColor: rightValueColor,
          ),
        ),
      ],
    );
  }
}

class _MetricCell extends StatelessWidget {
  const _MetricCell({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: PortfolioTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: valueColor ?? PortfolioTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
