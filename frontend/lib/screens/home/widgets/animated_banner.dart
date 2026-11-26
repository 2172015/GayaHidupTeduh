import 'package:flutter/material.dart';

class AnimatedBanner extends StatelessWidget {
  final Widget child;
  final int delayMs;

  const AnimatedBanner({super.key, required this.child, this.delayMs = 0});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 420 + delayMs),
      curve: Curves.easeOutCubic,
      builder: (context, value, animatedChild) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - value)),
            child: animatedChild,
          ),
        );
      },
      child: child,
    );
  }
}
