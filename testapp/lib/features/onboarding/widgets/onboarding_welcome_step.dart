import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../data/onboarding_preferences_service.dart';
import 'bouncy_button.dart';

class OnboardingWelcomeStep extends StatefulWidget {
  const OnboardingWelcomeStep({
    super.key,
    required this.onNext,
    required this.onSkip,
  });

  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  State<OnboardingWelcomeStep> createState() => _OnboardingWelcomeStepState();
}

class _OnboardingWelcomeStepState extends State<OnboardingWelcomeStep> {
  static const String _videoAsset = 'assets/animations/myo_waving_welcome.mp4';
  static const String _meowAsset = 'audio/myo_meow_short.mp3';
  static const Duration _loopStartAfterIntro = Duration(milliseconds: 1300);
  static const Duration _loopEndTolerance = Duration(milliseconds: 120);

  final OnboardingPreferencesService _prefsService =
      OnboardingPreferencesService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  VideoPlayerController? _videoController;
  final List<VideoPlayerController> _loopControllers =
      <VideoPlayerController>[];
  int _activeLoopControllerIndex = 0;
  bool _videoFailed = false;
  bool _isHandlingTap = false;
  bool _isSwitchingVideoLoop = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _configureAudioPlayer();
  }

  Future<void> _configureAudioPlayer() async {
    try {
      await _audioPlayer.setAudioContext(
        AudioContextConfig(
          focus: AudioContextConfigFocus.mixWithOthers,
        ).build(),
      );
      await _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.setVolume(1.0);
    } catch (_) {
      // Keep the interaction functional even if audio cannot initialize.
    }
  }

  Future<void> _initializeVideo() async {
    final VideoPlayerController firstLoopController = _createVideoController();
    final VideoPlayerController secondLoopController = _createVideoController();

    try {
      await Future.wait(<Future<void>>[
        firstLoopController.initialize(),
        secondLoopController.initialize(),
      ]).timeout(const Duration(seconds: 4));

      await Future.wait(<Future<void>>[
        firstLoopController.setLooping(false),
        secondLoopController.setLooping(false),
        firstLoopController.setVolume(0),
        secondLoopController.setVolume(0),
        firstLoopController.seekTo(
          _restartPositionFor(firstLoopController.value.duration),
        ),
        secondLoopController.seekTo(
          _restartPositionFor(secondLoopController.value.duration),
        ),
      ]);

      firstLoopController.addListener(_handleLoopVideoProgress);
      secondLoopController.addListener(_handleLoopVideoProgress);

      _loopControllers
        ..clear()
        ..addAll(<VideoPlayerController>[
          firstLoopController,
          secondLoopController,
        ]);

      _activeLoopControllerIndex = 0;
      _videoController = firstLoopController;
      await firstLoopController.play();

      if (!mounted) {
        await _disposeVideoControllers();
        return;
      }

      setState(() {});
    } catch (_) {
      await _disposeController(firstLoopController);
      await _disposeController(secondLoopController);
      if (!mounted) {
        return;
      }

      setState(() {
        _videoFailed = true;
      });
    }
  }

  VideoPlayerController _createVideoController() {
    return VideoPlayerController.asset(
      _videoAsset,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
  }

  void _handleLoopVideoProgress() {
    final VideoPlayerController? controller = _videoController;
    if (controller == null || !_loopControllers.contains(controller)) {
      return;
    }

    if (!_isNearVideoEnd(controller)) {
      return;
    }

    final int nextIndex = _activeLoopControllerIndex == 0 ? 1 : 0;
    unawaited(_switchToLoopController(nextIndex));
  }

  bool _isNearVideoEnd(VideoPlayerController controller) {
    if (!controller.value.isInitialized ||
        controller.value.isBuffering ||
        controller.value.duration == Duration.zero) {
      return false;
    }

    return controller.value.position >=
        controller.value.duration - _loopEndTolerance;
  }

  Future<void> _switchToLoopController(int index) async {
    if (_isSwitchingVideoLoop || index >= _loopControllers.length) {
      return;
    }

    _isSwitchingVideoLoop = true;
    final VideoPlayerController? previousController = _videoController;
    final VideoPlayerController nextController = _loopControllers[index];
    _activeLoopControllerIndex = index;
    await nextController.play();
    _videoController = nextController;

    if (mounted) {
      setState(() {});
    }

    if (previousController != null && previousController != nextController) {
      await previousController.pause();
      await previousController.seekTo(
        _restartPositionFor(previousController.value.duration),
      );
    }
    _isSwitchingVideoLoop = false;
  }

  Duration _restartPositionFor(Duration duration) {
    return _loopStartAfterIntro < duration
        ? _loopStartAfterIntro
        : Duration.zero;
  }

  void _keepVideoPlaying() {
    final VideoPlayerController? controller = _videoController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (!controller.value.isPlaying) {
      controller.play();
    }
  }

  void _keepVideoPlayingAfterAudioFocusSettles() {
    _keepVideoPlaying();
    Future<void>.delayed(const Duration(milliseconds: 250), _keepVideoPlaying);
    Future<void>.delayed(const Duration(milliseconds: 700), _keepVideoPlaying);
  }

  Future<void> _handleMyoTap() async {
    if (_isHandlingTap) {
      return;
    }

    _isHandlingTap = true;
    try {
      HapticFeedback.lightImpact();

      try {
        await _audioPlayer.stop();
        await _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
        await _audioPlayer.play(AssetSource(_meowAsset), volume: 1.0);
        _keepVideoPlayingAfterAudioFocusSettles();
      } catch (_) {
        // Ignore missing plugin / audio init failures in test or fallback envs.
        _keepVideoPlayingAfterAudioFocusSettles();
      }

      final bool hasDiscovered = await _prefsService
          .hasDiscoveredMyoEasterEgg();
      if (!mounted || hasDiscovered) {
        return;
      }

      await _prefsService.markMyoEasterEggDiscovered();
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('已触发彩蛋：第一次和 Myo 互动'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      _isHandlingTap = false;
    }
  }

  Future<void> _handleSkip() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('要跳过新手引导吗？'),
          content: const Text('跳过后将直接进入首页，后续可以在设置中重新开启。'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('继续引导'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('跳过'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      widget.onSkip();
    }
  }

  @override
  void dispose() {
    for (final VideoPlayerController controller in _loopControllers) {
      controller.removeListener(_handleLoopVideoProgress);
    }
    unawaited(_disposeVideoControllers());
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _disposeVideoControllers() async {
    for (final VideoPlayerController controller in _loopControllers) {
      await _disposeController(controller);
    }
    _loopControllers.clear();
    _videoController = null;
  }

  Future<void> _disposeController(VideoPlayerController? controller) async {
    if (controller == null) {
      return;
    }

    controller.removeListener(_handleLoopVideoProgress);
    await controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool compact = constraints.maxHeight < 680;
            final double myoSize = compact ? 156 : 228;
            final double headlineSize = compact ? 26 : 32;
            final double topGap = compact ? 6 : 16;
            final double sectionGap = compact ? 16 : 28;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, compact ? 16 : 24),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: _handleSkip,
                          child: const Text(
                            '稍后再说',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF8A948E),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: topGap),
                      Text(
                        '为年轻人攒下\n第一桶金',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: headlineSize,
                          height: 1.16,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1F2328),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '不荐股、不加杠杆，\n陪你看懂钱的游戏规则。',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: compact ? 14 : 16,
                          height: 1.42,
                          color: const Color(0xFF5B5B5B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: sectionGap),
                      SizedBox(
                        width: myoSize,
                        height: myoSize,
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF4CC38A),
                                  width: 4,
                                ),
                              ),
                              child: ClipOval(
                                child: IgnorePointer(child: _buildMyoVisual()),
                              ),
                            ),
                            Positioned.fill(
                              child: GestureDetector(
                                onTap: _handleMyoTap,
                                behavior: HitTestBehavior.opaque,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '点一点 Myo，会有彩蛋。',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6D7A72),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: sectionGap),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: const <Widget>[
                          _PromiseCard(
                            icon: '🛡️',
                            title: '不荐股',
                            desc: '从不告诉你买哪只',
                          ),
                          _PromiseCard(
                            icon: '🪇',
                            title: '不加杠杆',
                            desc: '只用能承受的钱',
                          ),
                          _PromiseCard(
                            icon: '🌡',
                            title: '不装专业',
                            desc: '大白话翻译术语',
                          ),
                        ],
                      ),
                      SizedBox(height: compact ? 20 : 32),
                      SizedBox(
                        width: double.infinity,
                        child: BouncyButton(
                          onPressed: widget.onNext,
                          color: const Color(0xFF4CC38A),
                          shadowColor: const Color(0xFF3BA06E),
                          borderRadius: 28,
                          child: const Text(
                            '进入新手村',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '只需 3 分钟，随时可以退出。',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8A948E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMyoVisual() {
    final VideoPlayerController? controller = _videoController;
    if (controller != null && controller.value.isInitialized) {
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(controller),
        ),
      );
    }

    if (_videoFailed) {
      return const ColoredBox(
        color: Colors.white,
        child: Center(
          child: Icon(Icons.pets_rounded, size: 72, color: Color(0xFF4CC38A)),
        ),
      );
    }

    return const ColoredBox(
      color: Colors.white,
      child: Center(child: CircularProgressIndicator(color: Color(0xFF4CC38A))),
    );
  }
}

