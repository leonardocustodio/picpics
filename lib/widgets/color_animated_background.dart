import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:picpics/components/colorful_background.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class ColorAnimatedBackground extends StatefulWidget {

  const ColorAnimatedBackground({
    super.key,
    this.moveByX = 30.0,
    this.moveByY = 20.0,
    this.blurFilter = true,
  });
  final double moveByX;
  final double moveByY;
  final bool blurFilter;

  @override
  ColorAnimatedBackgroundState createState() => ColorAnimatedBackgroundState();
}

class ColorAnimatedBackgroundState extends State<ColorAnimatedBackground>
    with AnimationMixin {
  late AnimationController widthController;
  late AnimationController heightController;
  late Animation<double> xAnimation;
  late Animation<double> yAnimation;

  @override
  void initState() {
    super.initState();
    widthController = createController()..mirror(duration: 3.seconds);
    heightController = createController()..mirror(duration: 3.seconds);
    xAnimation = 0.0.tweenTo(widget.moveByX).animatedBy(widthController);
    yAnimation = 0.0.tweenTo(widget.moveByY).animatedBy(heightController);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ColorfulBackground(
        moveBy: Point(xAnimation.value, yAnimation.value),
      ),
      child: Container(
        constraints: const BoxConstraints.expand(),
        child: widget.blurFilter
            ? BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 18,
                  sigmaY: 18,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x66ffffff), Color(0x33ffffff)],
                      stops: [0, 1],
                    ),
                  ),
                ),
              )
            : Container(
                constraints: const BoxConstraints.expand(),
                color: Colors.white.withValues(alpha: 0.2),
              ),
      ),
    );
  }
}
