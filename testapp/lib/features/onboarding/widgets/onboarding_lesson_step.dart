/// Last Updated: 2026-04-25
/// 最后更新: 2026-04-25
///
/// Module: Onboarding Mini Lesson Step (Step 03)
/// 模块: 首开引导 - 迷你教学（本金 / 涨跌 / 盈亏 · 农事四季类比）
///
/// Dependencies: flutter/material.dart, flutter/services.dart, fl_chart, bouncy_button
///
/// Author: Harry Chen / AI
/// Email: 11911421@mail.sustech.edu.cn

import 'package:audioplayers/audioplayers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bouncy_button.dart';
import 'xp_flyup.dart';

class OnboardingMiniLessonStep extends StatefulWidget {
  const OnboardingMiniLessonStep({
    super.key,
    required this.onNext,
  });

  final VoidCallback onNext;

  @override
  State<OnboardingMiniLessonStep> createState() =>
      _OnboardingMiniLessonStepState();
}

class _OnboardingMiniLessonStepState extends State<OnboardingMiniLessonStep>
    with TickerProviderStateMixin {
  static const Duration _myoTypingDelay = Duration(milliseconds: 600);

  final AudioPlayer _audioPlayer = AudioPlayer();

  int _currentLevel = 0;
  int _lives = 5;
  int _xp = 0;

  final List<Widget> _chatMessages = <Widget>[];
  final ScrollController _scrollController = ScrollController();
  bool _isMyoTyping = false;

  /// 关卡 1：三枚「闲置资金」是否已拖入田地（至少 1 枚即过关）
  final List<bool> _coinPlanted = <bool>[false, false, false];
  bool _fieldDragOver = false;
  double _fieldShakeDx = 0;

  /// 关卡 2：0 长好(涨) / 1 横盘 / 2 跌 —— 仅 0 正确
  int? _selectedTrend;
  int? _pulseOptionIndex;

  /// 关卡 3：emoji 拖入收成筐
  bool _level3Done = false;
  String? _pickedEmoji;
  bool _basketDragOver = false;

  final List<FlSpot> _trendData = const <FlSpot>[
    FlSpot(0, 3.0),
    FlSpot(5, 3.2),
    FlSpot(10, 2.8),
    FlSpot(15, 3.5),
    FlSpot(20, 3.4),
    FlSpot(25, 4.1),
    FlSpot(30, 4.5),
  ];

  int get _plantedCount => _coinPlanted.where((bool p) => p).length;

  @override
  void initState() {
    super.initState();
    _initLevel1Chat();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  Future<void> _simulateMyoTyping(Future<void> Function() action) async {
    setState(() {
      _isMyoTyping = true;
    });
    _scrollToBottom();
    await Future.delayed(_myoTypingDelay);
    if (mounted) {
      setState(() {
        _isMyoTyping = false;
      });
      await action();
      _scrollToBottom();
    }
  }

  void _initLevel1Chat() {
    _chatMessages.addAll(<Widget>[
      _myoBubble(
        null,
        child: const Text.rich(
          TextSpan(
            style: TextStyle(fontSize: 15, height: 1.45, fontWeight: FontWeight.w600, color: Color(0xFF23302A)),
            children: <TextSpan>[
              TextSpan(text: '「'),
              TextSpan(text: '本金', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1FA95B))),
              TextSpan(text: '」就是你暂时不急着花掉、愿意拿来试一试的那笔钱——我管它叫「'),
              TextSpan(text: '闲置资金', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1FA95B))),
              TextSpan(text: '」。\n春天不会凭空长出庄稼：得先把种子放进土里。本金，就是那颗「春天的种子」。'),
            ],
          ),
        ),
      ),
      _myoBubble('把下面的「闲置资金」拖进「春天·田地」里播种吧！'),
    ]);
  }

  void _initLevel2Chat() {
    _chatMessages.addAll(<Widget>[
      _myoBubble('上一关我们把「闲置资金」种进了田。「涨跌」不是猜明天天气——是在看：这颗种子在「这块田里」，这段时间长得健不健康、长势往上还是往下。'),
      _myoBubble('这块「田地」，在现实里就是你选择的市场和标的物（比如某只指数基金、某条指数）——不同田，土质不一样，长势也不一样。'),
      _myoBubble('纵轴可以理解为「长势评分」。折线整体向上 = 这段时间里，在田里长得更好。\n看下面这条线：从第 0 天到第 30 天，整体更像哪一种？'),
    ]);
  }

  void _initLevel3Chat() {
    _chatMessages.addAll(<Widget>[
      _myoBubble('到「秋天」才有收成。「盈亏」就是：秋天粮仓里，多收还是少收。'),
      _myoBubble('收成好不好，不只看春天种了几颗——还有雨水、虫害、你有没有除草……对应投资里，就是时间、市场、标的、运气和纪律，一堆因素加在一起的结果。'),
      _myoBubble('春天你准备了 100 颗种子，秋天一数，收了 90 颗。把你的心情拖进「收成筐」——没有标准答案，我只想听见你怎么想。'),
    ]);
  }

  Future<void> _shakeField() async {
    if (!mounted) return;
    const List<double> offsets = <double>[6, -6, 5, -5, 3, -3, 0];
    for (final double dx in offsets) {
      if (!mounted) return;
      setState(() => _fieldShakeDx = dx);
      await Future<void>.delayed(const Duration(milliseconds: 28));
    }
  }

  void _handleWrongAnswer() {
    if (_lives <= 0) return;
    setState(() {
      _lives--;
    });
    HapticFeedback.heavyImpact();
    _audioPlayer.play(AssetSource('audio/heart_break_soft.wav'));
  }

  Future<void> _pulseOption(int index) async {
    setState(() => _pulseOptionIndex = index);
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (mounted) {
      setState(() => _pulseOptionIndex = null);
    }
  }

  void _handleCorrectAnswer({bool delayNext = true}) {
    setState(() {
      _xp += 2;
    });
    HapticFeedback.mediumImpact();
    if (_currentLevel == 0) {
      _audioPlayer.play(AssetSource('audio/seed_plant.wav'));
    } else if (_currentLevel == 2) {
      _audioPlayer.play(AssetSource('audio/basket_drop.wav'));
    } else {
      _audioPlayer.play(AssetSource('audio/seed_plant.wav')); // fallback
    }
    showXpFlyup(context, 2);

    if (delayNext) {
      Future<void>.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        _proceedToNextLevel();
      });
    }
  }

  void _proceedToNextLevel() {
    if (_currentLevel < 2) {
      setState(() {
        _currentLevel++;
        _selectedTrend = null;
        _isMyoTyping = false;
        _chatMessages.clear();
        if (_currentLevel == 1) _initLevel2Chat();
        if (_currentLevel == 2) _initLevel3Chat();
      });
      _scrollToBottom();
    } else {
      _completeLessons();
    }
  }

  void _completeLessons() {
    setState(() => _xp += 10);
    showXpFlyup(context, 10);
    HapticFeedback.vibrate();
    _audioPlayer.play(AssetSource('audio/basket_drop.wav')); // or another fanfare sound
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('首次关卡全通！'),
        content: const Text('Myo：三关过完——本金、涨跌、盈亏，你都摸过一遍啦！'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onNext();
            },
            child: const Text('继续'),
          ),
        ],
      ),
    );
  }

  void _onCoinDropped(int index) {
    setState(() {
      _fieldDragOver = false;
      _coinPlanted[index] = true;
    });
    HapticFeedback.lightImpact();
    _audioPlayer.play(AssetSource('audio/seed_plant.wav'));

    final int count = _plantedCount;
    String userMsg = '';
    if (count == 1) {
      userMsg = '投入 1 枚闲置资金';
    } else if (count == 2) {
      userMsg = '再投入 1 枚';
    } else {
      userMsg = '全部投入！';
    }

    setState(() {
      _chatMessages.add(_buildUserBubble(userMsg));
    });

    _simulateMyoTyping(() async {
      setState(() {
        if (count == 1) {
          _chatMessages.add(_myoBubble('种下一颗种子啦！这是一个很好的开始。如果你觉得够了，可以点击「就这么多」，或者继续播种。', accent: true));
        } else if (count == 2) {
          _chatMessages.add(_myoBubble('两颗种子下地！未来的收成又多了一分期待。还要继续吗？', accent: true));
        } else {
          _chatMessages.add(_myoBubble(
            null,
            accent: true,
            child: const Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 15, height: 1.45, fontWeight: FontWeight.w600, color: Color(0xFFB45309)),
                children: <TextSpan>[
                  TextSpan(text: '三颗全种下啦！你很大方哦，但记住：投资只用'),
                  TextSpan(text: '闲置资金', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1FA95B))),
                  TextSpan(text: '。准备好我们就进入下一步吧！'),
                ],
              ),
            ),
          ));
        }
      });
    });
  }

  void _onLevel1Done() {
    if (_plantedCount == 0) {
      HapticFeedback.heavyImpact();
      _audioPlayer.play(AssetSource('audio/heart_break_soft.wav'));
      setState(() {
        _chatMessages.add(_buildUserBubble('就这么多'));
      });
      _simulateMyoTyping(() async {
        setState(() {
          _chatMessages.add(_myoBubble('春天不播种，秋天可就没有收成哦！至少投入一枚闲置资金吧。', accent: true));
        });
        _shakeField();
      });
    } else {
      setState(() {
        _chatMessages.add(_buildUserBubble('就这么多'));
      });
      _simulateMyoTyping(() async {
        setState(() {
          _chatMessages.add(_myoBubble('好耶，有种子就有故事开头了——这是稳稳的第一步～', accent: true));
          _chatMessages.add(_buildNextLevelButton('进入夏天'));
        });
        _handleCorrectAnswer(delayNext: false);
      });
    }
  }

  Future<void> _onTrendSelected(int index, String label, bool isCorrect) async {
    if (_isMyoTyping || _selectedTrend != null) {
      return;
    }

    await _pulseOption(index);
    setState(() {
      _selectedTrend = index;
      _chatMessages.add(_buildUserBubble(label.replaceAll('\n', '')));
    });
    _scrollToBottom();

    await _simulateMyoTyping(() async {
      if (isCorrect) {
        setState(() {
          _chatMessages.add(_myoBubble('对啦！这条线整体往上——种子在这块田里，这段时间长得更好了。', accent: true));
          _chatMessages.add(_buildNextLevelButton('进入秋天'));
        });
        _handleCorrectAnswer(delayNext: false);
      } else {
        _handleWrongAnswer();
        setState(() {
          _chatMessages.add(_myoBubble('没关系，很多人第一遍也会看错——涨跌看的是「长势」，不是猜运气。(耐心 -1)', accent: true));
        });
        await Future<void>.delayed(const Duration(milliseconds: 600));
        if (mounted) {
          setState(() => _selectedTrend = null);
        }
      }
    });
  }

  Future<void> _onEmojiDropped(String emoji) async {
    if (_isMyoTyping || _level3Done) {
      return;
    }

    setState(() {
      _basketDragOver = false;
      _level3Done = true;
      _pickedEmoji = emoji;
      _chatMessages.add(_buildUserBubble(emoji));
    });
    _scrollToBottom();
    HapticFeedback.mediumImpact();

    await _simulateMyoTyping(() async {
      setState(() {
        _chatMessages.add(_myoBubble('收到你的心情啦～少收几颗不代表春天白过；重要的是：你知道这是「一整季的结果」，不是某一天决定的。', accent: true));
        _chatMessages.add(_buildNextLevelButton('完成体验'));
      });
      _handleCorrectAnswer(delayNext: false);
    });
  }

  Widget _buildNextLevelButton(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _PulsingButton(
            label: label,
            onPressed: () {
              _proceedToNextLevel();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: List<Widget>.generate(5, (int index) {
              return Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  index < _lives ? Icons.favorite : Icons.favorite_border,
                  color: const Color(0xFFFF6B8B),
                  size: 24,
                ),
              );
            }),
          ),
          Text(
            '${_currentLevel + 1} / 3',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFFB0B9C0),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9F0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFB547), width: 2),
            ),
            child: Row(
              children: <Widget>[
                const Text('XP', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFFFFB547))),
                const SizedBox(width: 4),
                Text(
                  '$_xp',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFFFB547),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _myoBubble(String? text, {Widget? child, bool accent = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent ? const Color(0xFFFFF9F0) : const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
              border: Border.all(
                color: accent ? const Color(0xFFFFB547) : const Color(0xFFD7E8DD),
                width: 2,
              ),
            ),
            child: const Text('喵', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF4CC38A))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: accent ? const Color(0xFFFFF9F0) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(4),
                ),
                border: Border.all(
                  color: accent ? const Color(0xFFFFB547) : const Color(0xFFE6E8EC),
                  width: 2,
                ),
              ),
              child: child ?? Text(
                text ?? '',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                  color: accent ? const Color(0xFFB45309) : const Color(0xFF23302A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserBubble(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF4CC38A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _idleCoin() {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Image.asset('assets/images/idle_money_coin.png', fit: BoxFit.contain),
    );
  }

  Widget _buildLevel1Bottom() {
    return Padding(
      key: const ValueKey<String>('level1_bottom'),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('闲置资金（拖我进田）', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF8A948E))),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List<Widget>.generate(3, (int index) {
              if (_coinPlanted[index]) {
                return Column(
                  children: <Widget>[
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.85, end: 1),
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.elasticOut,
                      builder: (BuildContext context, double s, Widget? child) {
                        return Transform.scale(scale: s, child: child);
                      },
                      child: Image.asset('assets/images/planted_sprout.png', width: 48, height: 48),
                    ),
                    const SizedBox(height: 4),
                    const Text('已播种', style: TextStyle(fontSize: 11, color: Color(0xFF4CC38A), fontWeight: FontWeight.w700)),
                  ],
                );
              }
              return Draggable<int>(
                data: index,
                feedback: Material(
                  color: Colors.transparent,
                  child: Transform.scale(
                    scale: 1.12,
                    child: _idleCoin(),
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.35,
                  child: _idleCoin(),
                ),
                onDragStarted: () => HapticFeedback.selectionClick(),
                onDragEnd: (DraggableDetails details) {
                  if (!details.wasAccepted) {
                    HapticFeedback.lightImpact();
                  }
                },
                child: _idleCoin(),
              );
            }),
          ),
          const SizedBox(height: 24),
          Transform.translate(
            offset: Offset(_fieldShakeDx, 0),
            child: DragTarget<int>(
              onWillAcceptWithDetails: (DragTargetDetails<int> details) {
                final bool ok = !_coinPlanted[details.data];
                setState(() => _fieldDragOver = ok);
                return ok;
              },
              onLeave: (_) {
                setState(() => _fieldDragOver = false);
              },
              onAcceptWithDetails: (DragTargetDetails<int> details) {
                _onCoinDropped(details.data);
              },
              builder: (BuildContext context, List<int?> candidateData, List<dynamic> rejectedData) {
                final bool over = candidateData.isNotEmpty || _fieldDragOver;
                return GestureDetector(
                  onTap: () async {
                    if (_plantedCount == 0) {
                      HapticFeedback.vibrate();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Myo：先拖一枚「闲置资金」进田里嘛～')),
                      );
                      await _shakeField();
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                      color: over ? const Color(0xFFE8F5E9) : const Color(0xFFF7FAF8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: over ? const Color(0xFF4CC38A) : const Color(0xFFCED4D0),
                        width: over ? 3 : 2,
                      ),
                      boxShadow: <BoxShadow>[
                        if (over)
                          BoxShadow(
                            color: const Color(0xFF4CC38A).withValues(alpha: 0.18),
                            blurRadius: 18,
                            spreadRadius: 0,
                            offset: const Offset(0, 6),
                          ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        const Text('春天 · 田地', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF4CC38A))),
                        const SizedBox(height: 8),
                        Text(
                          _plantedCount == 0 ? '把硬币拖到这里播种' : '已播种 $_plantedCount / 3',
                          style: const TextStyle(fontSize: 14, color: Color(0xFF5D696F), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          BouncyButton(
            width: double.infinity,
            height: 56,
            borderRadius: 16,
            color: const Color(0xFF162025),
            onPressed: _onLevel1Done,
            child: const Text('就这么多', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _trendChartCard() {
    return Container(
      padding: const EdgeInsets.only(right: 12, top: 12, bottom: 4, left: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E8EC), width: 2),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (_) => FlLine(
              color: const Color(0xFFE6E8EC),
              strokeWidth: 1,
              dashArray: const <int>[4, 4],
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: 10,
                getTitlesWidget: (double value, TitleMeta meta) {
                  if (value == 0) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text('第0天', style: TextStyle(color: Color(0xFF8A948E), fontSize: 10, fontWeight: FontWeight.w600)),
                    );
                  }
                  if (value == 30) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text('第30天', style: TextStyle(color: Color(0xFF8A948E), fontSize: 10, fontWeight: FontWeight.w600)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 28,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Color(0xFF8A948E), fontSize: 11, fontWeight: FontWeight.w600),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 30,
          minY: 2,
          maxY: 5,
          lineBarsData: <LineChartBarData>[
            LineChartBarData(
              spots: _trendData,
              isCurved: true,
              curveSmoothness: 0.35,
              color: const Color(0xFFFF5C39),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (FlSpot spot, double x, LineChartBarData bar, int index) {
                  if (index == 0 || index == _trendData.length - 1) {
                    return FlDotCirclePainter(
                      radius: 5,
                      color: Colors.white,
                      strokeWidth: 2.5,
                      strokeColor: const Color(0xFFFF5C39),
                    );
                  }
                  return FlDotCirclePainter(radius: 0, color: Colors.transparent);
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    const Color(0xFFFF5C39).withValues(alpha: 0.22),
                    const Color(0xFFFF5C39).withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  Widget _buildTrendOption(String label, int index, bool isCorrect) {
    final bool selected = _selectedTrend == index;
    final bool dimOthers = _selectedTrend != null && _selectedTrend != index;
    final double scale = _pulseOptionIndex == index ? 0.96 : 1.0;

    return AnimatedOpacity(
      opacity: dimOthers ? 0.52 : 1,
      duration: const Duration(milliseconds: 120),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: BouncyButton(
          width: double.infinity,
          height: 64,
          borderRadius: 16,
          color: selected ? const Color(0xFFE8F5E9) : const Color(0xFFF7FAF8),
          shadowColor: selected ? const Color(0xFF4CC38A) : const Color(0xFFE6E8EC),
          onPressed: () => _onTrendSelected(index, label, isCorrect),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                height: 1.2,
                fontWeight: FontWeight.w800,
                color: selected ? const Color(0xFF1FA95B) : const Color(0xFF1F2328),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevel2Bottom() {
    return Padding(
      key: const ValueKey<String>('level2_bottom'),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 160,
            child: _trendChartCard(),
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(child: _buildTrendOption('长好了\n（涨）', 0, true)),
              const SizedBox(width: 10),
              Expanded(child: _buildTrendOption('差不多\n（横盘）', 1, false)),
              const SizedBox(width: 10),
              Expanded(child: _buildTrendOption('没长好\n（跌）', 2, false)),
            ],
          ),
        ],
      ),
    );
  }

  static const List<String> _level3Emojis = <String>['😊', '😭', '😤', '😌', '🤔'];

  Widget _emojiChip(String emoji, {bool large = false}) {
    return Container(
      width: large ? 68 : 56,
      height: large ? 68 : 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE6E8EC), width: 2),
        boxShadow: const <BoxShadow>[BoxShadow(color: Color(0x0D000000), blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Text(emoji, style: TextStyle(fontSize: large ? 36 : 30)),
    );
  }

  Widget _buildLevel3Bottom() {
    return Padding(
      key: const ValueKey<String>('level3_bottom'),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.start,
              children: _level3Emojis.map((String e) {
                if (_level3Done && _pickedEmoji == e) {
                  return const SizedBox.shrink();
                }
                return Draggable<String>(
                  data: e,
                  feedback: Material(
                    color: Colors.transparent,
                    child: Transform.scale(
                      scale: 1.15,
                      child: _emojiChip(e, large: true),
                    ),
                  ),
                  childWhenDragging: Opacity(opacity: 0.3, child: _emojiChip(e)),
                  onDragStarted: () => HapticFeedback.selectionClick(),
                  child: _emojiChip(e),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: DragTarget<String>(
              onWillAcceptWithDetails: (_) {
                setState(() => _basketDragOver = true);
                return !_level3Done;
              },
              onLeave: (_) {
                setState(() => _basketDragOver = false);
              },
              onAcceptWithDetails: (DragTargetDetails<String> details) {
                _onEmojiDropped(details.data);
              },
              builder: (BuildContext context, List<String?> cd, List<dynamic> r) {
                final bool over = cd.isNotEmpty || _basketDragOver;
                return AnimatedScale(
                  scale: over ? 1.04 : 1.0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutBack,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 120,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: over ? const Color(0xFFFFF9F0) : const Color(0xFFF7FAF8),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: over ? const Color(0xFFFFB547) : const Color(0xFFE6E8EC),
                        width: over ? 3 : 2,
                      ),
                      boxShadow: <BoxShadow>[
                        if (over)
                          BoxShadow(
                            color: const Color(0xFFFFB547).withValues(alpha: 0.25),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (_pickedEmoji != null)
                          Text(_pickedEmoji!, style: const TextStyle(fontSize: 36))
                        else
                          Image.asset('assets/images/harvest_basket.png', width: 48, height: 48),
                        const SizedBox(height: 8),
                        const Text('秋天 · 收成筐', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFFB45309))),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildTopBar(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: _chatMessages.length + (_isMyoTyping ? 1 : 0),
                itemBuilder: (BuildContext context, int index) {
                  if (index == _chatMessages.length) {
                    return _myoBubble('...', accent: true);
                  }
                  return _chatMessages[index];
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE6E8EC), width: 1)),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 420),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _currentLevel == 0
                    ? _buildLevel1Bottom()
                    : _currentLevel == 1
                        ? _buildLevel2Bottom()
                        : _buildLevel3Bottom(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PulsingButton extends StatefulWidget {
  const _PulsingButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  State<_PulsingButton> createState() => _PulsingButtonState();
}

class _PulsingButtonState extends State<_PulsingButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _glowAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: const Color(0xFFFFB547).withValues(alpha: 0.6),
                  blurRadius: _glowAnimation.value,
                  spreadRadius: _glowAnimation.value / 2,
                ),
              ],
            ),
            child: BouncyButton(
              width: 160,
              height: 48,
              borderRadius: 24,
              color: const Color(0xFFFFB547),
              shadowColor: const Color(0xFFD97706),
              onPressed: widget.onPressed,
              child: Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
