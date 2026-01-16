import 'package:flutter/cupertino.dart';

class CustomScrollPhysics extends AlwaysScrollableScrollPhysics {
  const CustomScrollPhysics({super.parent});

  @override
  AlwaysScrollableScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }
}
