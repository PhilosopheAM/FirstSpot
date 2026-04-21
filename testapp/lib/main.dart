/// Last Updated: 2026-04-10
/// 最后更新: 2026-04-10
///
/// Module: Main entry - app initialization and first open gate
/// 模块: 主入口 - 应用初始化与首开分流
///
/// Dependencies: flutter/material.dart, first_open_gate_page
/// 依赖: flutter/material.dart, first_open_gate_page
///
/// Author: Harry Chen
/// Email: 11911421@mail.sustech.edu.cn
import 'package:flutter/material.dart';

import 'features/onboarding/pages/first_open_gate_page.dart';

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
      home: const FirstOpenGatePage(),
    );
  }
}

