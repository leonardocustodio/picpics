import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum _AniProps { opacity, translateY }

class FadeIn extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeIn({
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final tween = MovieTween()
      ..tween(_AniProps.opacity, 0.0.tweenTo(1.0))
      ..tween(_AniProps.translateY, 0.0.tweenTo(76.0));

    return PlayAnimationBuilder<Movie>(
      delay: (300 * delay).round().milliseconds,
      duration: 120.milliseconds,
      tween: tween,
      builder: (context, value, _) => Opacity(
        opacity: value.get(_AniProps.opacity),
        child: Container(
          height: value.get(_AniProps.translateY),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
