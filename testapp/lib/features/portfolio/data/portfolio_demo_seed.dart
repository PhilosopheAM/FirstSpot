// Last Updated: 2026-05-21
// 最后更新: 2026-05-21
//
// Module: Portfolio demo seed - default holdings for screen recording
// 模块: 持仓演示种子数据 - Android Studio 录屏演示用默认持仓
//
// Dependencies: portfolio_models
// 依赖: portfolio_models
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import '../domain/portfolio_models.dart';

/// SharedPreferences flag: demo holdings were auto-seeded once.
/// 演示持仓已自动注入一次的标记键。
const String portfolioDemoSeededPrefKey = 'portfolio.demo_seeded_v1';

/// Six positions (3 A-share stocks + 3 A-share ETFs) for portfolio demo.
/// 录屏演示用六条持仓（3 只股票 + 3 只 ETF）。
///
/// Prices align with `assets/mock_data/*_daily.json` last close (2026-05-20).
/// 价格与 mock 日线 JSON 末日收盘价对齐。
List<PortfolioHolding> buildPortfolioDemoHoldings() {
  return <PortfolioHolding>[
    PortfolioHolding(
      id: 'demo-600519',
      assetType: PortfolioAssetType.stock,
      symbol: '600519.SH',
      name: '贵州茅台',
      quantity: 100,
      costPrice: 1580,
      lastPrice: 1727.25,
      tradeDate: DateTime(2025, 9, 12),
      note: '富途牛牛',
      dayChangePercent: 0.62,
    ),
    PortfolioHolding(
      id: 'demo-000858',
      assetType: PortfolioAssetType.stock,
      symbol: '000858.SZ',
      name: '五粮液',
      quantity: 200,
      costPrice: 128,
      lastPrice: 159.02,
      tradeDate: DateTime(2025, 10, 8),
      note: '招商证券',
      dayChangePercent: -0.35,
    ),
    PortfolioHolding(
      id: 'demo-601318',
      assetType: PortfolioAssetType.stock,
      symbol: '601318.SH',
      name: '中国平安',
      quantity: 500,
      costPrice: 52.3,
      lastPrice: 58.64,
      tradeDate: DateTime(2025, 11, 21),
      note: '富途牛牛',
      dayChangePercent: 1.15,
    ),
    PortfolioHolding(
      id: 'demo-510300',
      assetType: PortfolioAssetType.fund,
      symbol: '510300.SH',
      name: '沪深300ETF',
      quantity: 5000,
      costPrice: 3.85,
      lastPrice: 4.34,
      tradeDate: DateTime(2025, 12, 15),
      note: '招商证券',
      dayChangePercent: 0.55,
    ),
    PortfolioHolding(
      id: 'demo-159915',
      assetType: PortfolioAssetType.fund,
      symbol: '159915.SZ',
      name: '创业板ETF',
      quantity: 3000,
      costPrice: 2.15,
      lastPrice: 2.29,
      tradeDate: DateTime(2026, 2, 3),
      note: '富途牛牛',
      dayChangePercent: -0.92,
    ),
    PortfolioHolding(
      id: 'demo-512880',
      assetType: PortfolioAssetType.fund,
      symbol: '512880.SH',
      name: '证券ETF',
      quantity: 8000,
      costPrice: 1.05,
      lastPrice: 1.25,
      tradeDate: DateTime(2026, 4, 7),
      note: '招商证券',
      dayChangePercent: 0.18,
    ),
  ];
}
