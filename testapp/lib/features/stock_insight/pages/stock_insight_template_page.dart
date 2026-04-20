/// Last Updated: 2026-04-20
/// 最后更新: 2026-04-20
///
/// Module: Reusable stock insight page wired to data middle-layer service.
/// 模块: 连接数据中间层服务的可复用个股信息页面。
///
/// Dependencies: flutter/material.dart, fl_chart, stock_insight_models, stock_insight_data_service, price_fluctuation_chart_v2
/// 依赖: flutter/material.dart, fl_chart, stock_insight_models, stock_insight_data_service, price_fluctuation_chart_v2
///
/// Author: Harry Chen
/// Email: 11911421@mail.sustech.edu.cn
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/stock_insight_data_service.dart';
import '../domain/stock_insight_models.dart';
import '../widgets/price_fluctuation_chart_v2.dart';

/// Standalone reusable page for stock insight display.
/// 可独立复用的个股信息展示页。
class StockInsightTemplatePage extends StatefulWidget {
  const StockInsightTemplatePage({
    super.key,
    this.ticker = 'SFI.US',
    this.dataService,
  });

  final String ticker;
  final StockInsightDataService? dataService;

  @override
  State<StockInsightTemplatePage> createState() => _StockInsightTemplatePageState();
}

class _StockInsightTemplatePageState extends State<StockInsightTemplatePage> {
  final PageController _infoPageController = PageController();
  int _currentInfoIndex = 0;

  late final StockInsightDataService _dataService = widget.dataService ??
      const StockInsightDataService(
        backendApi: MockStockInsightBackendApi(),
      );
  late final Future<StockInsightViewData> _futureData = _dataService.loadPageData(
    ticker: widget.ticker,
  );

  @override
  void dispose() {
    _infoPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StockInsightViewData>(
      future: _futureData,
      builder: (
        BuildContext context,
        AsyncSnapshot<StockInsightViewData> snapshot,
      ) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Color(0xFFF4F7F5),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            backgroundColor: const Color(0xFFF4F7F5),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  '数据加载失败，请稍后重试\n${snapshot.error ?? ''}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF4B5760)),
                ),
              ),
            ),
          );
        }

        final StockInsightViewData data = snapshot.data!;
        final List<FlSpot> chartSpots = data.dayLineSeries
            .map((PricePoint point) => FlSpot(point.x, point.y))
            .toList(growable: false);

        final double maxHeaderHeight = MediaQuery.of(context).size.height * 0.48;

        return Scaffold(
          backgroundColor: const Color(0xFFF4F7F5),
          body: SafeArea(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverPersistentHeader(
                  pinned: false,
                  delegate: _CollapsibleHeaderDelegate(
                    minExtentValue: 0,
                    maxExtentValue: maxHeaderHeight,
                    child: PriceFluctuationChartV2(
                      securityNameCn: data.profile.securityNameCn,
                      securityNameEn: data.profile.securityNameEn,
                      ticker: data.profile.ticker,
                      spots: chartSpots,
                      subtitle: '数据来源：FirstSpot 数据中间层服务',
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 18),
                    child: Column(
                      children: <Widget>[
                        _buildCompanyInfoSlider(data.companyCategories),
                        const SizedBox(height: 12),
                        _buildAiGlossaryPanel(data.glossaryItems),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompanyInfoSlider(List<CompanyInfoCategory> categories) {
    final List<CompanyInfoCategory> safeCategories = categories.isEmpty
        ? const <CompanyInfoCategory>[
            CompanyInfoCategory(title: '暂无信息', content: '当前未获取到公司信息分类数据。'),
          ]
        : categories;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            '公司信息滑窗',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A2026),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: PageView.builder(
              controller: _infoPageController,
              itemCount: safeCategories.length,
              onPageChanged: (int index) {
                setState(() {
                  _currentInfoIndex = index;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                final CompanyInfoCategory item = safeCategories[index];
                return Container(
                  margin: const EdgeInsets.only(right: 4),
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAF8),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0x16000000)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2A33),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.content,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: Color(0xFF55616A),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(safeCategories.length, (int index) {
              final bool active = index == _currentInfoIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 6,
                width: active ? 20 : 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: active ? const Color(0xFF1FA95B) : const Color(0x332B343B),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAiGlossaryPanel(List<GlossaryItem> items) {
    final List<GlossaryItem> safeItems = items.isEmpty
        ? const <GlossaryItem>[
            GlossaryItem(
              term: '暂无词汇',
              explanation: '当前未返回专业词汇解释数据。',
              whyItMatters: '可在中间层接入 AI 解释服务后返回对应数据。',
            ),
          ]
        : items;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'AI 专业词汇解释',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A2026),
            ),
          ),
          const SizedBox(height: 10),
          ...safeItems.map((GlossaryItem item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _GlossaryCard(
                term: item.term,
                explanation: item.explanation,
                whyItMatters: item.whyItMatters,
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Header delegate to collapse the upper chart area to zero.
/// 将上半屏图表区域折叠到零高度的 Header 委托。
class _CollapsibleHeaderDelegate extends SliverPersistentHeaderDelegate {
  _CollapsibleHeaderDelegate({
    required this.minExtentValue,
    required this.maxExtentValue,
    required this.child,
  });

  final double minExtentValue;
  final double maxExtentValue;
  final Widget child;

  @override
  double get minExtent => minExtentValue;

  @override
  double get maxExtent => max(maxExtentValue, minExtentValue);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _CollapsibleHeaderDelegate oldDelegate) {
    return oldDelegate.minExtentValue != minExtentValue ||
        oldDelegate.maxExtentValue != maxExtentValue ||
        oldDelegate.child != child;
  }
}

/// Card for AI glossary explanation.
/// AI 术语解释卡片。
class _GlossaryCard extends StatelessWidget {
  const _GlossaryCard({
    required this.term,
    required this.explanation,
    required this.whyItMatters,
  });

  final String term;
  final String explanation;
  final String whyItMatters;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FAF7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x17000000)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            term,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2B35),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            explanation,
            style: const TextStyle(
              fontSize: 13,
              height: 1.35,
              color: Color(0xFF516069),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '为什么重要',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF239157),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            whyItMatters,
            style: const TextStyle(
              fontSize: 13,
              height: 1.35,
              color: Color(0xFF4A5A64),
            ),
          ),
        ],
      ),
    );
  }
}
