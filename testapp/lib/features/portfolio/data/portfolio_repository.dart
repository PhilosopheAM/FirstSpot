// Last Updated: 2026-05-19
// 最后更新: 2026-05-19
//
// Module: Portfolio repository - local persistence via SharedPreferences
// 模块: 持仓仓储 - 使用 SharedPreferences 本地持久化
//
// Dependencies: dart:convert, shared_preferences, portfolio_models
// 依赖: dart:convert, shared_preferences, portfolio_models
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/portfolio_models.dart';

const String _holdingsJsonKey = 'portfolio.holdings_json_v1';

/// Loads and saves [PortfolioHolding] list as JSON.
/// 以 JSON 读写 [PortfolioHolding] 列表。
class PortfolioRepository {
  Future<List<PortfolioHolding>> loadHoldings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_holdingsJsonKey);
    if (raw == null || raw.isEmpty) {
      return <PortfolioHolding>[];
    }
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .map(
            (dynamic e) =>
                PortfolioHolding.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return <PortfolioHolding>[];
    }
  }

  Future<void> saveHoldings(List<PortfolioHolding> holdings) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      holdings.map((PortfolioHolding h) => h.toJson()).toList(),
    );
    await prefs.setString(_holdingsJsonKey, encoded);
  }
}
