import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:testapp/features/stock_insight/data/stock_insight_data_service.dart';
import 'package:testapp/features/stock_insight/domain/stock_insight_models.dart';
import 'package:testapp/features/stock_insight/pages/stock_insight_template_page.dart';

void main() {
  testWidgets('stock insight back button pops to previous page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => StockInsightTemplatePage(
                        dataService: StockInsightDataService(
                          backendApi: _FakeStockInsightBackendApi(),
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('open stock'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open stock'));
    await tester.pumpAndSettle();

    expect(find.byType(StockInsightTemplatePage), findsOneWidget);

    await tester.tap(find.byTooltip('返回'));
    await tester.pumpAndSettle();

    expect(find.byType(StockInsightTemplatePage), findsNothing);
    expect(find.text('open stock'), findsOneWidget);
  });

  testWidgets('stock insight time frame filters chart points', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StockInsightTemplatePage(
          dataService: StockInsightDataService(
            backendApi: _FakeStockInsightBackendApi(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    Text selectedLabel = tester.widget<Text>(find.text('1M'));
    LineChart chart = tester.widget<LineChart>(find.byType(LineChart));
    final int oneMonthPointCount = chart.data.lineBarsData.first.spots.length;
    expect(selectedLabel.style?.color, const Color(0xFF1A9933));

    await tester.tap(find.byKey(const ValueKey<String>('stock-timeframe-1W')));
    await tester.pumpAndSettle();

    selectedLabel = tester.widget<Text>(find.text('1W'));
    final Text unselectedLabel = tester.widget<Text>(find.text('1M'));
    chart = tester.widget<LineChart>(find.byType(LineChart));
    final int oneWeekPointCount = chart.data.lineBarsData.first.spots.length;
    expect(selectedLabel.style?.color, const Color(0xFF1A9933));
    expect(unselectedLabel.style?.color, const Color(0xFF808080));
    expect(oneWeekPointCount, lessThan(oneMonthPointCount));
  });

  testWidgets('stock insight long time frame keeps chart visually smooth', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StockInsightTemplatePage(
          dataService: StockInsightDataService(
            backendApi: _FakeStockInsightBackendApi(totalPointCount: 180),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('stock-timeframe-ALL')));
    await tester.pumpAndSettle();

    final LineChart chart = tester.widget<LineChart>(find.byType(LineChart));
    final LineChartBarData line = chart.data.lineBarsData.first;
    expect(line.spots.length, lessThanOrEqualTo(64));
    expect(line.isCurved, isTrue);
    expect(line.preventCurveOverShooting, isTrue);
  });
}

class _FakeStockInsightBackendApi implements StockInsightBackendApi {
  const _FakeStockInsightBackendApi({this.totalPointCount = 45});

  final int totalPointCount;

  @override
  Future<StockInsightViewData> fetchStockInsight({
    required String ticker,
  }) async {
    const double dayMillis = 86400000;
    final double latestDayTimestamp = DateTime.utc(
      2026,
      4,
      20,
    ).millisecondsSinceEpoch.toDouble();
    final List<PricePoint> series = List<PricePoint>.generate(totalPointCount, (
      int index,
    ) {
      final double x =
          latestDayTimestamp - ((totalPointCount - 1 - index) * dayMillis);
      return PricePoint(x: x, y: 100 + index.toDouble());
    });

    return StockInsightViewData(
      profile: const SecurityProfile(
        securityNameCn: '测试个股',
        securityNameEn: 'Test Security',
        ticker: 'TEST',
      ),
      dayLineSeries: series,
      companyCategories: const <CompanyInfoCategory>[],
      glossaryItems: const <GlossaryItem>[],
    );
  }
}
