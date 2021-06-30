import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:picPics/components/colorful_background.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class ColorAnimatedBackground extends StatefulWidget {
  final double moveByX;
  final double moveByY;
  final bool blurFilter;

  ColorAnimatedBackground({
    this.moveByX = 30.0,
    this.moveByY = 20.0,
    this.blurFilter = true,
  });

  @override
  _ColorAnimatedBackgroundState createState() =>
      _ColorAnimatedBackgroundState();
}

class _ColorAnimatedBackgroundState extends State<ColorAnimatedBackground>
    with AnimationMixin {
  late AnimationController widthController;
  late AnimationController heightController;
  late Animation<double> x_animation;
  late Animation<double> y_animation;

  @override
  void initState() {
    super.initState();
    widthController = createController()..mirror(duration: 3.seconds);
    heightController = createController()..mirror(duration: 3.seconds);
    x_animation = 0.0.tweenTo(widget.moveByX).animatedBy(widthController);
    y_animation = 0.0.tweenTo(widget.moveByY).animatedBy(heightController);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ColorfulBackground(
        moveBy: Point(x_animation.value, y_animation.value),
      ),
      child: Container(
        constraints: BoxConstraints.expand(),
        child: widget.blurFilter
            ? BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 18.0,
                  sigmaY: 18.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
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
                constraints: BoxConstraints.expand(),
                color: Colors.white.withOpacity(0.2),
              ),
      ),
    );
  }
}
