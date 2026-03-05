/// Last Updated: 2026-03-05
/// 最后更新: 2026-03-05
///
/// Module: Domain models for stock insight page and reusable widgets.
/// 模块: 个股信息页与可复用组件的领域模型定义。
///
/// Dependencies: none
/// 依赖: 无
///
/// Author: Harry Chen
/// Email: 11911421@mail.sustech.edu.cn

/// Security profile shown in the chart header.
/// 图表头部展示的标的信息。
class SecurityProfile {
  const SecurityProfile({
    required this.securityNameCn,
    required this.securityNameEn,
    required this.ticker,
  });

  final String securityNameCn;
  final String securityNameEn;
  final String ticker;
}

/// One point in day-line price series.
/// 日线价格序列中的单个点。
class PricePoint {
  const PricePoint({required this.x, required this.y});

  final double x;
  final double y;
}

/// Swipeable company info section item.
/// 公司信息滑窗中的单个分类项。
class CompanyInfoCategory {
  const CompanyInfoCategory({required this.title, required this.content});

  final String title;
  final String content;
}

/// AI glossary explanation item.
/// AI 术语解释项。
class GlossaryItem {
  const GlossaryItem({
    required this.term,
    required this.explanation,
    required this.whyItMatters,
  });

  final String term;
  final String explanation;
  final String whyItMatters;
}

/// Aggregated payload returned by middle-layer service.
/// 中间层服务返回的聚合页面数据。
class StockInsightViewData {
  const StockInsightViewData({
    required this.profile,
    required this.dayLineSeries,
    required this.companyCategories,
    required this.glossaryItems,
  });

  final SecurityProfile profile;
  final List<PricePoint> dayLineSeries;
  final List<CompanyInfoCategory> companyCategories;
  final List<GlossaryItem> glossaryItems;
}
