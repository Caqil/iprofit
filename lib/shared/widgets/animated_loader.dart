// lib/shared/widgets/animated_loader.dart
import 'dart:math';
import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart' as Math;

import 'package:flutter/material.dart';

class AnimatedLoader extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const AnimatedLoader({
    super.key,
    this.size = 50.0,
    this.color = Colors.blue,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<AnimatedLoader> createState() => _AnimatedLoaderState();
}

class _AnimatedLoaderState extends State<AnimatedLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                _buildCircle(0.0),
                _buildCircle(0.25),
                _buildCircle(0.5),
                _buildCircle(0.75),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCircle(double startValue) {
    final rotationValue = (_animation.value + startValue) % 1.0;
    return Positioned(
      left: widget.size / 2 * cos(rotationValue * 2 * pi) + widget.size / 2 - 5,
      top: widget.size / 2 * sin(rotationValue * 2 * pi) + widget.size / 2 - 5,
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: widget.color.withOpacity(1 - rotationValue),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  // Helper method to calculate position
  double cos(double value) => Math.cos(value);
  double sin(double value) => Math.sin(value);
}
