// Last Updated: 2026-05-21
// 最后更新: 2026-05-21
//
// Module: Portfolio unit tests - calculator and repository round-trip
// 模块: 持仓单元测试 - 计算器与仓储往返
//
// Dependencies: flutter_test, portfolio feature
// 依赖: flutter_test, portfolio feature
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:testapp/features/portfolio/data/portfolio_demo_seed.dart';
import 'package:testapp/features/portfolio/data/portfolio_market_data_service.dart';
import 'package:testapp/features/portfolio/data/portfolio_repository.dart';
import 'package:testapp/features/portfolio/domain/portfolio_calculator.dart';
import 'package:testapp/features/portfolio/domain/portfolio_models.dart';

void main() {
  group('PortfolioCalculator', () {
    test('summarize weights and concentration', () {
      final List<PortfolioHolding> holdings = <PortfolioHolding>[
        PortfolioHolding(
          id: '1',
          assetType: PortfolioAssetType.stock,
          symbol: '600519.SH',
          name: '贵州茅台',
          quantity: 10,
          costPrice: 1600,
          tradeDate: DateTime(2024, 1, 1),
          lastPrice: 1700,
        ),
        PortfolioHolding(
          id: '2',
          assetType: PortfolioAssetType.fund,
          symbol: '510300.SH',
          name: '沪深300ETF',
          quantity: 1000,
          costPrice: 4,
          tradeDate: DateTime(2024, 2, 1),
          lastPrice: 4.2,
        ),
      ];

      final PortfolioSummary summary = PortfolioCalculator.summarize(holdings);

      expect(summary.positionCount, 2);
      expect(summary.totalMarketValue, closeTo(17000 + 4200, 0.01));
      expect(summary.top1Weight, greaterThan(summary.top3CumulativeWeight / 3));
      expect(summary.allocationSlices.length, 2);
    });

    test('estimatedWeightForNew divides by expanded total', () {
      final List<PortfolioHolding> existing = <PortfolioHolding>[
        PortfolioHolding(
          id: '1',
          assetType: PortfolioAssetType.cash,
          symbol: 'CASH',
          name: '现金',
          quantity: 1,
          costPrice: 10000,
          tradeDate: DateTime(2024, 1, 1),
        ),
      ];
      final double w = PortfolioCalculator.estimatedWeightForNew(
        existing: existing,
        newMarketValue: 10000,
      );
      expect(w, closeTo(0.5, 0.001));
    });
  });

  group('PortfolioRepository', () {
    test('seeds demo holdings on first empty load', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final PortfolioRepository repo = PortfolioRepository();
      final List<PortfolioHolding> loaded = await repo.loadHoldings();
      expect(loaded, hasLength(6));
      expect(loaded.map((PortfolioHolding h) => h.note).toSet(), contains('富途牛牛'));
      expect(loaded.map((PortfolioHolding h) => h.note).toSet(), contains('招商证券'));
    });

    test('does not re-seed after demo flag is set', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        portfolioDemoSeededPrefKey: true,
      });
      final PortfolioRepository repo = PortfolioRepository();
      final List<PortfolioHolding> loaded = await repo.loadHoldings();
      expect(loaded, isEmpty);
    });

    test('persists holdings as json', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final PortfolioRepository repo = PortfolioRepository();
      final PortfolioHolding holding = PortfolioHolding(
        id: 'abc',
        assetType: PortfolioAssetType.stock,
        symbol: '000001.SZ',
        name: '平安银行',
        quantity: 100,
        costPrice: 12.5,
        tradeDate: DateTime(2025, 5, 12),
        note: '测试',
      );
      await repo.saveHoldings(<PortfolioHolding>[holding]);
      final List<PortfolioHolding> loaded = await repo.loadHoldings();
      expect(loaded, hasLength(1));
      expect(loaded.first.name, '平安银行');
      expect(loaded.first.note, '测试');
    });
  });

  group('PortfolioMarketDataService', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    test('normalizeSymbolCode strips exchange suffix', () {
      expect(
        PortfolioMarketDataService.normalizeSymbolCode('600519.SH'),
        '600519',
      );
    });

    test('loadDailyCloses reads bundled mock json', () async {
      final List<PortfolioDailyClose> series =
          await const PortfolioMarketDataService().loadDailyCloses('510300.SH');
      expect(series.length, greaterThan(30));
      expect(series.last.close, greaterThan(0));
    });
  });

  group('buildPortfolioDemoHoldings', () {
    test('contains 3 stocks and 3 ETFs', () {
      final List<PortfolioHolding> demo = buildPortfolioDemoHoldings();
      final int stocks = demo
          .where((PortfolioHolding h) => h.assetType == PortfolioAssetType.stock)
          .length;
      final int funds = demo
          .where((PortfolioHolding h) => h.assetType == PortfolioAssetType.fund)
          .length;
      expect(stocks, 3);
      expect(funds, 3);
    });
  });
}
