/// Last Updated: 2026-04-21
/// 最后更新: 2026-04-21
///
/// Module: Bouncy Button
/// 模块: 模拟多邻国风格的3D弹性按钮
///
/// Dependencies: flutter/material.dart
///
/// Author: Harry Chen (Modified by AI)
/// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

class BouncyButton extends StatefulWidget {
  const BouncyButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.color = const Color(0xFF1FA95B),
    this.shadowColor = const Color(0xFF188246),
    this.disabledColor = const Color(0xFFE5E9EC),
    this.disabledShadowColor = const Color(0xFFC0C7CD),
    this.height = 56.0,
    this.borderRadius = 16.0,
    this.depth = 6.0,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final Color color;
  final Color shadowColor;
  final Color disabledColor;
  final Color disabledShadowColor;
  final double height;
  final double borderRadius;
  final double depth;

  @override
  State<BouncyButton> createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<BouncyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool get _isEnabled => widget.onPressed != null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 150),
    );

    _animation = Tween<double>(begin: 0.0, end: widget.depth).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_isEnabled) return;
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_isEnabled) return;
    _controller.reverse();
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    if (!_isEnabled) return;
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final dy = _animation.value;
          final currentDepth = widget.depth - dy;

          return SizedBox(
            height: widget.height + widget.depth,
            child: Stack(
              children: [
                // Bottom Shadow (Static, slightly inset)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: widget.height,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isEnabled
                          ? widget.shadowColor
                          : widget.disabledShadowColor,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                  ),
                ),
                // Top Front (Moves down)
                Positioned(
                  top: dy,
                  left: 0,
                  right: 0,
                  height: widget.height,
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          _isEnabled ? widget.color : widget.disabledColor,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                    child: Center(
                      child: widget.child,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
