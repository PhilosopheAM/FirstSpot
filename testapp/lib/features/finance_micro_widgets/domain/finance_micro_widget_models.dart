// Last Updated: 2026-04-29
// 最后更新: 2026-04-29
//
// Module: Finance micro widget formula models - holds cost and compound math
// 模块: 金融小组件公式模型 - 维护持有成本与复利收益计算
//
// Dependencies: dart:math
// 依赖: dart:math
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'dart:math' as math;

/// Input values for estimating fund holding cost.
/// 基金持有成本估算输入值。
class HoldingCostInput {
  const HoldingCostInput({
    required this.principal,
    required this.managementFeeRate,
    required this.custodianFeeRate,
    required this.salesServiceFeeRate,
    required this.holdingDays,
  });

  final double principal;
  final double managementFeeRate;
  final double custodianFeeRate;
  final double salesServiceFeeRate;
  final int holdingDays;

  double get ongoingChargeRate =>
      managementFeeRate + custodianFeeRate + salesServiceFeeRate;

  HoldingCostResult calculate() {
    final totalCost = principal * ongoingChargeRate * holdingDays / 365;
    return HoldingCostResult(
      input: this,
      managementCost: principal * managementFeeRate * holdingDays / 365,
      custodianCost: principal * custodianFeeRate * holdingDays / 365,
      salesServiceCost: principal * salesServiceFeeRate * holdingDays / 365,
      totalCost: totalCost,
      holdingPeriodRate: ongoingChargeRate * holdingDays / 365,
    );
  }
}

/// Result values for fund holding cost estimation.
/// 基金持有成本估算结果。
class HoldingCostResult {
  const HoldingCostResult({
    required this.input,
    required this.managementCost,
    required this.custodianCost,
    required this.salesServiceCost,
    required this.totalCost,
    required this.holdingPeriodRate,
  });

  final HoldingCostInput input;
  final double managementCost;
  final double custodianCost;
  final double salesServiceCost;
  final double totalCost;
  final double holdingPeriodRate;
}

/// Input values for a compound return scenario.
/// 复利收益情景测算输入值。
class CompoundReturnInput {
  const CompoundReturnInput({
    required this.principal,
    required this.annualReturnRate,
    required this.years,
  });

  final double principal;
  final double annualReturnRate;
  final double years;

  CompoundReturnResult calculate() {
    final futureValue = principal * math.pow(1 + annualReturnRate, years);
    final totalGain = futureValue - principal;
    final totalDays = years * 365;
    return CompoundReturnResult(
      input: this,
      futureValue: futureValue.toDouble(),
      totalGain: totalGain.toDouble(),
      totalDays: totalDays,
      averageDailyGain: totalGain / totalDays,
      equivalentDailyReturnRate:
          math.pow(1 + annualReturnRate, 1 / 365).toDouble() - 1,
    );
  }
}

/// Result values for the compound return scenario.
/// 复利收益情景测算结果。
class CompoundReturnResult {
  const CompoundReturnResult({
    required this.input,
    required this.futureValue,
    required this.totalGain,
    required this.totalDays,
    required this.averageDailyGain,
    required this.equivalentDailyReturnRate,
  });

  final CompoundReturnInput input;
  final double futureValue;
  final double totalGain;
  final double totalDays;
  final double averageDailyGain;
  final double equivalentDailyReturnRate;
}
