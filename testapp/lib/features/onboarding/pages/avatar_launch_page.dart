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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _easeOutCubic(double value) {
    final double clamped = value.clamp(0.0, 1.0);
    return 1 - math.pow(1 - clamped, 3).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final double avatarSize = screenSize.shortestSide.clamp(220.0, 320.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final double progress = _controller.value;
            final double waveProgress = (progress / 0.56).clamp(0.0, 1.0);
            final double flyProgress = ((progress - 0.56) / 0.44).clamp(
              0.0,
              1.0,
            );
            final double flyEase = _easeOutCubic(flyProgress);
            final double settleEase = _easeOutCubic(
              (progress / 0.18).clamp(0.0, 1.0),
            );

            final double rotation =
                math.sin(waveProgress * math.pi * 4) * 0.11 * (1 - flyProgress);
            final double bob =
                math.sin(waveProgress * math.pi * 4) * 12 * (1 - flyProgress);
            final double lift = -screenSize.height * 0.95 * flyEase;
            final double scale = 0.86 + 0.14 * settleEase + 0.08 * flyEase;
            final double opacity = (1 - (flyProgress * 1.15)).clamp(0.0, 1.0);

            return Stack(
              fit: StackFit.expand,
              children: [
                Opacity(
                  opacity: (flyProgress * 0.9).clamp(0.0, 1.0),
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFEAF6EE), Color(0xFFF7FAF8)],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Opacity(
                    opacity: opacity,
                    child: Transform.translate(
                      offset: Offset(0, bob + lift),
                      child: Transform.rotate(
                        angle: rotation,
                        child: Transform.scale(scale: scale, child: child),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          child: Semantics(
            label: 'FirstSpot avatar launch animation',
            image: true,
            child: Image.asset(
              'assets/images/cat_app_avatar_v1.png',
              width: avatarSize,
              height: avatarSize,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
