// Last Updated: 2026-04-29
// 最后更新: 2026-04-29
//
// Module: Compound Daily Gain Widget - annualized return scenario simulator
// 模块: 复利日均收益模拟器 - 年化收益率情景测算
//
// Dependencies: dart:math, flutter/material.dart, finance_micro_widget_models
// 依赖: dart:math, flutter/material.dart, 金融小组件公式模型
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../domain/finance_micro_widget_models.dart';

class CompoundDailyGainWidget extends StatefulWidget {
  const CompoundDailyGainWidget({super.key});

  @override
  State<CompoundDailyGainWidget> createState() =>
      _CompoundDailyGainWidgetState();
}

class _CompoundDailyGainWidgetState extends State<CompoundDailyGainWidget> {
  double _principal = 10000;
  double _annualReturnRate = 0.06;
  double _years = 5;

  CompoundReturnResult get _result => CompoundReturnInput(
    principal: _principal,
    annualReturnRate: _annualReturnRate,
    years: _years,
  ).calculate();

  Future<void> _editPrincipal() async {
    final value = await _showNumberInputDialog(
      context: context,
      title: '输入本金',
      initialValue: _principal,
      min: 100,
      max: 1000000,
      suffix: '元',
    );
    if (value == null) {
      return;
    }
    setState(() => _principal = value);
  }

  Future<void> _editAnnualReturnRate() async {
    final value = await _showNumberInputDialog(
      context: context,
      title: '输入预期年化收益率',
      initialValue: _annualReturnRate * 100,
      min: 0,
      max: 30,
      suffix: '%',
    );
    if (value == null) {
      return;
    }
    setState(() => _annualReturnRate = value / 100);
  }

