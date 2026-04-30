// Last Updated: 2026-04-29
// 最后更新: 2026-04-29
//
// Module: Effective Holding Cost Widget - interactive fund cost estimator
// 模块: 基金真实持有成本估算器 - 可交互基金费率成本测算
//
// Dependencies: flutter/material.dart, finance_micro_widget_models
// 依赖: flutter/material.dart, 金融小组件公式模型
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

import '../domain/finance_micro_widget_models.dart';

class EffectiveHoldingCostWidget extends StatefulWidget {
  const EffectiveHoldingCostWidget({super.key});

  @override
  State<EffectiveHoldingCostWidget> createState() =>
      _EffectiveHoldingCostWidgetState();
}

class _EffectiveHoldingCostWidgetState
    extends State<EffectiveHoldingCostWidget> {
  static const double _principal = 10000;

  double _managementFeeRate = 0.012;
  double _custodianFeeRate = 0.002;
  double _salesServiceFeeRate = 0.004;
  double _holdingDays = 72;

  HoldingCostResult get _result => HoldingCostInput(
    principal: _principal,
    managementFeeRate: _managementFeeRate,
    custodianFeeRate: _custodianFeeRate,
    salesServiceFeeRate: _salesServiceFeeRate,
    holdingDays: _holdingDays.round(),
  ).calculate();

  bool get _isCostSensitive => _result.holdingPeriodRate >= 0.01;

  void _resetToFigmaOverview() {
    setState(() {
      _managementFeeRate = 0.012;
      _custodianFeeRate = 0.002;
      _salesServiceFeeRate = 0.004;
      _holdingDays = 72;
    });
  }

  Future<void> _editPercentValue({
    required String title,
    required double currentRate,
    required double minRate,
    required double maxRate,
    required ValueChanged<double> onSubmitted,
  }) async {
    final value = await _showNumberInputDialog(
      context: context,
      title: title,
      initialValue: currentRate * 100,
      min: minRate * 100,
      max: maxRate * 100,
      suffix: '%',
    );
    if (value == null) {
      return;
    }
    if (!mounted) {
      return;
    }
    setState(() => onSubmitted(value / 100));
  }

  Future<void> _editDaysValue() async {
    final value = await _showNumberInputDialog(
      context: context,
      title: '输入持有期',
      initialValue: _holdingDays,
      min: 1,
      max: 3650,
      suffix: '天',
    );
    if (value == null) {
      return;
    }
    if (!mounted) {
      return;
    }
    setState(() => _holdingDays = value);
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    final resultColor = _isCostSensitive
        ? const Color(0xFFE53333)
        : const Color(0xFF188246);
    final resultBackground = _isCostSensitive
        ? const Color(0xFFFFECEC)
        : const Color(0xFFE8F5E9);
    final resultBorder = _isCostSensitive
        ? const Color(0xFFF3B6B6)
        : const Color(0xFFB9E4C9);

    return _FinanceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('基金真实持有成本估算器', style: _FinanceTextStyles.title),
                    SizedBox(height: 2),
                    Text(
                      'Effective Holding Cost',
                      style: _FinanceTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: resultBackground,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: resultBorder),
                ),
                child: Text(
                  _formatMoney(result.totalCost),
                  style: TextStyle(
                    color: resultColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _RateSlider(
            label: '管理费率 Management fee',
            valueLabel: _formatPercent(_managementFeeRate),
            value: _managementFeeRate,
            min: 0,
            max: 0.03,
            onChanged: (value) => setState(() => _managementFeeRate = value),
            onEdit: () => _editPercentValue(
              title: '输入管理费率',
              currentRate: _managementFeeRate,
              minRate: 0,
              maxRate: 0.03,
              onSubmitted: (value) => _managementFeeRate = value,
            ),
          ),
          _RateSlider(
            label: '托管费率 Custodian fee',
            valueLabel: _formatPercent(_custodianFeeRate),
            value: _custodianFeeRate,
            min: 0,
            max: 0.006,
            onChanged: (value) => setState(() => _custodianFeeRate = value),
            onEdit: () => _editPercentValue(
              title: '输入托管费率',
              currentRate: _custodianFeeRate,
              minRate: 0,
              maxRate: 0.006,
              onSubmitted: (value) => _custodianFeeRate = value,
            ),
          ),
          _RateSlider(
            label: '销售服务费 Sales service',
            valueLabel: _formatPercent(_salesServiceFeeRate),
            value: _salesServiceFeeRate,
            min: 0,
            max: 0.01,
            onChanged: (value) => setState(() => _salesServiceFeeRate = value),
            onEdit: () => _editPercentValue(
              title: '输入销售服务费率',
              currentRate: _salesServiceFeeRate,
              minRate: 0,
              maxRate: 0.01,
              onSubmitted: (value) => _salesServiceFeeRate = value,
            ),
          ),
          _RateSlider(
            label: '持有期 Holding period',
            valueLabel: '${_holdingDays.round()} 天',
            value: _holdingDays,
            min: 1,
            max: 3650,
            onChanged: (value) => setState(() => _holdingDays = value),
            onEdit: _editDaysValue,
          ),
          const SizedBox(height: 10),
          _FeeStackBar(result: result, isCostSensitive: _isCostSensitive),
          const SizedBox(height: 6),
          Text(
            '持有期费用 = 本金 × 持续性费率 × 持有天数 / 365；'
            '当前折算成本率 ${_formatPercent(result.holdingPeriodRate)}',
            style: _FinanceTextStyles.formula,
          ),
          if (_isCostSensitive) ...<Widget>[
            const SizedBox(height: 14),
            const _MyoInsightBox(),
          ],
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _resetToFigmaOverview,
              child: const Text('复位默认费率'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RateSlider extends StatelessWidget {
  const _RateSlider({
    required this.label,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.onEdit,
  });

  final String label;
  final String valueLabel;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: onEdit,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text(label, style: _FinanceTextStyles.label)),
                  Text('$valueLabel  ✎', style: _FinanceTextStyles.value),
                ],
              ),
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF1FA95B),
              inactiveTrackColor: const Color(0xFFDCEBE1),
              thumbColor: Colors.white,
              overlayColor: const Color(0x331FA95B),
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 10,
                elevation: 4,
              ),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeeStackBar extends StatelessWidget {
  const _FeeStackBar({required this.result, required this.isCostSensitive});

  final HoldingCostResult result;
  final bool isCostSensitive;

  @override
  Widget build(BuildContext context) {
    final total = result.totalCost;
    final managementRatio = _ratio(result.managementCost, total);
    final custodianRatio = _ratio(result.custodianCost, total);
    final salesRatio = _ratio(result.salesServiceCost, total);
    final managementColor = isCostSensitive
        ? const Color(0xFFE53333)
        : const Color(0xFF1FA95B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final managementWidth = width * managementRatio;
            final custodianWidth = width * custodianRatio;
            final salesWidth = width * salesRatio;

            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 20,
                width: double.infinity,
                child: Stack(
                  children: <Widget>[
                    const Positioned.fill(
                      child: ColoredBox(color: Color(0xFFE8F5E9)),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      width: managementWidth,
                      child: ColoredBox(color: managementColor),
                    ),
                    Positioned(
                      left: managementWidth,
                      top: 0,
                      bottom: 0,
                      width: custodianWidth,
                      child: const ColoredBox(color: Color(0xFF55B7FF)),
                    ),
                    Positioned(
                      left: managementWidth + custodianWidth,
                      top: 0,
                      bottom: 0,
                      width: salesWidth,
                      child: const ColoredBox(color: Color(0xFFFFB547)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            _FeeLegendChip(
              label: '管理费',
              color: managementColor,
              percent: managementRatio,
            ),
            _FeeLegendChip(
              label: '托管费',
              color: const Color(0xFF55B7FF),
              percent: custodianRatio,
            ),
            _FeeLegendChip(
              label: '销售服务',
              color: const Color(0xFFFFB547),
              percent: salesRatio,
            ),
          ],
        ),
      ],
    );
  }

  double _ratio(double value, double total) {
    if (total <= 0) {
      return 0;
    }
    return (value / total).clamp(0, 1);
  }
}

class _FeeLegendChip extends StatelessWidget {
  const _FeeLegendChip({
    required this.label,
    required this.color,
    required this.percent,
  });

  final String label;
  final Color color;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            '$label ${_formatPercent(percent, digits: 1)}',
            style: const TextStyle(
              color: Color(0xFF4B5760),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MyoInsightBox extends StatelessWidget {
  const _MyoInsightBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFB547), width: 1.4),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('ᓚᘏᗢ', style: TextStyle(fontSize: 24)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Myo 提醒：持续性费率会每天扣一点，持有期越长，'
              '管理费、托管费和销售服务费越影响净收益。',
              style: _FinanceTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinanceCard extends StatelessWidget {
  const _FinanceCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE6E8EC), width: 1.4),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FinanceTextStyles {
  static const TextStyle title = TextStyle(
    color: Color(0xFF23302A),
    fontSize: 20,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle caption = TextStyle(
    color: Color(0xFF4B5760),
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle label = TextStyle(
    color: Color(0xFF4B5760),
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle value = TextStyle(
    color: Color(0xFF23302A),
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle formula = TextStyle(
    color: Color(0xFF4B5760),
    fontSize: 11,
    height: 1.45,
  );

  static const TextStyle body = TextStyle(
    color: Color(0xFF4B5760),
    fontSize: 13,
    height: 1.45,
  );
}

Future<double?> _showNumberInputDialog({
  required BuildContext context,
  required String title,
  required double initialValue,
  required double min,
  required double max,
  required String suffix,
}) async {
  return showDialog<double>(
    context: context,
    builder: (context) => _NumberInputDialog(
      title: title,
      initialValue: initialValue,
      min: min,
      max: max,
      suffix: suffix,
    ),
  );
}

class _NumberInputDialog extends StatefulWidget {
  const _NumberInputDialog({
    required this.title,
    required this.initialValue,
    required this.min,
    required this.max,
    required this.suffix,
  });

  final String title;
  final double initialValue;
  final double min;
  final double max;
  final String suffix;

  @override
  State<_NumberInputDialog> createState() => _NumberInputDialogState();
}

class _NumberInputDialogState extends State<_NumberInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue.toStringAsFixed(
        widget.initialValue >= 10 ? 0 : 2,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final parsed = double.tryParse(_controller.text.trim());
    if (parsed == null) {
      return;
    }
    Navigator.of(context).pop(parsed.clamp(widget.min, widget.max).toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          suffixText: widget.suffix,
          helperText:
              '范围：${widget.min.toStringAsFixed(2)} - '
              '${widget.max.toStringAsFixed(2)}',
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(onPressed: _submit, child: const Text('确认')),
      ],
    );
  }
}

String _formatMoney(double value) => '¥${value.toStringAsFixed(2)}';

String _formatPercent(double rate, {int digits = 2}) =>
    '${(rate * 100).toStringAsFixed(digits)}%';
