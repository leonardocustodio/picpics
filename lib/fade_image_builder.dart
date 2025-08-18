import 'package:flutter/material.dart';

class FadeImageBuilder extends StatelessWidget {

  const FadeImageBuilder({
    required this.child, super.key,
    this.milliseconds = 1000,
  });
  final Widget child;
  final int milliseconds;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: milliseconds),
      builder: (/* BuildContext */ _, double value, /* Widget? */ __) {
        return Opacity(opacity: value, child: child);
      },
    );
  }
}
