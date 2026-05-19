// Last Updated: 2026-05-19
// 最后更新: 2026-05-19
//
// Module: Portfolio format helpers - CNY and percent display
// 模块: 持仓格式化 - 人民币与百分比展示
//
// Dependencies: none
// 依赖: 无
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

/// Formats amount in CNY with grouping.
/// 格式化为人民币金额字符串。
String formatPortfolioCny(double value, {bool showSign = false}) {
  final bool negative = value < 0;
  final double abs = value.abs();
  final String body = abs >= 10000
      ? '${(abs / 10000).toStringAsFixed(abs >= 100000 ? 1 : 2)} 万'
      : _groupDigits(abs.toStringAsFixed(abs < 1 ? 2 : (abs % 1 == 0 ? 0 : 2)));
  final String prefix = showSign
      ? (negative ? '-¥ ' : (value > 0 ? '+¥ ' : '¥ '))
      : (negative ? '-¥ ' : '¥ ');
  return '$prefix$body';
}

String _groupDigits(String raw) {
  final List<String> parts = raw.split('.');
  final String intPart = parts[0];
  final StringBuffer buf = StringBuffer();
  for (int i = 0; i < intPart.length; i++) {
    if (i > 0 && (intPart.length - i) % 3 == 0) {
      buf.write(',');
    }
    buf.write(intPart[i]);
  }
  if (parts.length > 1) {
    buf.write('.');
    buf.write(parts[1]);
  }
  return buf.toString();
}

/// Formats fraction as percent string e.g. 38.2%.
/// 将小数格式化为百分比字符串。
String formatPortfolioPercent(double fraction, {int digits = 1}) {
  return '${(fraction * 100).toStringAsFixed(digits)}%';
}

/// Formats signed percent for day change.
/// 格式化带符号的日涨跌幅。
String formatSignedDayChange(double fraction) {
  final String sign = fraction > 0 ? '+' : '';
  return '$sign${(fraction * 100).toStringAsFixed(1)}%';
}
