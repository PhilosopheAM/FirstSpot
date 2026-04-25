// Last Updated: 2026-04-25
// 最后更新: 2026-04-25
//
// Module: Home Dashboard Page - the minimum viable homepage after onboarding
// 模块: 首页仪表盘 - 引导结束后的最小可用首页
//
// Dependencies: flutter/material.dart, learning guidance, stock insight, shared_preferences, vault page
// 依赖: flutter/material.dart, 投资者教育课程, 个股信息页, shared_preferences, 金库页
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
          child: Center(
            heightFactor: 1,
            child: _VaultEntryButton(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const VaultPage(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _VaultEntryButton extends StatelessWidget {
  const _VaultEntryButton({required this.onTap});

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
            border: Border.all(color: const Color(0xFFFFB547), width: 2),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: const Color(0xFFB45309).withValues(alpha: 0.12),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 28,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text('🏛️', style: TextStyle(height: 1)),
                ),
              ),
              SizedBox(height: 4),
              Text(
                '金库',
                style: TextStyle(
                  color: Color(0xFFB45309),
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
