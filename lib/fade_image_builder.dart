import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class FadeImageBuilder extends StatelessWidget {
  final Widget child;

  const FadeImageBuilder({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1000),
      builder: (BuildContext _, double value, Widget __) {
        return Opacity(opacity: value, child: child);
      },
    );
  }
}
