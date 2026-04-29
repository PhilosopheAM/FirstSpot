// Last Updated: 2026-04-29
// 最后更新: 2026-04-29
//
// Module: Home Dashboard Page - the minimum viable homepage after onboarding
// 模块: 首页仪表盘 - 引导结束后的最小可用首页
//
// Dependencies: flutter/material.dart, learning guidance, stock insight, finance tool pages, shared_preferences, vault page
// 依赖: flutter/material.dart, 投资者教育课程, 个股信息页, 金融工具页, shared_preferences, 金库页
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../finance_micro_widgets/pages/compound_daily_gain_page.dart';
import '../../finance_micro_widgets/pages/effective_holding_cost_page.dart';
import '../../learning_guidance/pages/guidance_learning_page.dart';
import '../../stock_insight/pages/stock_insight_template_page.dart';
import '../widgets/task_card.dart';
import 'first_open_gate_page.dart';
import 'vault_page.dart';

class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),
      appBar: AppBar(
        title: const Text(
          '我的小金库',
          style: TextStyle(
            color: Color(0xFF162025),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xFFF7FAF8),
        elevation: 0,
        centerTitle: false,
        actions: [
          // 开发调试用的重置按钮，正式上线时可移除
          TextButton.icon(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear(); // 清空所有本地存储记录
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const FirstOpenGatePage()),
                  (route) => false,
                );
              }
            },
            icon: const Icon(Icons.refresh, color: Colors.redAccent, size: 18),
            label: const Text(
              '重置首开(Debug)',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                '欢迎来到新手村',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF162025),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '我们为你准备了今日新手任务',
                style: TextStyle(fontSize: 15, color: Color(0xFF5D696F)),
              ),
              const SizedBox(height: 32),
              TaskCard(
                title: '了解你的第一只关注个股',
                description: '不荐股、不带杠杆，看看别人是怎么分析的',
                buttonText: '去看看',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const StockInsightTemplatePage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              TaskCard(
                title: '继续新手村课程',
                description: '12章投资者教育，Myo陪你从市场规则学到稳健组合',
                buttonText: '开始学习',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const GuidanceLearningPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 18),
          color: const Color(0xFFF7FAF8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _HomeBottomEntryButton(
                icon: '🧮',
                label: '工具',
                color: const Color(0xFF188246),
                borderColor: const Color(0xFF1FA95B),
                onTap: () => _showFinanceToolDrawer(context),
              ),
              const SizedBox(width: 22),
              _HomeBottomEntryButton(
                icon: '🏛️',
                label: '金库',
                color: const Color(0xFFB45309),
                borderColor: const Color(0xFFFFB547),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const VaultPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFinanceToolDrawer(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF8),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFE6E8EC)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDE7D7),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '选择一个工具',
                  style: TextStyle(
                    color: Color(0xFF23302A),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '每个工具都有独立页面，参数可拖动也可手动输入。',
                  style: TextStyle(color: Color(0xFF4B5760), fontSize: 13),
                ),
                const SizedBox(height: 16),
                _FinanceToolDrawerItem(
                  icon: '💸',
                  title: '基金真实持有成本',
                  subtitle: '管理费、托管费、销售服务费占比拆解',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const EffectiveHoldingCostPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _FinanceToolDrawerItem(
                  icon: '📈',
                  title: '复利日均收益',
                  subtitle: '本金、年化、持有年限连续情景测算',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const CompoundDailyGainPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FinanceToolDrawerItem extends StatelessWidget {
  const _FinanceToolDrawerItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE6E8EC)),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(icon, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF23302A),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF4B5760),
                        fontSize: 12,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF1FA95B)),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeBottomEntryButton extends StatelessWidget {
  const _HomeBottomEntryButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.borderColor,
    required this.onTap,
  });

  final String icon;
  final String label;
  final Color color;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: 76,
          height: 72,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: color.withValues(alpha: 0.12),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 28,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(icon, style: const TextStyle(height: 1)),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  height: 1,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
