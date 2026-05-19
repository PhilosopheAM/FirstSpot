// Last Updated: 2026-05-19
// 最后更新: 2026-05-19
//
// Module: Portfolio calculator - weights, allocation, concentration, sorting
// 模块: 持仓计算器 - 权重、大类占比、集中度与排序
//
// Dependencies: portfolio_models
// 依赖: portfolio_models
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'portfolio_models.dart';

/// Pure functions for portfolio analytics shown on overview.
/// 总览页展示用的纯函数组合分析。
class PortfolioCalculator {
  const PortfolioCalculator._();

  static PortfolioSummary summarize(List<PortfolioHolding> holdings) {
    final List<PortfolioHolding> copy = List<PortfolioHolding>.from(holdings);
    if (copy.isEmpty) {
      return const PortfolioSummary(
        holdings: <PortfolioHolding>[],
        totalMarketValue: 0,
        totalCostBasis: 0,
        totalProfitLoss: 0,
        totalProfitLossPercent: null,
        allocationSlices: <PortfolioAllocationSlice>[],
        top1Weight: 0,
        top3CumulativeWeight: 0,
        positionCount: 0,
      );
    }

    final double totalMv =
        copy.fold<double>(0, (double s, PortfolioHolding h) => s + h.marketValue);
    final double totalCost =
        copy.fold<double>(0, (double s, PortfolioHolding h) => s + h.costBasisTotal);
    final double pl = totalMv - totalCost;

    final Map<PortfolioAssetType, double> byType = <PortfolioAssetType, double>{};
    for (final PortfolioHolding h in copy) {
      byType[h.assetType] = (byType[h.assetType] ?? 0) + h.marketValue;
    }

    final List<PortfolioAllocationSlice> slices = byType.entries
        .map(
          (MapEntry<PortfolioAssetType, double> e) => PortfolioAllocationSlice(
            assetType: e.key,
            value: e.value,
            fraction: totalMv > 0 ? e.value / totalMv : 0,
          ),
        )
        .toList()
      ..sort(
        (PortfolioAllocationSlice a, PortfolioAllocationSlice b) =>
            b.fraction.compareTo(a.fraction),
      );

    copy.sort(
      (PortfolioHolding a, PortfolioHolding b) =>
          b.marketValue.compareTo(a.marketValue),
    );

    double top1 = 0;
    double top3 = 0;
    for (int i = 0; i < copy.length; i++) {
      final double w = totalMv > 0 ? copy[i].marketValue / totalMv : 0;
      if (i == 0) {
        top1 = w;
      }
      if (i < 3) {
        top3 += w;
      }
    }

    return PortfolioSummary(
      holdings: copy,
      totalMarketValue: totalMv,
      totalCostBasis: totalCost,
      totalProfitLoss: pl,
      totalProfitLossPercent: totalCost > 0 ? pl / totalCost : null,
      allocationSlices: slices,
      top1Weight: top1,
      top3CumulativeWeight: top3,
      positionCount: copy.length,
    );
  }

  static List<PortfolioHolding> sortHoldings(
    List<PortfolioHolding> holdings,
    PortfolioSortMode mode,
    PortfolioSummary summary,
  ) {
    final List<PortfolioHolding> sorted = List<PortfolioHolding>.from(holdings);
    switch (mode) {
      case PortfolioSortMode.byWeight:
        sorted.sort(
          (PortfolioHolding a, PortfolioHolding b) =>
              summary.weightOf(b).compareTo(summary.weightOf(a)),
        );
      case PortfolioSortMode.byValue:
        sorted.sort(
          (PortfolioHolding a, PortfolioHolding b) =>
              b.marketValue.compareTo(a.marketValue),
        );
      case PortfolioSortMode.byDayChange:
        sorted.sort(
          (PortfolioHolding a, PortfolioHolding b) =>
              b.dayChangePercentOrZero.compareTo(a.dayChangePercentOrZero),
        );
      case PortfolioSortMode.byName:
        sorted.sort(
          (PortfolioHolding a, PortfolioHolding b) =>
              a.name.compareTo(b.name),
        );
    }
    return sorted;
  }

  /// Estimated weight if a new holding were added (for add-flow preview).
  /// 添加流程中预览新标的的组合占比。
  static double estimatedWeightForNew({
    required List<PortfolioHolding> existing,
    required double newMarketValue,
  }) {
    final double currentTotal = existing.fold<double>(
      0,
      (double s, PortfolioHolding h) => s + h.marketValue,
    );
    final double nextTotal = currentTotal + newMarketValue;
    if (nextTotal <= 0) {
      return 1;
    }
    return newMarketValue / nextTotal;
  }
}
