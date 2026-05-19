// Last Updated: 2026-05-19
// 最后更新: 2026-05-19
//
// Module: Portfolio overview page - holdings dashboard with charts and list
// 模块: 持仓总览页 - 图表与列表仪表盘
//
// Dependencies: flutter/material.dart, portfolio_controller, portfolio_models, portfolio_calculator, portfolio widgets/pages
// 依赖: flutter/material.dart, portfolio_controller, portfolio_models, portfolio_calculator, portfolio 组件与页面
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

import '../data/portfolio_controller.dart';
import '../domain/portfolio_calculator.dart';
import '../domain/portfolio_models.dart';
import '../utils/portfolio_format.dart';
import '../widgets/portfolio_allocation_bar.dart';
import '../widgets/portfolio_concentration_section.dart';
import '../widgets/portfolio_detail_sheet.dart';
import '../widgets/portfolio_donut.dart';
import '../widgets/portfolio_position_row.dart';
import '../widgets/portfolio_theme.dart';
import 'portfolio_add_flow_page.dart';

class PortfolioOverviewPage extends StatefulWidget {
  const PortfolioOverviewPage({super.key});

  @override
  State<PortfolioOverviewPage> createState() => _PortfolioOverviewPageState();
}

class _PortfolioOverviewPageState extends State<PortfolioOverviewPage> {
  PortfolioSortMode _sortMode = PortfolioSortMode.byWeight;

  @override
  void initState() {
    super.initState();
    portfolioController.addListener(_onPortfolioChanged);
  }

  @override
  void dispose() {
    portfolioController.removeListener(_onPortfolioChanged);
    super.dispose();
  }

  void _onPortfolioChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openAddFlow() async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => const PortfolioAddFlowPage()),
    );
  }

  void _showCalculationHelp() {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('市值与盈亏如何计算'),
        content: const SingleChildScrollView(
          child: Text(
            '• 市值 = 最新价 × 数量；暂无行情时，最新价按你录入的成交价估算。\n'
            '• 权重 = 单只市值 ÷ 组合总市值。\n'
            '• 浮动盈亏 =（最新价 − 成本价）× 数量。\n'
            '• 现金类按面值计入占比，不参与股价波动。\n\n'
            '数据仅存于本机，FirstSpot 不连接券商账户。',
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PortfolioSummary summary = portfolioController.summary;
    if (summary.isEmpty) {
      return _PortfolioEmptyBody(onAdd: _openAddFlow);
    }

    final List<PortfolioHolding> sorted = PortfolioCalculator.sortHoldings(
      portfolioController.holdings,
      _sortMode,
      summary,
    );

    final double? totalPlPct = summary.totalProfitLossPercent;

    return Scaffold(
      backgroundColor: PortfolioTheme.pageBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 20,
                            color: PortfolioTheme.textPrimary,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '我的持仓',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: PortfolioTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        _IconCapsule(
                          icon: Icons.add,
                          onTap: _openAddFlow,
                        ),
                        const SizedBox(width: 8),
                        _IconCapsule(
                          icon: Icons.more_horiz,
                          onTap: _showCalculationHelp,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            '总资产（估算）',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              color: PortfolioTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            formatPortfolioCny(summary.totalMarketValue),
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: PortfolioTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            totalPlPct == null
                                ? formatPortfolioCny(
                                    summary.totalProfitLoss,
                                    showSign: true,
                                  )
                                : '${formatPortfolioCny(summary.totalProfitLoss, showSign: true)}  (${formatSignedDayChange(totalPlPct)})',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: PortfolioTheme.plColor(
                                summary.totalProfitLoss,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PortfolioDonut(positionCount: summary.positionCount),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: PortfolioAllocationBar(slices: summary.allocationSlices),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: PortfolioConcentrationSection(
                  top1Weight: summary.top1Weight,
                  top3Weight: summary.top3CumulativeWeight,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: PortfolioSortMode.values.map((PortfolioSortMode m) {
                    final bool selected = _sortMode == m;
                    return FilterChip(
                      label: Text(m.labelZh),
                      selected: selected,
                      onSelected: (_) => setState(() => _sortMode = m),
                      selectedColor: const Color(0xFF1F2438),
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : PortfolioTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: PortfolioTheme.border),
                      showCheckmark: false,
                    );
                  }).toList(),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverList.separated(
                itemCount: sorted.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (BuildContext context, int index) {
                  final PortfolioHolding h = sorted[index];
                  return PortfolioPositionRow(
                    holding: h,
                    weight: summary.weightOf(h),
                    onTap: () => showPortfolioDetailSheet(
                      context: context,
                      holding: h,
                      weight: summary.weightOf(h),
                      onDelete: portfolioController.remove,
                    ),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: _FooterHint(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PortfolioEmptyBody extends StatelessWidget {
  const _PortfolioEmptyBody({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PortfolioTheme.pageBackground,
      appBar: AppBar(
        backgroundColor: PortfolioTheme.pageBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          color: PortfolioTheme.textPrimary,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '我的持仓',
          style: TextStyle(
            color: PortfolioTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 140,
              decoration: BoxDecoration(
                color: const Color(0xFFE6EBF8),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.pie_chart_outline,
                size: 56,
                color: PortfolioTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '还没有持仓记录',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: PortfolioTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'FirstSpot 不连接券商账户。\n把在其他平台的买卖记在这里，就能看到自己的总仓位。',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                color: PortfolioTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: onAdd,
              style: FilledButton.styleFrom(
                backgroundColor: PortfolioTheme.primaryBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('添加第一笔持仓'),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconCapsule extends StatelessWidget {
  const _IconCapsule({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: PortfolioTheme.border),
          ),
          child: Icon(icon, size: 20, color: PortfolioTheme.textPrimary),
        ),
      ),
    );
  }
}

class _FooterHint extends StatelessWidget {
  const _FooterHint();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFD9CCFF),
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            '看清结构，比猜时点更重要。点按一行可查看详情。',
            style: TextStyle(fontSize: 11, color: PortfolioTheme.textSecondary),
          ),
        ),
      ],
    );
  }
}
