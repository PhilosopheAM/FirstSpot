/// Last Updated: 2026-04-20
/// 最后更新: 2026-04-20
///
/// Module: Reusable stock price fluctuation chart V2 with adaptive time window.
/// 模块: 可复用的股票价格波动图 V2（含自适应时间窗口）。
///
/// Dependencies: flutter/material.dart, flutter/services.dart, fl_chart, dart:async, dart:math
/// 依赖: flutter/material.dart, flutter/services.dart, fl_chart, dart:async, dart:math
///
/// Author: Harry Chen
/// Email: 11911421@mail.sustech.edu.cn
import 'dart:async';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Rendering strategy for visible chart data.
/// 可视图表数据的渲染策略。
enum PriceSmoothingMode {
  /// Renders the visible points directly.
  /// 直接渲染当前窗口中的点。
  none,

  /// Applies LTTB downsampling for a smoother macro trend.
  /// 使用 LTTB 下采样，突出更平滑的长期趋势。
  lttb,

  /// Downsamples first, then applies a light EMA smoothing pass.
  /// 先下采样，再轻度 EMA 平滑。
  ema,
}

/// Exposes the active time window to parent widgets.
/// 向父组件暴露当前的时间窗口状态。
class PriceWindowState {
  const PriceWindowState({
    required this.minX,
    required this.maxX,
    required this.durationX,
    required this.visiblePointCount,
    required this.targetPointCount,
  });

  final double minX;
  final double maxX;
  final double durationX;
  final int visiblePointCount;
  final int targetPointCount;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is PriceWindowState &&
        other.minX == minX &&
        other.maxX == maxX &&
        other.durationX == durationX &&
        other.visiblePointCount == visiblePointCount &&
        other.targetPointCount == targetPointCount;
  }

  @override
  int get hashCode => Object.hash(
        minX,
        maxX,
        durationX,
        visiblePointCount,
        targetPointCount,
      );
}

/// Reusable price fluctuation chart for stock-like instruments.
/// 面向股票类标的的可复用价格波动图组件 V2。
class PriceFluctuationChartV2 extends StatefulWidget {
  const PriceFluctuationChartV2({
    super.key,
    required this.securityNameCn,
    required this.securityNameEn,
    required this.ticker,
    required this.spots,
    this.subtitle = '日线走势',
    this.enableGestures = true,
    this.desiredPxPerPoint = 10,
    this.minWindowDurationX,
    this.maxWindowDurationX,
    this.smoothingMode = PriceSmoothingMode.lttb,
    this.onWindowChanged,
  });

  final String securityNameCn;
  final String securityNameEn;
  final String ticker;
  final String subtitle;
  final List<FlSpot> spots;
  final bool enableGestures;
  final double desiredPxPerPoint;
  final double? minWindowDurationX;
  final double? maxWindowDurationX;
  final PriceSmoothingMode smoothingMode;
  final ValueChanged<PriceWindowState>? onWindowChanged;

  @override
  State<PriceFluctuationChartV2> createState() => _PriceFluctuationChartV2State();
}

enum _PanAxis {
  horizontal,
  vertical,
}

class _PriceFluctuationChartV2State extends State<PriceFluctuationChartV2> {
  static const double _defaultHeight = 320;
  static const double _dragDecisionThreshold = 8;
  static const double _zoomSensitivity = 0.007;
  static const double _downsamplePxPerPoint = 5;

  bool _showTicker = false;
  Timer? _copyTimer;
  bool _copiedInThisPress = false;

  late List<FlSpot> _sortedSpots;
  bool _hasWindowState = false;
  bool _hasUserAdjustedWindow = false;
  double _windowEndX = 0;
  double _windowDurationX = 0;
  double? _lastChartWidth;
  Offset _panAccumulatedDelta = Offset.zero;
  _PanAxis? _lockedPanAxis;
  PriceWindowState? _lastEmittedWindowState;

  @override
  void initState() {
    super.initState();
    _sortedSpots = _sortedCopy(widget.spots);
  }

