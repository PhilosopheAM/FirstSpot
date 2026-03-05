/// Last Updated: 2026-03-05
/// 最后更新: 2026-03-05
///
/// Module: Stock insight data middle layer adapter with backend contract.
/// 模块: 个股信息数据中间层适配器（含后端服务交互协议）。
///
/// Dependencies: dart:math, stock_insight_models
/// 依赖: dart:math, stock_insight_models
///
/// Author: Harry Chen
/// Email: 11911421@mail.sustech.edu.cn
import 'dart:math';

import '../domain/stock_insight_models.dart';

/// Backend contract for FirstSpot middle-layer service.
/// FirstSpot 后端中间层服务的客户端契约。
abstract class StockInsightBackendApi {
  /// Fetches aggregated insight payload from backend by ticker.
  /// 根据代码从后端拉取聚合后的页面数据。
  Future<StockInsightViewData> fetchStockInsight({
    required String ticker,
  });
}

/// Data service consumed by UI page.
/// 给 UI 页面使用的数据服务。
class StockInsightDataService {
  const StockInsightDataService({required this.backendApi});

  final StockInsightBackendApi backendApi;

  /// Loads page-ready data from middle layer.
  /// 从中间层加载可直接渲染的页面数据。
  Future<StockInsightViewData> loadPageData({
    required String ticker,
  }) {
    return backendApi.fetchStockInsight(ticker: ticker);
  }
}

/// Mock backend API for development stage.
/// 开发阶段的后端模拟实现。
class MockStockInsightBackendApi implements StockInsightBackendApi {
  const MockStockInsightBackendApi();

  @override
  Future<StockInsightViewData> fetchStockInsight({
    required String ticker,
  }) async {
    // Simulates network + middle-layer processing latency.
    // 模拟网络与中间层数据处理耗时。
    await Future<void>.delayed(const Duration(milliseconds: 380));

    final int seed = ticker.hashCode.abs();
    final Random random = Random(seed);

    final List<PricePoint> series = _buildMockDayLineSeries(random);

    return StockInsightViewData(
      profile: SecurityProfile(
        securityNameCn: '星焰互动',
        securityNameEn: 'StarFlame Interactive',
        ticker: ticker,
      ),
      dayLineSeries: series,
      companyCategories: const <CompanyInfoCategory>[
        CompanyInfoCategory(
          title: '主营业务',
          content: '研发与发行移动端策略/角色扮演游戏，核心收入来自游戏内购、赛季通行证和联动活动流水。',
        ),
        CompanyInfoCategory(
          title: '主要市场',
          content: '中国大陆、东南亚与北美并行；北美市场贡献约 35% 流水，海外用户付费稳定性较好。',
        ),
        CompanyInfoCategory(
          title: '竞争程度',
          content: '行业竞争整体处于中高水平，头部厂商在买量与 IP 端优势明显。',
        ),
      ],
      glossaryItems: const <GlossaryItem>[
        GlossaryItem(
          term: '流水',
          explanation: '在游戏行业中，流水是用户在一定周期内的总充值金额，不等于净利润。',
          whyItMatters: '它可以反映产品变现规模，但仍需结合分成比例和成本结构判断真实盈利能力。',
        ),
      ],
    );
  }

  List<PricePoint> _buildMockDayLineSeries(Random random) {
    const int totalCount = 120;
    const int riseCount = 78;
    const double riseStart = 10;
    const double riseEnd = 80;
    const double dropStart = 80;
    const double dropEnd = 40;

    final List<PricePoint> points = <PricePoint>[];
    for (int i = 0; i < totalCount; i++) {
      final double y;
      if (i <= riseCount) {
        final double t = i / riseCount;
        final double trend = riseStart + (riseEnd - riseStart) * t;
        final double wave = sin(t * pi * 3.1) * 2.4;
        final double noise = (random.nextDouble() - 0.5) * 2.2;
        y = trend + wave + noise;
      } else {
        final double t = (i - riseCount) / (totalCount - 1 - riseCount);
        final double trend = dropStart + (dropEnd - dropStart) * t;
        final double wave = sin((t + 0.2) * pi * 2.8) * 2.0;
        final double noise = (random.nextDouble() - 0.5) * 2.9;
        y = trend + wave + noise;
      }
      points.add(PricePoint(x: i.toDouble(), y: y.clamp(8.0, 84.0)));
    }
    return points;
  }
}
