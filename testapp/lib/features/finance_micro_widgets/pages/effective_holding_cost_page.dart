// Last Updated: 2026-04-29
// 最后更新: 2026-04-29
//
// Module: Effective Holding Cost Page - standalone fund cost calculator
// 模块: 基金真实持有成本页 - 独立基金费用测算入口
//
// Dependencies: flutter/material.dart, effective_holding_cost_widget
// 依赖: flutter/material.dart, 基金真实持有成本估算器组件
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

import '../widgets/effective_holding_cost_widget.dart';

class EffectiveHoldingCostPage extends StatelessWidget {
  const EffectiveHoldingCostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF8),
      appBar: AppBar(
        title: const Text(
          '基金真实持有成本',
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
          child: EffectiveHoldingCostWidget(),
        ),
      ),
    );
  }
}
