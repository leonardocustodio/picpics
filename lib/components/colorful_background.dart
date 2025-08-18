import 'dart:math';

import 'package:flutter/material.dart';
import 'package:picpics/constants.dart';

class ColorfulBackground extends CustomPainter {
  ColorfulBackground({required this.moveBy});
  final Point moveBy;

  @override
  void paint(Canvas canvas, Size size) {
    final primaryGradient = Paint()
      ..shader = kPrimaryGradient
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final secondaryGradient = Paint()
      ..shader = kSecondaryGradient
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final pinkGradient = Paint()
      ..shader = kPinkGradient
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final yellowPaint = Paint()
      ..color = kYellowColor
      ..style = PaintingStyle.fill;

    final secondaryPath =
        getSecondaryPath(size.width, size.height, moveBy.x - 20, moveBy.y * 2);
    final pinkPath = getPinkPath(
        size.width, size.height, -(moveBy.x / 3), -(moveBy.y / 2 - 30),);
    final yellowPath =
        getYellowPath(size.width, size.height, moveBy.x / 2, -moveBy.y + .0);

    canvas.drawPaint(primaryGradient);
    canvas.drawPath(pinkPath, pinkGradient);
    canvas.drawPath(secondaryPath, secondaryGradient);
    canvas.drawPath(yellowPath, yellowPaint);
  }

  Path getPinkPath(double x, double y, double moveByX, double moveByY) {
    return Path()
      ..moveTo(x * 1, y * 0.35 + moveByY)
      ..quadraticBezierTo(
          x * 0.5 + moveByX, y * 0.4 + moveByY, 0 + moveByX, y * 0.3 + moveByY,)
      ..lineTo(0 * x + moveByX, 1 * y + moveByY)
      ..lineTo(1 * x, y * 1 + moveByY)
      ..close();
  }

  Path getYellowPath(double x, double y, double moveByX, double moveByY) {
    return Path()
      ..moveTo(x * 0.1 + moveByX, -20 + moveByY)
      ..quadraticBezierTo(x * 0.2, y * 0.1, -x * 0.1, y * 0.2)
      ..lineTo(0, 0)
      ..close();
  }

  Path getSecondaryPath(double x, double y, double moveByX, double moveByY) {
    return Path()
      ..moveTo(0, y * 0.25 + moveByY / 3)
      ..quadraticBezierTo(
          x * 0.75 + moveByX, y * 0.3 + moveByY, x, y * 0.5 - moveByY / 2,)
      ..lineTo(x * 1, y * 1)
      ..lineTo(0, y * 1)
      ..close();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
