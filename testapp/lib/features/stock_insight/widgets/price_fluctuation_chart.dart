/// Last Updated: 2026-03-05
/// 最后更新: 2026-03-05
///
/// Module: Reusable stock price fluctuation chart with gesture interactions.
/// 模块: 可复用的股票价格波动图组件（含手势交互）。
///
/// Dependencies: flutter/material.dart, flutter/services.dart, fl_chart, dart:async
/// 依赖: flutter/material.dart, flutter/services.dart, fl_chart, dart:async
///
/// Author: Harry Chen
/// Email: 11911421@mail.sustech.edu.cn
import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Reusable price fluctuation chart for stock-like instruments.
/// 面向股票类标的的可复用价格波动图组件。
class PriceFluctuationChart extends StatefulWidget {
  const PriceFluctuationChart({
    super.key,
    required this.securityNameCn,
    required this.securityNameEn,
    required this.ticker,
    required this.spots,
    this.subtitle = '日线走势',
  });

  final String securityNameCn;
  final String securityNameEn;
  final String ticker;
  final String subtitle;
  final List<FlSpot> spots;

  @override
  State<PriceFluctuationChart> createState() => _PriceFluctuationChartState();
}

class _PriceFluctuationChartState extends State<PriceFluctuationChart> {
  bool _showTicker = false;
  Timer? _copyTimer;
  bool _copiedInThisPress = false;

  @override
  void dispose() {
    _copyTimer?.cancel();
    super.dispose();
  }

  void _handlePressStart() {
    _copyTimer?.cancel();
    _copiedInThisPress = false;

    setState(() {
      _showTicker = true;
    });

    // Requires a 2-second hold before copying symbol text.
    // 需要连续长按 2 秒后才会触发复制。
    _copyTimer = Timer(const Duration(seconds: 2), () async {
      if (!mounted || _copiedInThisPress) {
        return;
      }
      _copiedInThisPress = true;
      final String payload =
          '${widget.securityNameCn} ${widget.securityNameEn} (${widget.ticker})';
      await Clipboard.setData(ClipboardData(text: payload));
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已复制：名称 + 代码')),
      );
    });
  }

  void _handlePressEnd() {
    _copyTimer?.cancel();
    if (!mounted) {
      return;
    }
    setState(() {
      _showTicker = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.spots.isEmpty) {
      return Container(
        margin: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x1A1FA95B),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            '暂无价格数据',
            style: TextStyle(fontSize: 14, color: Color(0xFF5E6A71)),
          ),
        ),
      );
    }

    final double minY = widget.spots
            .map((FlSpot spot) => spot.y)
            .reduce((double a, double b) => a < b ? a : b) -
        6;
    final double maxY = widget.spots
            .map((FlSpot spot) => spot.y)
            .reduce((double a, double b) => a > b ? a : b) +
        6;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x1A1FA95B),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => _handlePressStart(),
            onTapUp: (_) => _handlePressEnd(),
            onTapCancel: _handlePressEnd,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: Text(
                      _showTicker
                          ? widget.ticker
                          : '${widget.securityNameCn} / ${widget.securityNameEn}',
                      key: ValueKey<String>(
                        _showTicker ? widget.ticker : widget.securityNameCn,
                      ),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF17212A),
                      ),
                    ),
                  ),
                ),
                const Icon(Icons.touch_app_rounded, size: 18, color: Color(0xFF4E5A61)),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.subtitle,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6D747A)),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                minX: widget.spots.first.x,
                maxX: widget.spots.last.x,
                minY: minY,
                maxY: maxY,
                clipData: const FlClipData.all(),
                lineTouchData: const LineTouchData(enabled: false),
                borderData: FlBorderData(show: false),
                titlesData: const FlTitlesData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 15,
                  getDrawingHorizontalLine: (double value) => const FlLine(
                    color: Color(0x130C8A39),
                    strokeWidth: 1,
                  ),
                ),
                lineBarsData: <LineChartBarData>[
                  LineChartBarData(
                    spots: widget.spots,
                    isCurved: true,
                    curveSmoothness: 0.34,
                    color: const Color(0xFF1FA95B),
                    barWidth: 3.2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0x801FA95B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
