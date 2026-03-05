/// Last Updated: 2026-03-05
/// 最后更新: 2026-03-05
///
/// Module: Hola welcome screen - entry point to reusable FirstSpot templates.
/// 模块: Hola 欢迎页 - 可复用 FirstSpot 模板页入口。
///
/// Dependencies: flutter/material.dart, stock_insight_template_page
/// 依赖: flutter/material.dart, stock_insight_template_page
///
/// Author: Harry Chen
/// Email: 11911421@mail.sustech.edu.cn
import 'package:flutter/material.dart';
import 'features/stock_insight/pages/stock_insight_template_page.dart';

void main() => runApp(const MyApp());

/// Root widget of test app.
/// testapp 的根部件。
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1FA95B)),
      ),
      home: const HolaWelcomePage(),
    );
  }
}

/// Welcome page as the only default entry in main.dart.
/// 作为 main.dart 唯一默认入口的欢迎页。
class HolaWelcomePage extends StatelessWidget {
  const HolaWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Hola',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF162025),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '欢迎来到 FirstSpot 模板演示',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF5D696F),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const StockInsightTemplatePage(),
                      ),
                    );
                  },
                  child: const Text('进入个股信息模板页'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