class _PromiseCard extends StatefulWidget {
  const _PromiseCard({
    required this.icon,
    required this.title,
    required this.desc,
  });

  final String icon;
  final String title;
  final String desc;

  @override
  State<_PromiseCard> createState() => _PromiseCardState();
}

class _PromiseCardState extends State<_PromiseCard> {
  bool _isFlipped = false;

  String get _frontIcon {
    if (widget.icon == '🛡️') {
      return '🚫';
    }
    if (widget.icon == '🪇') {
      return '🛡️';
    }
    return '🤔';
  }

  String get _backTitle {
    if (widget.title.contains('荐股')) {
      return '教你方法论';
    }
    if (widget.title.contains('杠杆')) {
      return '教你控风险';
    }
    return '小白也能懂';
  }

  String get _backDesc {
    if (widget.title.contains('荐股')) {
      return '学会自己判断';
    }
    if (widget.title.contains('杠杆')) {
      return '先活下来再赚钱';
    }
    return '把复杂话说清楚';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFlipped = !_isFlipped;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: _isFlipped ? math.pi : 0),
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutCubic,
        builder: (BuildContext context, double angle, Widget? child) {
          final bool showBack = angle > math.pi / 2;
          final double displayAngle = showBack ? angle - math.pi : angle;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0014)
              ..rotateY(displayAngle),
            child: showBack ? _buildBack() : _buildFront(),
          );
        },
      ),
    );
  }

  Widget _buildCardShell({
    required Color color,
    required Color borderColor,
    required Widget child,
  }) {
    return Container(
      width: 108,
      height: 128,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildFront() {
    return _buildCardShell(
      color: Colors.white,
      borderColor: const Color(0xFFE6E8EC),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(_frontIcon, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 6),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: Color(0xFF1F2328),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              widget.desc,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: Color(0xFF6D7A72),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack() {
    return _buildCardShell(
      color: const Color(0xFFF2FBF6),
      borderColor: const Color(0xFFB7E4CC),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF4CC38A),
            size: 26,
          ),
          const SizedBox(height: 8),
          Text(
            _backTitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: Color(0xFF1F2328),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              _backDesc,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 11,
                height: 1.25,
                color: Color(0xFF35634B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
