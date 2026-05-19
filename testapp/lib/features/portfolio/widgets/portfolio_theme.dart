// Last Updated: 2026-05-19
// 最后更新: 2026-05-19
//
// Module: Portfolio theme tokens - colors aligned with Figma V1 prototype
// 模块: 持仓主题色 - 对齐 Figma V1 原型
//
// Dependencies: flutter/material.dart
// 依赖: flutter/material.dart
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

import '../domain/portfolio_models.dart';

/// Visual tokens for portfolio screens.
/// 持仓相关页面的视觉常量。
abstract final class PortfolioTheme {
  static const Color pageBackground = Color(0xFFF5F7FC);
  static const Color cardBackground = Colors.white;
  static const Color border = Color(0xFFE0E6F0);
  static const Color textPrimary = Color(0xFF1A1F2E);
  static const Color textSecondary = Color(0xFF5C6475);
  static const Color primaryBlue = Color(0xFF3378F2);
  static const Color previewBlueBg = Color(0xFFEDF4FF);

  /// A-share convention: red up, green down.
  /// A 股习惯：红涨绿跌。
  static const Color priceUp = Color(0xFFE53935);
  static const Color priceDown = Color(0xFF1A9461);

  static Color plColor(double amount) =>
      amount >= 0 ? priceUp : priceDown;

  static Color dayChangeColor(double fraction) =>
      fraction >= 0 ? priceUp : priceDown;

  static Color assetTypeColor(PortfolioAssetType type) {
    switch (type) {
      case PortfolioAssetType.stock:
        return primaryBlue;
      case PortfolioAssetType.fund:
        return const Color(0xFF8C59F2);
      case PortfolioAssetType.cash:
        return const Color(0xFF26B88C);
      case PortfolioAssetType.other:
        return const Color(0xFFF28C33);
    }
  }
}
