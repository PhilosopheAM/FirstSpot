// Last Updated: 2026-05-21
// 最后更新: 2026-05-21
//
// Module: Portfolio repository - local persistence via SharedPreferences
// 模块: 持仓仓储 - 使用 SharedPreferences 本地持久化
//
// Dependencies: dart:convert, shared_preferences, portfolio_models, portfolio_demo_seed
// 依赖: dart:convert, shared_preferences, portfolio_models, portfolio_demo_seed
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/portfolio_models.dart';
import 'portfolio_demo_seed.dart';

const String _holdingsJsonKey = 'portfolio.holdings_json_v1';

/// Loads and saves [PortfolioHolding] list as JSON.
/// 以 JSON 读写 [PortfolioHolding] 列表。
class PortfolioRepository {
  /// When true, first empty load seeds [buildPortfolioDemoHoldings].
  /// 为 true 时，首次空列表加载会注入演示持仓。
  const PortfolioRepository({this.seedDemoOnFirstEmpty = true});

  final bool seedDemoOnFirstEmpty;

  Future<List<PortfolioHolding>> loadHoldings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_holdingsJsonKey);
    if (raw == null || raw.isEmpty) {
      return _maybeSeedDemo(prefs);
    }
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      final List<PortfolioHolding> holdings = list
          .map(
            (dynamic e) =>
                PortfolioHolding.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      if (holdings.isEmpty) {
        return _maybeSeedDemo(prefs);
      }
      return holdings;
    } catch (_) {
      return _maybeSeedDemo(prefs);
    }
  }

  Future<List<PortfolioHolding>> _maybeSeedDemo(SharedPreferences prefs) async {
    if (!seedDemoOnFirstEmpty) {
      return <PortfolioHolding>[];
    }
    if (prefs.getBool(portfolioDemoSeededPrefKey) == true) {
      return <PortfolioHolding>[];
    }
    final List<PortfolioHolding> demo = buildPortfolioDemoHoldings();
    await saveHoldings(demo);
    await prefs.setBool(portfolioDemoSeededPrefKey, true);
    return demo;
  }

  Future<void> saveHoldings(List<PortfolioHolding> holdings) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      holdings.map((PortfolioHolding h) => h.toJson()).toList(),
    );
    await prefs.setString(_holdingsJsonKey, encoded);
  }

  /// Clears holdings and demo-seed flag (for tests / manual reset).
  /// 清空持仓并重置演示种子标记（测试或手动重置用）。
  Future<void> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_holdingsJsonKey);
    await prefs.remove(portfolioDemoSeededPrefKey);
  }
}
