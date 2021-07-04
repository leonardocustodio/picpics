import 'package:flutter/material.dart';

class FadeImageBuilder extends StatelessWidget {
  final Widget child;
  final int milliseconds;

  const FadeImageBuilder({
    Key? key,
    required this.child,
    this.milliseconds = 1000,
  }) : super(key: key);

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
