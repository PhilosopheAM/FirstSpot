/// Last Updated: 2026-03-02
/// 最后更新: 2026-03-02
///
/// Module: Demo Hola screen - shows day/night toggle with typewriter text effect.
/// 模块: Hola 演示页面 - 展示日夜切换与打字机文本效果。
///
/// Dependencies: flutter/material.dart, dart:async, shared_preferences
/// 依赖: flutter/material.dart, dart:async, shared_preferences
///
/// Author: Harry Chen
/// Email: 11911421@mail.sustech.edu.cn
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Entry point of the demo Hola application.
/// 示例 Hola 应用的入口函数。
///
/// Boots Flutter framework and runs [MyApp] as the root widget.
/// 启动 Flutter 框架并以 [MyApp] 作为根部件运行。
void main() {
  runApp(const MyApp());
}

/// Root widget of the Hola demo application.
/// Hola 演示应用的根部件。
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HolaPage(),
    );
  }
}

/// Main screen that shows Hola text and day/night toggle.
/// 展示 Hola 文本与日夜切换按钮的主界面。
class HolaPage extends StatefulWidget {
  const HolaPage({super.key});

  @override
  State<HolaPage> createState() => _HolaPageState();
}

class _HolaPageState extends State<HolaPage> {
  // false 表示 Night（白底黑字），true 表示 Day（黑底白字）
  bool _isDay = false;

  // SharedPreferences key for persisting day/night mode.
  // 用于持久化保存日夜模式的 SharedPreferences 键名。
  static const String _prefKeyIsDay = 'hola_is_day';

  // 完整要显示的文本内容。
  // The full text to display with typewriter effect.
  final String _fullText = 'Hola!';

  // 当前已经显示出来的前缀文本。
  // Currently visible prefix of [_fullText].
  String _visibleText = '';

  // 当前打字进度索引。
  // Current typing index in [_fullText].
  int _currentIndex = 0;

  // 控制打字机效果的定时器。
  // Timer driving the typewriter animation.
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _loadIsDayFromLocal();
    _startTypingAnimation();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  /// Starts the typewriter animation for [_fullText].
  /// 启动针对 [_fullText] 的打字机动画。
  void _startTypingAnimation() {
    _visibleText = '';
    _currentIndex = 0;
    _typingTimer?.cancel();

    _typingTimer = Timer.periodic(const Duration(milliseconds: 450), (Timer timer) {
      if (_currentIndex >= _fullText.length) {
        timer.cancel();
        return;
      }
      setState(() {
        _currentIndex += 1;
        _visibleText = _fullText.substring(0, _currentIndex);
      });
    });
  }

  /// Loads persisted day/night mode from local storage.
  /// 从本地存储中加载持久化的日夜模式状态。
  Future<void> _loadIsDayFromLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? saved = prefs.getBool(_prefKeyIsDay);
    if (saved != null) {
      setState(() {
        _isDay = saved;
      });
    }
  }

  /// Persists current day/night mode to local storage.
  /// 将当前日夜模式状态持久化保存到本地存储中。
  Future<void> _saveIsDayToLocal(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKeyIsDay, value);
  }

  @override
  Widget build(BuildContext context) {
    final bool showDayStyle = _isDay;
    final Color backgroundColor = showDayStyle ? Colors.white : Colors.black;
    final Color textColor = showDayStyle ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          Center(
            child: Text(
              _visibleText,
              style: TextStyle(
                fontSize: 48,
                color: textColor,
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    if (!_isDay) {
                      setState(() {
                        _isDay = true;
                        _startTypingAnimation();
                      });
                      _saveIsDayToLocal(true);
                    }
                  },
                  child: const Text('Day'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_isDay) {
                      setState(() {
                        _isDay = false;
                        _startTypingAnimation();
                      });
                      _saveIsDayToLocal(false);
                    }
                  },
                  child: const Text('Night'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
