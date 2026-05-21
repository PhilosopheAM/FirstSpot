// Last Updated: 2026-05-21
// 最后更新: 2026-05-21
//
// Module: Portfolio sparkline chart - compact holding price trend
// 模块: 持仓迷你走势图 - 详情弹层走势示意
//
// Dependencies: fl_chart, portfolio_market_data_service, portfolio_theme
// 依赖: fl_chart, portfolio_market_data_service, portfolio_theme
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/portfolio_market_data_service.dart';
import 'portfolio_theme.dart';

/// Async sparkline for a single holding (mock daily closes).
/// 单条持仓的异步迷你走势（mock 日线收盘）。
class PortfolioSparklineChart extends StatelessWidget {
  const PortfolioSparklineChart({
    super.key,
    required this.symbol,
    required this.since,
    this.height = 96,
    this.marketDataService = const PortfolioMarketDataService(),
  });

  final String symbol;
  final DateTime since;
  final double height;
  final PortfolioMarketDataService marketDataService;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PortfolioDailyClose>>(
      future: marketDataService.loadSparklineSeries(
        symbol: symbol,
        since: since,
      ),
      builder:
          (
            BuildContext context,
            AsyncSnapshot<List<PortfolioDailyClose>> snapshot,
          ) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _ChartShell(
            height: height,
            child: const Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        final List<PortfolioDailyClose> series = snapshot.data ?? <PortfolioDailyClose>[];
        if (series.length < 2) {
          return _ChartShell(
            height: height,
            child: const Center(
              child: Text(
                '暂无走势数据',
                style: TextStyle(
                  fontSize: 12,
                  color: PortfolioTheme.textSecondary,
                ),
              ),
            ),
          );
        }

        final double first = series.first.close;
        final double last = series.last.close;
        final Color lineColor = PortfolioTheme.plColor(last - first);

        final List<FlSpot> spots = List<FlSpot>.generate(
          series.length,
          (int i) => FlSpot(i.toDouble(), series[i].close),
        );

        return _ChartShell(
          height: height,
          child: LineChart(
            LineChartData(
              lineTouchData: const LineTouchData(enabled: false),
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              minY: series.map((PortfolioDailyClose p) => p.close).reduce(
                    (double a, double b) => a < b ? a : b,
                  ) *
                  0.995,
              maxY: series.map((PortfolioDailyClose p) => p.close).reduce(
                    (double a, double b) => a > b ? a : b,
                  ) *
                  1.005,
              lineBarsData: <LineChartBarData>[
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.28,
                  preventCurveOverShooting: true,
                  color: lineColor,
                  barWidth: 1.8,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: <Color>[
                        lineColor.withValues(alpha: 0.18),
                        lineColor.withValues(alpha: 0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
            duration: Duration.zero,
          ),
        );
      },
    );
  }
}

class _ChartShell extends StatelessWidget {
  const _ChartShell({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
