/// Last Updated: 2026-04-29
/// 最后更新: 2026-04-29
///
/// Module: Reusable stock insight page wired to data middle-layer service.
/// 模块: 连接数据中间层服务的可复用个股信息页面。
///
/// Dependencies: dart:math, flutter/material.dart, fl_chart, stock_insight_models, stock_insight_data_service
/// 依赖: dart:math, flutter/material.dart, fl_chart, stock_insight_models, stock_insight_data_service
///
/// Author: Harry Chen
/// Email: 11911421@mail.sustech.edu.cn
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/stock_insight_data_service.dart';
import '../domain/stock_insight_models.dart';

/// Standalone reusable page for stock insight display.
/// 可独立复用的个股信息展示页。
class StockInsightTemplatePage extends StatefulWidget {
  const StockInsightTemplatePage({
    super.key,
    this.ticker = '600519', // Default to Moutai
    this.dataService,
  });

  final String ticker;
  final StockInsightDataService? dataService;

  @override
  State<StockInsightTemplatePage> createState() =>
      _StockInsightTemplatePageState();
}

class _StockInsightTemplatePageState extends State<StockInsightTemplatePage> {
  static const double _dayDurationX = 86400000;
  static const int _maxRenderedChartPointCount = 64;

  late final StockInsightDataService _dataService =
      widget.dataService ??
      const StockInsightDataService(backendApi: MockStockInsightBackendApi());
  late final Future<StockInsightViewData> _futureData = _dataService
      .loadPageData(ticker: widget.ticker);

