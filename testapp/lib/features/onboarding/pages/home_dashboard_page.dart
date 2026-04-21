/// Last Updated: 2026-04-10
/// 最后更新: 2026-04-10
///
/// Module: Home Dashboard Page - the minimum viable homepage after onboarding
/// 模块: 首页仪表盘 - 引导结束后的最小可用首页
///
/// Dependencies: flutter/material.dart, stock_insight_template_page, shared_preferences
/// 依赖: flutter/material.dart, stock_insight_template_page, shared_preferences
///
/// Author: Harry Chen
/// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../stock_insight/pages/stock_insight_template_page.dart';
import '../widgets/task_card.dart';
import 'first_open_gate_page.dart';

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
          padding: const EdgeInsets.all(24),
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
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF5D696F),
                ),
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
                description: '每天5分钟，学习看懂钱的游戏规则',
                buttonText: '未开放',
                isLocked: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

