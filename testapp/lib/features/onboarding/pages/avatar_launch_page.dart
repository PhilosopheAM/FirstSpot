import 'dart:math' as math;

import 'package:flutter/material.dart';

class AvatarLaunchPage extends StatefulWidget {
  const AvatarLaunchPage({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<AvatarLaunchPage> createState() => _AvatarLaunchPageState();
}

class _AvatarLaunchPageState extends State<AvatarLaunchPage>
    with SingleTickerProviderStateMixin {
  static const List<String> _frameAssets = <String>[
    'assets/animations/myo_wave_frames/frame_00.png',
    'assets/animations/myo_wave_frames/frame_01.png',
    'assets/animations/myo_wave_frames/frame_02.png',
    'assets/animations/myo_wave_frames/frame_03.png',
    'assets/animations/myo_wave_frames/frame_04.png',
    'assets/animations/myo_wave_frames/frame_05.png',
    'assets/animations/myo_wave_frames/frame_06.png',
    'assets/animations/myo_wave_frames/frame_07.png',
    'assets/animations/myo_wave_frames/frame_08.png',
    'assets/animations/myo_wave_frames/frame_09.png',
  ];

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 2200),
          )
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed && mounted) {
              widget.onFinished();
            }
          })
          ..forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final String asset in _frameAssets) {
      precacheImage(AssetImage(asset), context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _interval(double t, double begin, double end) {
    if (t <= begin) {
      return 0;
    }
    if (t >= end) {
      return 1;
    }
    return (t - begin) / (end - begin);
  }

  @override
  Widget build(BuildContext context) {
    final double avatarSize = MediaQuery.sizeOf(context).shortestSide.clamp(
      220.0,
      320.0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final double progress = _controller.value;
            final double intro = Curves.easeOutCubic.transform(
              _interval(progress, 0.0, 0.16),
            );
            final double fadeIn = _interval(progress, 0.0, 0.10);
            final double fadeOut = 1 - _interval(progress, 0.88, 1.0);
            final double settle = Curves.easeInOut.transform(
              _interval(progress, 0.12, 0.82),
            );
            final double bob = math.sin(progress * math.pi * 2) * 2.5 * settle;
            final double opacity = (fadeIn * fadeOut).clamp(0.0, 1.0);
            final double scale = 0.92 + 0.08 * intro;

            final int totalSequenceFrames = _frameAssets.length * 2;
            final int sequenceIndex =
                (progress * totalSequenceFrames).floor().clamp(
                      0,
                      totalSequenceFrames - 1,
                    );
            final String currentFrame =
                _frameAssets[sequenceIndex % _frameAssets.length];

            return DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFEAF6EE), Color(0xFFF7FAF8)],
                ),
              ),
              child: Center(
                child: Opacity(
                  opacity: opacity,
                  child: Transform.translate(
                    offset: Offset(0, bob),
                    child: Transform.scale(
                      scale: scale,
                      child: Semantics(
                        label: 'FirstSpot avatar launch animation',
                        image: true,
                        child: Image.asset(
                          currentFrame,
                          width: avatarSize,
                          height: avatarSize,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