  @override
  void didUpdateWidget(covariant PriceFluctuationChartV2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.spots != widget.spots) {
      _sortedSpots = _sortedCopy(widget.spots);
      _hasWindowState = false;
      _hasUserAdjustedWindow = false;
      _lastChartWidth = null;
      _lastEmittedWindowState = null;
    }
  }

  @override
  void dispose() {
    _copyTimer?.cancel();
    super.dispose();
  }

  /// Handles the header press gesture for ticker reveal + delayed copy.
  /// 处理图表头部按压手势：显示代码并延迟复制。
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

  /// Resets the temporary header reveal state.
  /// 重置头部的临时显示状态。
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
    final Widget content = _sortedSpots.length < 2
        ? _buildEmptyCard(message: '至少需要 2 个价格点')
        : _buildChartCard();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.hasBoundedHeight) {
          return content;
        }
        return SizedBox(height: _defaultHeight, child: content);
      },
    );
  }

  Widget _buildEmptyCard({required String message}) {
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
      child: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 14, color: Color(0xFF5E6A71)),
        ),
      ),
    );
  }

  Widget _buildChartCard() {
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
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.subtitle,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6D747A)),
                ),
              ),
              const Text(
                '横向平移 · 纵向调密度',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4C8E66),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double chartWidth = math.max(constraints.maxWidth, 1);
                _syncWindowStateForWidth(chartWidth);

                final _PreparedChartData chartData = _prepareChartData(chartWidth);
                _scheduleWindowStateEmission(chartData.windowState);

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: widget.enableGestures ? _handlePanStart : null,
                  onPanUpdate: widget.enableGestures
                      ? (DragUpdateDetails details) =>
                          _handlePanUpdate(details, chartWidth)
                      : null,
                  onPanEnd: widget.enableGestures ? _handlePanEnd : null,
                  onPanCancel: widget.enableGestures ? _handlePanCancel : null,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: <Color>[Color(0xFFF7FCF8), Color(0xFFFDFEFD)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                      child: LineChart(
                        LineChartData(
                          minX: chartData.windowState.minX,
                          maxX: chartData.windowState.maxX,
                          minY: chartData.minY,
                          maxY: chartData.maxY,
                          clipData: const FlClipData.all(),
                          lineTouchData: const LineTouchData(enabled: false),
                          borderData: FlBorderData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: chartData.horizontalInterval,
                            getDrawingHorizontalLine: (double value) => const FlLine(
                              color: Color(0x130C8A39),
                              strokeWidth: 1,
                            ),
                          ),
                          lineBarsData: <LineChartBarData>[
                            LineChartBarData(
                              spots: chartData.visibleSpots,
                              isCurved: true,
                              curveSmoothness: 0.32,
                              color: const Color(0xFF1FA95B),
                              barWidth: 3.2,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: const Color(0x221FA95B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Initializes or refreshes the adaptive time window when layout changes.
  /// 在布局变化时初始化或刷新自适应时间窗口。
  void _syncWindowStateForWidth(double chartWidth) {
    if (_sortedSpots.length < 2) {
      return;
    }

    final bool shouldInitialize = !_hasWindowState;
    final bool shouldRefreshForWidth = !_hasUserAdjustedWindow &&
        (_lastChartWidth == null || (_lastChartWidth! - chartWidth).abs() > 1);

    if (!shouldInitialize && !shouldRefreshForWidth) {
      return;
    }

    final int targetPoints = _estimateTargetPointCount(chartWidth);
    final double minX = _sortedSpots.first.x;
    final double maxX = _sortedSpots.last.x;
    final double fullSpan = math.max(maxX - minX, 1);
    final double medianDeltaX = _estimateTailMedianDeltaX(_sortedSpots);
    final double minDuration = _resolveMinDuration(fullSpan, medianDeltaX);
    final double maxDuration = _resolveMaxDuration(fullSpan);
    final double fallbackDuration = fullSpan * 0.35;
    final double suggestedDuration = medianDeltaX > 0
        ? medianDeltaX * targetPoints
        : fallbackDuration;

    _windowDurationX = _clampDouble(
      suggestedDuration,
      minDuration,
      maxDuration,
    );
    _windowEndX = maxX;
    _hasWindowState = true;
    _lastChartWidth = chartWidth;
  }

  /// Starts the pan interaction and clears the axis lock.
  /// 开始拖动并清空轴向锁定状态。
  void _handlePanStart(DragStartDetails details) {
    _panAccumulatedDelta = Offset.zero;
    _lockedPanAxis = null;
  }

  /// Maps horizontal drag to window pan and vertical drag to density changes.
  /// 将横向拖动映射为窗口平移、纵向拖动映射为密度调整。
  void _handlePanUpdate(DragUpdateDetails details, double chartWidth) {
    if (!_hasWindowState || _sortedSpots.length < 2) {
      return;
    }

    _panAccumulatedDelta += details.delta;
    _lockedPanAxis ??= _resolvePanAxis(_panAccumulatedDelta);
    if (_lockedPanAxis == null) {
      return;
    }

    final double dataMinX = _sortedSpots.first.x;
    final double dataMaxX = _sortedSpots.last.x;
    final double fullSpan = math.max(dataMaxX - dataMinX, 1);
    final double medianDeltaX = _estimateTailMedianDeltaX(_sortedSpots);
    final double minDuration = _resolveMinDuration(fullSpan, medianDeltaX);
    final double maxDuration = _resolveMaxDuration(fullSpan);

    setState(() {
      _hasUserAdjustedWindow = true;

      if (_lockedPanAxis == _PanAxis.horizontal) {
        final double dxRatio = details.delta.dx / math.max(chartWidth, 1);
        final double timeShift = -dxRatio * _windowDurationX;
        _windowEndX = _clampDouble(
          _windowEndX + timeShift,
          dataMinX + _windowDurationX,
          dataMaxX,
        );
      } else {
        final double scale = math.exp(details.delta.dy * _zoomSensitivity);
        final double previousDuration = _windowDurationX;
        _windowDurationX = _clampDouble(
          _windowDurationX * scale,
          minDuration,
          maxDuration,
        );

        final double centerX = _windowEndX - previousDuration / 2;
        final double minCenter = dataMinX + _windowDurationX / 2;
        final double maxCenter = dataMaxX - _windowDurationX / 2;
        final double clampedCenter = _clampDouble(centerX, minCenter, maxCenter);
        _windowEndX = _clampDouble(
          clampedCenter + _windowDurationX / 2,
          dataMinX + _windowDurationX,
          dataMaxX,
        );
      }
    });
  }

  /// Finalizes the current pan gesture.
  /// 结束当前拖动手势。
  void _handlePanEnd(DragEndDetails details) {
    _panAccumulatedDelta = Offset.zero;
    _lockedPanAxis = null;
  }

  /// Resets the gesture lock when the pan is cancelled.
  /// 当拖动取消时重置手势锁定状态。
  void _handlePanCancel() {
    _panAccumulatedDelta = Offset.zero;
    _lockedPanAxis = null;
  }

  _PreparedChartData _prepareChartData(double chartWidth) {
    final double minX = _windowEndX - _windowDurationX;
    final double maxX = _windowEndX;
    final List<FlSpot> windowSpots = _sliceVisibleWindow(
      _sortedSpots,
      minX,
      maxX,
    );
    final int targetPointCount = _estimateDownsampleTargetPointCount(chartWidth);
    final List<FlSpot> visibleSpots = _transformVisibleSpots(
      windowSpots,
      targetPointCount,
    );

    final double minY = visibleSpots
        .map((FlSpot spot) => spot.y)
        .reduce(math.min);
    final double maxY = visibleSpots
        .map((FlSpot spot) => spot.y)
        .reduce(math.max);
    final double spanY = maxY - minY;
    final double paddingY = spanY <= 0 ? 1.5 : math.max(spanY * 0.08, 1.2);

    return _PreparedChartData(
      visibleSpots: visibleSpots,
      minY: minY - paddingY,
      maxY: maxY + paddingY,
      horizontalInterval: _resolveHorizontalInterval(spanY <= 0 ? 4 : spanY),
      windowState: PriceWindowState(
        minX: minX,
        maxX: maxX,
        durationX: _windowDurationX,
        visiblePointCount: visibleSpots.length,
        targetPointCount: targetPointCount,
      ),
    );
  }

  /// Emits the current window to the parent only when it changed.
  /// 仅在窗口变化时向父组件回调当前状态。
  void _scheduleWindowStateEmission(PriceWindowState state) {
    if (widget.onWindowChanged == null || state == _lastEmittedWindowState) {
      return;
    }

    _lastEmittedWindowState = state;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.onWindowChanged == null) {
        return;
      }
      widget.onWindowChanged!(state);
    });
  }

  List<FlSpot> _transformVisibleSpots(List<FlSpot> spots, int targetPointCount) {
    if (spots.length <= 2) {
      return spots;
    }

    switch (widget.smoothingMode) {
      case PriceSmoothingMode.none:
        return spots;
      case PriceSmoothingMode.lttb:
        return _largestTriangleThreeBuckets(spots, targetPointCount);
      case PriceSmoothingMode.ema:
        return _applyEma(
          _largestTriangleThreeBuckets(spots, targetPointCount),
          alpha: 0.18,
        );
    }
  }

  List<FlSpot> _applyEma(List<FlSpot> spots, {required double alpha}) {
    if (spots.isEmpty) {
      return spots;
    }

    final List<FlSpot> smoothed = <FlSpot>[spots.first];
    double previousY = spots.first.y;
    for (int i = 1; i < spots.length; i++) {
      final double nextY = alpha * spots[i].y + (1 - alpha) * previousY;
      smoothed.add(FlSpot(spots[i].x, nextY));
      previousY = nextY;
    }
    return smoothed;
  }

  List<FlSpot> _largestTriangleThreeBuckets(List<FlSpot> data, int threshold) {
    if (threshold >= data.length || threshold < 3) {
      return List<FlSpot>.of(data);
    }

    final int dataLength = data.length;
    final List<FlSpot> sampled = <FlSpot>[data.first];
    final double every = (dataLength - 2) / (threshold - 2);
    int anchorIndex = 0;

    for (int i = 0; i < threshold - 2; i++) {
      final int averageRangeStart = math.min(
        ((i + 1) * every).floor() + 1,
        dataLength - 1,
      );
      final int averageRangeEnd = math.min(
        ((i + 2) * every).floor() + 1,
        dataLength,
      );
      final int averageRangeLength = math.max(averageRangeEnd - averageRangeStart, 1);

      double averageX = 0;
      double averageY = 0;
      for (int j = averageRangeStart; j < averageRangeEnd; j++) {
        averageX += data[j].x;
        averageY += data[j].y;
      }
      averageX /= averageRangeLength;
      averageY /= averageRangeLength;

      final int rangeStart = math.min((i * every).floor() + 1, dataLength - 2);
      final int rangeEnd = math.min(
        ((i + 1) * every).floor() + 1,
        dataLength - 1,
      );

      final FlSpot anchor = data[anchorIndex];
      double maxArea = -1;
      int nextAnchorIndex = rangeStart;

      for (int j = rangeStart; j < math.max(rangeEnd, rangeStart + 1); j++) {
        final double area = ((anchor.x - averageX) * (data[j].y - anchor.y) -
                (anchor.x - data[j].x) * (averageY - anchor.y))
            .abs();
        if (area > maxArea) {
          maxArea = area;
          nextAnchorIndex = j;
        }
      }

      sampled.add(data[nextAnchorIndex]);
      anchorIndex = nextAnchorIndex;
    }

    sampled.add(data.last);
    return sampled;
  }

  List<FlSpot> _sliceVisibleWindow(List<FlSpot> spots, double minX, double maxX) {
    if (spots.isEmpty) {
      return const <FlSpot>[];
    }

    int start = _lowerBound(spots, minX);
    int end = _upperBound(spots, maxX);
    if (start > 0) {
      start -= 1;
    }
    if (end < spots.length) {
      end += 1;
    }

    final List<FlSpot> sliced = spots.sublist(start, end);
    return sliced.length >= 2 ? sliced : List<FlSpot>.of(spots.take(2));
  }

  int _lowerBound(List<FlSpot> spots, double targetX) {
    int low = 0;
    int high = spots.length;
    while (low < high) {
      final int mid = low + ((high - low) >> 1);
      if (spots[mid].x < targetX) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }
    return low.clamp(0, spots.length - 1).toInt();
  }

  int _upperBound(List<FlSpot> spots, double targetX) {
    int low = 0;
    int high = spots.length;
    while (low < high) {
      final int mid = low + ((high - low) >> 1);
      if (spots[mid].x <= targetX) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }
    return low.clamp(1, spots.length).toInt();
  }

  int _estimateTargetPointCount(double chartWidth) {
    return _clampInt(
      (chartWidth / widget.desiredPxPerPoint).round(),
      40,
      80,
    );
  }

  int _estimateDownsampleTargetPointCount(double chartWidth) {
    return _clampInt(
      (chartWidth / _downsamplePxPerPoint).round(),
      80,
      240,
    );
  }

  double _estimateTailMedianDeltaX(List<FlSpot> spots) {
    if (spots.length < 2) {
      return 1;
    }

    final int startIndex = math.max(spots.length - 30, 1);
    final List<double> deltas = <double>[];
    for (int i = startIndex; i < spots.length; i++) {
      final double delta = spots[i].x - spots[i - 1].x;
      if (delta > 0) {
        deltas.add(delta);
      }
    }
    if (deltas.isEmpty) {
      return 1;
    }

    deltas.sort();
    final int mid = deltas.length ~/ 2;
    if (deltas.length.isOdd) {
      return deltas[mid];
    }
    return (deltas[mid - 1] + deltas[mid]) / 2;
  }

  double _resolveMinDuration(double fullSpan, double medianDeltaX) {
    final double fallback = math.max(fullSpan * 0.08, medianDeltaX * 18);
    final double minDuration = widget.minWindowDurationX ?? fallback;
    return _clampDouble(minDuration, math.min(1, fullSpan), fullSpan);
  }

  double _resolveMaxDuration(double fullSpan) {
    final double maxDuration = widget.maxWindowDurationX ?? fullSpan;
    return _clampDouble(maxDuration, math.min(1, fullSpan), fullSpan);
  }

  double _resolveHorizontalInterval(double spanY) {
    if (spanY <= 12) {
      return 3;
    }
    if (spanY <= 30) {
      return 6;
    }
    if (spanY <= 60) {
      return 12;
    }
    return 18;
  }

  _PanAxis? _resolvePanAxis(Offset accumulatedDelta) {
    if (accumulatedDelta.distance < _dragDecisionThreshold) {
      return null;
    }
    return accumulatedDelta.dx.abs() >= accumulatedDelta.dy.abs()
        ? _PanAxis.horizontal
        : _PanAxis.vertical;
  }

  List<FlSpot> _sortedCopy(List<FlSpot> spots) {
    final List<FlSpot> copy = List<FlSpot>.of(spots);
    copy.sort((FlSpot a, FlSpot b) => a.x.compareTo(b.x));
    return copy;
  }

  double _clampDouble(double value, double minValue, double maxValue) {
    if (maxValue < minValue) {
      return minValue;
    }
    return value.clamp(minValue, maxValue).toDouble();
  }

  int _clampInt(int value, int minValue, int maxValue) {
    if (maxValue < minValue) {
      return minValue;
    }
    return value.clamp(minValue, maxValue).toInt();
  }
}

class _PreparedChartData {
  const _PreparedChartData({
    required this.visibleSpots,
    required this.minY,
    required this.maxY,
    required this.horizontalInterval,
    required this.windowState,
  });

  final List<FlSpot> visibleSpots;
  final double minY;
  final double maxY;
  final double horizontalInterval;
  final PriceWindowState windowState;
}
