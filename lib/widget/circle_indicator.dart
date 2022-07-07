import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleIndicator extends StatefulWidget {
  const CircleIndicator({
    Key? key,
    this.stop = false,
    this.stopAnyTime = false,
    required this.colors,
    this.radius = 10,
    this.progress = 0.0,
    this.duration = const Duration(milliseconds: 800),
    double? childRadius,
  })  : childRadius = childRadius ?? radius / 3,
        super(key: key);
  final bool stop;
  final Duration duration;

  final List<Color> colors;
  final double radius;
  final double childRadius;
  final double progress;

  /// 当[stop]切换为 true 时, 是否停止动画
  final bool stopAnyTime;
  @override
  State<CircleIndicator> createState() => _CircleIndicatorState();
}

class _CircleIndicatorState extends State<CircleIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: widget.duration);
    updateState();
  }

  @override
  void didUpdateWidget(covariant CircleIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateState();
  }

  void updateState() {
    if (!widget.stop) {
      animationController.repeat();
    } else if (widget.stopAnyTime) {
      animationController.stop();
    }
    if (!animationController.isAnimating) {
      animationController.value = widget.progress.clamp(0.0, 1.0);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius * 2,
      width: widget.radius * 2,
      child: CustomPaint(
        painter: _CircleIndicatorPainter(
          value: animationController,
          radius: widget.radius,
          colors: widget.colors,
          childRadius: widget.childRadius,
        ),
      ),
    );
  }
}

class _CircleIndicatorPainter extends CustomPainter {
  _CircleIndicatorPainter({
    required this.value,
    required double radius,
    required this.colors,
    required double childRadius,
  }) : super(repaint: value) {
    rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
            -childRadius, -radius + childRadius, childRadius, childRadius),
        Radius.circular(childRadius));
  }
  final Animation<double> value;
  late RRect rrect;
  final List<Color> colors;
  static const _twoPi = math.pi * 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);
    final tickCount = colors.length;

    final paint = Paint();
    final deg = _twoPi / tickCount;
    // 对齐
    canvas.rotate(_twoPi * value.value);
    canvas.rotate(deg);
    for (var i = 0; i < tickCount; i++) {
      final index = i;
      paint.color = colors[index];
      canvas.drawRRect(rrect, paint);
      canvas.rotate(deg);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CircleIndicatorPainter oldDelegate) {
    return value != oldDelegate.value ||
        rrect != oldDelegate.rrect ||
        colors.length != oldDelegate.colors.length ||
        colors.any((e) => !oldDelegate.colors.contains(e));
  }
}
