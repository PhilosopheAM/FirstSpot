// Last Updated: 2026-04-29
// 最后更新: 2026-04-29
//
// Module: Finance Micro Widget Decoration - shared bottom Myo illustration
// 模块: 金融小组件修饰图 - 共享底部 Myo 插画
//
// Dependencies: flutter/material.dart, Myo character image assets
// 依赖: flutter/material.dart, Myo 角色图片资源
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

class FinanceMicroWidgetBottomDecoration extends StatelessWidget {
  const FinanceMicroWidgetBottomDecoration({super.key});

  static const String _assetPath =
      'assets/images/characters/myo/myo_playing_ball_yarn.png';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Center(
        child: Image.asset(
          _assetPath,
          width: 220,
          fit: BoxFit.contain,
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}
