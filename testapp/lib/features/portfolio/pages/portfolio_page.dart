// Last Updated: 2026-05-19
// 最后更新: 2026-05-19
//
// Module: Portfolio page - loads holdings then shows overview or empty
// 模块: 持仓入口页 - 加载本地数据后进入总览或空状态
//
// Dependencies: flutter/material.dart, portfolio_controller, portfolio_overview_page
// 依赖: flutter/material.dart, portfolio_controller, portfolio_overview_page
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

import '../data/portfolio_controller.dart';
import '../widgets/portfolio_theme.dart';
import 'portfolio_overview_page.dart';

/// Entry route for the portfolio feature.
/// 持仓功能的路由入口。
class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await portfolioController.load();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!portfolioController.isLoaded) {
      return const Scaffold(
        backgroundColor: PortfolioTheme.pageBackground,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return const PortfolioOverviewPage();
  }
}
