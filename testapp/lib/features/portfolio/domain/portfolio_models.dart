// Last Updated: 2026-05-19
// 最后更新: 2026-05-19
//
// Module: Portfolio domain models - holdings, asset types, portfolio aggregates
// 模块: 持仓领域模型 - 持仓记录、资产类型、组合汇总
//
// Dependencies: dart:convert (serialization only in repository)
// 依赖: dart:convert（序列化在 repository 中完成）
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

/// Asset category for manual holdings.
/// 手动持仓的资产大类。
enum PortfolioAssetType {
  stock('stock', '股票'),
  fund('fund', '基金（含 ETF）'),
  cash('cash', '现金类'),
  other('other', '其他');

  const PortfolioAssetType(this.storageKey, this.labelZh);

  final String storageKey;
  final String labelZh;

  static PortfolioAssetType fromStorageKey(String key) {
    return PortfolioAssetType.values.firstWhere(
      (PortfolioAssetType t) => t.storageKey == key,
      orElse: () => PortfolioAssetType.other,
    );
  }
}

/// Sort mode for the holdings list on overview.
/// 总览页持仓列表的排序方式。
enum PortfolioSortMode {
  byWeight('按权重'),
  byValue('按市值'),
  byDayChange('按今日涨跌'),
  byName('按名称');

  const PortfolioSortMode(this.labelZh);

  final String labelZh;
}

/// A single manually recorded position (net holding snapshot).
/// 一条手动录入的净持仓快照。
class PortfolioHolding {
  const PortfolioHolding({
    required this.id,
    required this.assetType,
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.costPrice,
    required this.tradeDate,
    this.lastPrice,
    this.note,
    this.dayChangePercent,
  });

  final String id;
  final PortfolioAssetType assetType;
  final String symbol;
  final String name;
  final double quantity;
  final double costPrice;
  final DateTime tradeDate;
  final double? lastPrice;
  final String? note;

  /// Optional mock day change for demo when no market feed; null = 0%.
  /// 无行情时的演示日涨跌（百分比），null 视为 0。
  final double? dayChangePercent;

  double get effectiveLastPrice => lastPrice ?? costPrice;

  double get marketValue => effectiveLastPrice * quantity;

  double get costBasisTotal => costPrice * quantity;

  double get profitLossAmount => marketValue - costBasisTotal;

  double? get profitLossPercent {
    if (costBasisTotal <= 0) {
      return null;
    }
    return profitLossAmount / costBasisTotal;
  }

  double get dayChangePercentOrZero => dayChangePercent ?? 0;

  PortfolioHolding copyWith({
    String? id,
    PortfolioAssetType? assetType,
    String? symbol,
    String? name,
    double? quantity,
    double? costPrice,
    DateTime? tradeDate,
    double? lastPrice,
    String? note,
    double? dayChangePercent,
    bool clearLastPrice = false,
    bool clearNote = false,
    bool clearDayChange = false,
  }) {
    return PortfolioHolding(
      id: id ?? this.id,
      assetType: assetType ?? this.assetType,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      costPrice: costPrice ?? this.costPrice,
      tradeDate: tradeDate ?? this.tradeDate,
      lastPrice: clearLastPrice ? null : (lastPrice ?? this.lastPrice),
      note: clearNote ? null : (note ?? this.note),
      dayChangePercent:
          clearDayChange ? null : (dayChangePercent ?? this.dayChangePercent),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'assetType': assetType.storageKey,
    'symbol': symbol,
    'name': name,
    'quantity': quantity,
    'costPrice': costPrice,
    'tradeDate': tradeDate.toIso8601String(),
    'lastPrice': lastPrice,
    'note': note,
    'dayChangePercent': dayChangePercent,
  };

  factory PortfolioHolding.fromJson(Map<String, dynamic> json) {
    return PortfolioHolding(
      id: json['id'] as String,
      assetType: PortfolioAssetType.fromStorageKey(json['assetType'] as String),
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      costPrice: (json['costPrice'] as num).toDouble(),
      tradeDate: DateTime.parse(json['tradeDate'] as String),
      lastPrice: (json['lastPrice'] as num?)?.toDouble(),
      note: json['note'] as String?,
      dayChangePercent: (json['dayChangePercent'] as num?)?.toDouble(),
    );
  }
}

/// Allocation slice by asset type for stacked bar / legend.
/// 按资产类型划分的占比切片。
class PortfolioAllocationSlice {
  const PortfolioAllocationSlice({
    required this.assetType,
    required this.value,
    required this.fraction,
  });

  final PortfolioAssetType assetType;
  final double value;
  final double fraction;
}

/// Computed portfolio summary for overview hero and charts.
/// 总览页用的组合汇总计算结果。
class PortfolioSummary {
  const PortfolioSummary({
    required this.holdings,
    required this.totalMarketValue,
    required this.totalCostBasis,
    required this.totalProfitLoss,
    required this.totalProfitLossPercent,
    required this.allocationSlices,
    required this.top1Weight,
    required this.top3CumulativeWeight,
    required this.positionCount,
  });

  final List<PortfolioHolding> holdings;
  final double totalMarketValue;
  final double totalCostBasis;
  final double totalProfitLoss;
  final double? totalProfitLossPercent;
  final List<PortfolioAllocationSlice> allocationSlices;
  final double top1Weight;
  final double top3CumulativeWeight;
  final int positionCount;

  bool get isEmpty => holdings.isEmpty;

  double weightOf(PortfolioHolding holding) {
    if (totalMarketValue <= 0) {
      return 0;
    }
    return holding.marketValue / totalMarketValue;
  }
}
