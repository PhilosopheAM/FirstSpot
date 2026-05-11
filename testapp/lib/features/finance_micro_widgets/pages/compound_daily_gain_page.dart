// Last Updated: 2026-04-29
// 最后更新: 2026-04-29
//
// Module: Compound Daily Gain Page - standalone compounding simulator
// 模块: 复利日均收益页 - 独立复利收益测算入口
//
// Dependencies: flutter/material.dart, compound_daily_gain_widget, finance_micro_widget_decoration
// 依赖: flutter/material.dart, 复利日均收益模拟器组件, 金融小组件修饰图
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

import '../widgets/compound_daily_gain_widget.dart';
import '../widgets/finance_micro_widget_decoration.dart';

class CompoundDailyGainPage extends StatelessWidget {
  const CompoundDailyGainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF8),
      appBar: AppBar(
        title: const Text(
          '复利日均收益',
          style: TextStyle(
            color: Color(0xFF23302A),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: const Color(0xFFFFFDF8),
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color(0xFF23302A)),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            children: <Widget>[
              CompoundDailyGainWidget(),
              FinanceMicroWidgetBottomDecoration(),
            ],
          ),
        ),
      ),
    );
  }
}
