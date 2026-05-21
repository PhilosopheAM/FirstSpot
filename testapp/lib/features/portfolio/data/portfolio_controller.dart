// Last Updated: 2026-05-21
// 最后更新: 2026-05-21
//
// Module: Portfolio controller - in-memory holdings with notify + persistence
// 模块: 持仓控制器 - 内存态持仓、通知刷新与持久化
//
// Dependencies: flutter/foundation.dart, portfolio_models, portfolio_calculator, portfolio_repository
// 依赖: flutter/foundation.dart, portfolio_models, portfolio_calculator, portfolio_repository
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/foundation.dart';

import '../domain/portfolio_calculator.dart';
import '../domain/portfolio_models.dart';
import 'portfolio_repository.dart';

final PortfolioController portfolioController = PortfolioController();

/// App-wide holdings state for portfolio feature.
/// 持仓功能的全局状态。
class PortfolioController extends ChangeNotifier {
  PortfolioController({PortfolioRepository? repository})
    : _repository = repository ?? PortfolioRepository();

  final PortfolioRepository _repository;
  final List<PortfolioHolding> _holdings = <PortfolioHolding>[];
  bool _loaded = false;
  bool _loading = false;

  List<PortfolioHolding> get holdings =>
      List<PortfolioHolding>.unmodifiable(_holdings);

  bool get isLoaded => _loaded;

  PortfolioSummary get summary => PortfolioCalculator.summarize(_holdings);

  Future<void> load() async {
    if (_loaded || _loading) {
      return;
    }
    _loading = true;
    try {
      _holdings
        ..clear()
        ..addAll(await _repository.loadHoldings());
      _loaded = true;
      notifyListeners();
    } finally {
      _loading = false;
    }
  }

  Future<void> upsert(PortfolioHolding holding) async {
    final int index = _holdings.indexWhere(
      (PortfolioHolding h) => h.id == holding.id,
    );
    if (index >= 0) {
      _holdings[index] = holding;
    } else {
      _holdings.add(holding);
    }
    await _persist();
  }

  Future<void> remove(String id) async {
    _holdings.removeWhere((PortfolioHolding h) => h.id == id);
    await _persist();
  }

  Future<void> _persist() async {
    await _repository.saveHoldings(_holdings);
    notifyListeners();
  }
}