  bool _showTicker = false;
  String _selectedTimeFrame = '1M';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StockInsightViewData>(
      future: _futureData,
      builder:
          (BuildContext context, AsyncSnapshot<StockInsightViewData> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: CircularProgressIndicator(color: Color(0xFF1ACC4D)),
                ),
              );
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '数据加载失败，请稍后重试\n${snapshot.error ?? ''}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4B5760),
                      ),
                    ),
                  ),
                ),
              );
            }

            final StockInsightViewData data = snapshot.data!;
            final List<FlSpot> chartSpots = data.dayLineSeries
                .map((PricePoint point) => FlSpot(point.x, point.y))
                .toList(growable: false);
            final List<FlSpot> visibleChartSpots =
                _displaySpotsForSelectedTimeFrame(chartSpots);

            // Calculate latest price and change
            final double latestPrice = data.dayLineSeries.last.y;
            final double prevPrice = data.dayLineSeries.length > 1
                ? data.dayLineSeries[data.dayLineSeries.length - 2].y
                : latestPrice;
            final double change = latestPrice - prevPrice;
            final double changePercent = (change / prevPrice) * 100;
            final bool isPositive = change >= 0;
            final Color changeColor = isPositive
                ? const Color(0xFF1ACC4D)
                : const Color(0xFFE53333);
            final String sign = isPositive ? '+' : '';

            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: CustomScrollView(
                  slivers: <Widget>[
                    _buildTopBar(data.profile),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildHeroArea(
                            latestPrice,
                            change,
                            changePercent,
                            sign,
                            changeColor,
                            visibleChartSpots,
                          ),
                          _buildStatsGrid(),
                          _buildAnalystRatings(),
                          _buildFinancialHealth(),
                          _buildAboutCompany(data.profile),
                          _buildMyoCompanion(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
    );
  }

  Widget _buildTopBar(SecurityProfile profile) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: 48,
              child: IconButton(
                tooltip: '返回',
                icon: const Icon(
                  Icons.arrow_back,
                  size: 24,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showTicker = !_showTicker;
                });
              },
              child: Column(
                children: <Widget>[
                  Text(
                    _showTicker ? profile.ticker : profile.securityNameCn,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    profile.securityNameEn,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Color(0xFF808080),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 48,
              child: Icon(Icons.star_border, size: 24, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroArea(
    double price,
    double change,
    double changePercent,
    String sign,
    Color changeColor,
    List<FlSpot> spots,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '¥${price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$sign¥${change.toStringAsFixed(2)} ($sign${changePercent.toStringAsFixed(2)}%)',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: changeColor,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 180,
            width: double.infinity,
            child: LineChart(
              LineChartData(
                lineTouchData: const LineTouchData(enabled: false),
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: <LineChartBarData>[
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    preventCurveOverShooting: true,
                    color: changeColor,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: <Color>[
                          changeColor.withValues(alpha: 0.2),
                          changeColor.withValues(alpha: 0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <String>['1D', '1W', '1M', '3M', '1Y', 'ALL'].map((
              String time,
            ) {
              final bool isSelected = time == _selectedTimeFrame;
              return GestureDetector(
                key: ValueKey<String>('stock-timeframe-$time'),
                onTap: () {
                  setState(() {
                    _selectedTimeFrame = time;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFE5F2E5)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF1A9933)
                          : const Color(0xFF808080),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _displaySpotsForSelectedTimeFrame(List<FlSpot> spots) {
    return _downsampleForSmoothDisplay(_spotsForSelectedTimeFrame(spots));
  }

  List<FlSpot> _spotsForSelectedTimeFrame(List<FlSpot> spots) {
    if (spots.length <= 2 || _selectedTimeFrame == 'ALL') {
      return spots;
    }

    final double? durationX = _durationForTimeFrame(_selectedTimeFrame);
    if (durationX == null) {
      return spots;
    }

    final double minVisibleX = spots.last.x - durationX;
    final List<FlSpot> filteredSpots = spots
        .where((FlSpot spot) => spot.x >= minVisibleX)
        .toList(growable: false);

    if (filteredSpots.length >= 2) {
      return filteredSpots;
    }

    return spots.sublist(max(0, spots.length - 2));
  }

  List<FlSpot> _downsampleForSmoothDisplay(List<FlSpot> spots) {
    if (spots.length <= _maxRenderedChartPointCount) {
      return spots;
    }

    final int lastIndex = spots.length - 1;
    final double step = lastIndex / (_maxRenderedChartPointCount - 1);
    final List<FlSpot> sampledSpots = <FlSpot>[];

    for (int index = 0; index < _maxRenderedChartPointCount; index++) {
      final int spotIndex = (index * step).round().clamp(0, lastIndex).toInt();
      final FlSpot spot = spots[spotIndex];
      if (sampledSpots.isEmpty || sampledSpots.last.x != spot.x) {
        sampledSpots.add(spot);
      }
    }

    if (sampledSpots.last.x != spots.last.x) {
      sampledSpots.add(spots.last);
    }

    return sampledSpots;
  }

  double? _durationForTimeFrame(String timeFrame) {
    switch (timeFrame) {
      case '1D':
        return _dayDurationX;
      case '1W':
        return _dayDurationX * 7;
      case '1M':
        return _dayDurationX * 30;
      case '3M':
        return _dayDurationX * 90;
      case '1Y':
        return _dayDurationX * 365;
      case 'ALL':
        return null;
    }
    return null;
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: _buildStatCard('Market Cap', '2.07T', '')),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard('P/E Ratio', '27.8', 'Reasonable'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(child: _buildStatCard('Div Yield', '2.84%', '')),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard('52W Range', '¥1400 - 1750', 'Near High'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          if (subtitle.isNotEmpty) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnalystRatings() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Analyst Ratings',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0x1A1ACC4D),
                  borderRadius: BorderRadius.circular(40),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '92%',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1ACC4D),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Column(
                children: <Widget>[
                  _buildRatingBar('Buy', 0.92, const Color(0xFF1ACC4D)),
                  const SizedBox(height: 8),
                  _buildRatingBar('Hold', 0.08, const Color(0xFF999999)),
                  const SizedBox(height: 8),
                  _buildRatingBar('Sell', 0.00, const Color(0xFFE53333)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(String label, double percentage, Color color) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 40,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: Color(0xFF666666),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 120,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFFE6E6E6),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: max(0.01, percentage),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(percentage * 100).round()}%',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialHealth() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Financial Health',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              _buildQuarterChart('Q1', 100, 20),
              _buildQuarterChart('Q2', 110, 25),
              _buildQuarterChart('Q3', 105, 22),
              _buildQuarterChart('Q4', 120, 30),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              _buildLegendItem('Revenue (Earned)', const Color(0xFFCCD9F2)),
              const SizedBox(width: 16),
              _buildLegendItem('Net Income (Kept)', const Color(0xFF3366E5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuarterChart(String label, double revHeight, double profHeight) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              width: 16,
              height: revHeight,
              decoration: BoxDecoration(
                color: const Color(0xFFCCD9F2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 16,
              height: profHeight,
              decoration: BoxDecoration(
                color: const Color(0xFF3366E5),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: Color(0xFF808080),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: <Widget>[
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutCompany(SecurityProfile profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'About ${profile.securityNameCn}',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '贵州茅台酒股份有限公司主要业务是茅台酒及系列酒的生产与销售。主导产品“贵州茅台酒”是世界三大蒸馏名酒之一，也是集绿色食品、有机食品、地理标志产品于一体的中国白酒品牌。',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              height: 1.4,
              color: Color(0xFF4D4D4D),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              _buildTag('# 白酒'),
              const SizedBox(width: 8),
              _buildTag('# 消费品'),
              const SizedBox(width: 8),
              _buildTag('# 核心资产'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _buildMyoCompanion() {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.only(bottom: 40),
      child: Image.asset(
        'assets/images/characters/myo/myo_lay_face_smile.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
