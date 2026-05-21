// Last Updated: 2026-05-21
// 最后更新: 2026-05-21
//
// Module: Portfolio market data service - loads mock daily closes from assets
// 模块: 持仓行情数据服务 - 从 assets 加载 mock 日线收盘价
//
// Dependencies: dart:convert, flutter/services.dart
// 依赖: dart:convert, flutter/services.dart
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'dart:convert';

import 'package:flutter/services.dart';

/// One daily close point for sparkline rendering.
/// 走势折线图用的日收盘点。
class PortfolioDailyClose {
  const PortfolioDailyClose({required this.date, required this.close});

  final DateTime date;
  final double close;
}

/// Loads bundled mock OHLC JSON (`assets/mock_data/{code}_daily.json`).
/// 读取打包的 mock 日线 JSON。
class PortfolioMarketDataService {
  const PortfolioMarketDataService();

  static final Map<String, List<PortfolioDailyClose>> _cache =
      <String, List<PortfolioDailyClose>>{};

  /// Normalizes `600519.SH` / `600519` to six-digit code.
  /// 将 `600519.SH` 规范为六位代码。
  static String normalizeSymbolCode(String symbol) {
    final String trimmed = symbol.trim().toUpperCase();
    final int dot = trimmed.indexOf('.');
    if (dot > 0) {
      return trimmed.substring(0, dot);
    }
    return trimmed.length >= 6 ? trimmed.substring(0, 6) : trimmed;
  }

  Future<List<PortfolioDailyClose>> loadDailyCloses(String symbol) async {
    final String code = normalizeSymbolCode(symbol);
    final List<PortfolioDailyClose>? cached = _cache[code];
    if (cached != null) {
      return cached;
    }

    try {
      final String raw = await rootBundle.loadString(
        'assets/mock_data/${code}_daily.json',
      );
      final Map<String, dynamic> root =
          jsonDecode(raw) as Map<String, dynamic>;
      final List<dynamic> dataList = root['data'] as List<dynamic>;
      final List<PortfolioDailyClose> series = dataList
          .map((dynamic item) {
            final Map<String, dynamic> row = item as Map<String, dynamic>;
            return PortfolioDailyClose(
              date: DateTime.parse(row['date'] as String),
              close: (row['close'] as num).toDouble(),
            );
          })
          .toList();
      _cache[code] = series;
      return series;
    } catch (_) {
      return <PortfolioDailyClose>[];
    }
  }

  /// Last [maxPoints] closes on/after [since] for detail sparkline.
  /// 详情页走势：自 [since] 起最多 [maxPoints] 个收盘点。
  Future<List<PortfolioDailyClose>> loadSparklineSeries({
    required String symbol,
    required DateTime since,
    int maxPoints = 60,
  }) async {
    final List<PortfolioDailyClose> all = await loadDailyCloses(symbol);
    if (all.isEmpty) {
      return all;
    }
    final DateTime sinceDay = DateTime(since.year, since.month, since.day);
    final List<PortfolioDailyClose> filtered = all
        .where(
          (PortfolioDailyClose p) =>
              !p.date.isBefore(sinceDay),
        )
        .toList();
    final List<PortfolioDailyClose> source =
        filtered.isNotEmpty ? filtered : all;
    if (source.length <= maxPoints) {
      return source;
    }
    return source.sublist(source.length - maxPoints);
  }
}
