/* import 'package:flutter/material.dart';

class ArrowPainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  ArrowPainter(
      {this.strokeColor = Colors.black,
      this.strokeWidth = 3,
      this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    var path = getTrianglePath(size.width, size.height);
    canvas.drawShadow(path, strokeColor.withOpacity(0.5), 1.0, false);
    canvas.drawPath(path, paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y / 2)
      ..lineTo(16, 0)
      ..lineTo(x, 0)
      ..lineTo(x, y)
      ..lineTo(16, y)
      ..lineTo(0, y / 2);
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
 */