  Future<void> _editYears() async {
    final value = await _showNumberInputDialog(
      context: context,
      title: '输入持有年限',
      initialValue: _years,
      min: 0.1,
      max: 30,
      suffix: '年',
    );
    if (value == null) {
      return;
    }
    setState(() => _years = value);
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('复利日均收益模拟器', style: _CompoundTextStyles.title),
          const SizedBox(height: 2),
          const Text(
            'Average Daily Gain under Compounding',
            style: _CompoundTextStyles.caption,
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _ScenarioChip(
                label: _formatMoneyCompact(_principal),
                selected: true,
              ),
              _ScenarioChip(
                label: '${_formatPercent(_annualReturnRate)} 年化',
                selected: false,
              ),
              _ScenarioChip(
                label: '${_formatYears(_years)} 年',
                selected: false,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: 146,
                  child: CustomPaint(
                    painter: _CompoundCurvePainter(
                      annualReturnRate: _annualReturnRate,
                      years: _years,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  const Text('复利终值', style: _CompoundTextStyles.resultLabel),
                  Text(
                    _formatMoneyRounded(result.futureValue),
                    style: _CompoundTextStyles.futureValue,
                  ),
                  const SizedBox(height: 22),
                  const Text('日均收益金额', style: _CompoundTextStyles.greenLabel),
                  Text(
                    '${_formatMoney(result.averageDailyGain)} / 天',
                    style: _CompoundTextStyles.dailyGain,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          _ParameterSlider(
            label: '本金 Principal',
            valueLabel: _formatMoneyCompact(_principal),
            value: _principal,
            min: 100,
            max: 1000000,
            onChanged: (value) => setState(() => _principal = value),
            onEdit: _editPrincipal,
          ),
          _ParameterSlider(
            label: '预期年化收益率',
            valueLabel: _formatPercent(_annualReturnRate),
            value: _annualReturnRate,
            min: 0,
            max: 0.30,
            onChanged: (value) => setState(() => _annualReturnRate = value),
            onEdit: _editAnnualReturnRate,
          ),
          _ParameterSlider(
            label: '持有年限 Investment horizon',
            valueLabel: '${_formatYears(_years)} 年',
            value: _years,
            min: 0.1,
            max: 30,
            onChanged: (value) => setState(() => _years = value),
            onEdit: _editYears,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFB9E4C9)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('总收益 ÷ 预计持有天数', style: _CompoundTextStyles.caption),
                const SizedBox(height: 6),
                Text(
                  '${_formatMoneyRounded(result.totalGain)} ÷ '
                  '${_formatDays(result.totalDays)} 天 = '
                  '${_formatMoney(result.averageDailyGain)} / 天',
                  style: _CompoundTextStyles.breakdown,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '等效日收益率 = (1 + 年化收益率)^(1/365) - 1 '
            '≈ ${_formatPercent(result.equivalentDailyReturnRate, digits: 5)}。'
            '这是情景测算，不代表承诺收益；真实收益会波动。',
            style: _CompoundTextStyles.formula,
          ),
        ],
      ),
    );
  }
}

class _ScenarioChip extends StatelessWidget {
  const _ScenarioChip({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF1FA95B) : const Color(0xFFFFF9F0),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: selected ? const Color(0xFF188246) : const Color(0xFFDDE7D7),
          width: 1.3,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : const Color(0xFF4B5760),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ParameterSlider extends StatelessWidget {
  const _ParameterSlider({
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
                  Expanded(
                    child: Text(label, style: _CompoundTextStyles.label),
                  ),
                  Text('$valueLabel  ✎', style: _CompoundTextStyles.value),
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

class _CompoundCurvePainter extends CustomPainter {
  const _CompoundCurvePainter({
    required this.annualReturnRate,
    required this.years,
  });

  final double annualReturnRate;
  final double years;

  @override
  void paint(Canvas canvas, Size size) {
    final baselineY = size.height - 12;
    final maxValue = math.pow(1 + annualReturnRate, years).toDouble();
    final minValue = 1.0;
    final curvePath = Path();
    final fillPath = Path();

    for (var index = 0; index <= 80; index++) {
      final progress = index / 80;
      final value = math.pow(1 + annualReturnRate, progress * years).toDouble();
      final normalized = maxValue == minValue
          ? 0.0
          : (value - minValue) / (maxValue - minValue);
      final x = progress * size.width;
      final y = baselineY - normalized * (size.height - 28);
      if (index == 0) {
        curvePath.moveTo(x, y);
        fillPath.moveTo(x, baselineY);
        fillPath.lineTo(x, y);
      } else {
        curvePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath
      ..lineTo(size.width, baselineY)
      ..close();

    final fillPaint = Paint()
      ..color = const Color(0xFFE8F5E9)
      ..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = const Color(0xFF1FA95B)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 5;
    final axisPaint = Paint()
      ..color = const Color(0xFFDDE7D7)
      ..strokeWidth = 2;

    canvas
      ..drawPath(fillPath, fillPaint)
      ..drawPath(curvePath, linePaint)
      ..drawLine(
        Offset(0, baselineY),
        Offset(size.width, baselineY),
        axisPaint,
      );
  }

  @override
  bool shouldRepaint(covariant _CompoundCurvePainter oldDelegate) {
    return annualReturnRate != oldDelegate.annualReturnRate ||
        years != oldDelegate.years;
  }
}

class _CompoundTextStyles {
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

  static const TextStyle resultLabel = TextStyle(
    color: Color(0xFF23302A),
    fontSize: 16,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle futureValue = TextStyle(
    color: Color(0xFF23302A),
    fontSize: 16,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle greenLabel = TextStyle(
    color: Color(0xFF188246),
    fontSize: 16,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle dailyGain = TextStyle(
    color: Color(0xFF188246),
    fontSize: 16,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle breakdown = TextStyle(
    color: Color(0xFF188246),
    fontSize: 17,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle formula = TextStyle(
    color: Color(0xFF4B5760),
    fontSize: 11,
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

String _formatMoneyCompact(double value) {
  if (value >= 10000) {
    final wan = value / 10000;
    return '¥${wan.toStringAsFixed(wan >= 10 ? 0 : 1)}万';
  }
  return '¥${value.round()}';
}

String _formatMoneyRounded(double value) => '¥${value.round()}';

String _formatPercent(double rate, {int digits = 2}) =>
    '${(rate * 100).toStringAsFixed(digits)}%';

String _formatYears(double years) {
  if ((years - years.round()).abs() < 0.05) {
    return years.round().toString();
  }
  return years.toStringAsFixed(1);
}

String _formatDays(double days) {
  if ((days - days.round()).abs() < 0.05) {
    return days.round().toString();
  }
  return days.toStringAsFixed(1);
}
