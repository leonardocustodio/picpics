import 'package:flutter/material.dart';

class CircularMenuItem extends StatelessWidget {

  /// creates a menu item .
  /// [onTap] must not be null.
  /// [padding] and [margin]  must be equal or greater than zero.
  const CircularMenuItem({
    required this.onTap, super.key,
    this.image,
    this.color,
    this.iconSize = 30,
    this.boxShadow,
    //this.iconColor,
    this.animatedIcon,
    this.padding = 8.0,
    this.margin = 12.0,
  })  : assert(padding >= 0.0),
        assert(margin >= 0.0);
  /// if icon and animatedIcon are passed, icon will be ignored
  final Image? image;
  final Color? color;
  //final Color iconColor;
  final VoidCallback onTap;
  final double iconSize;
  final double padding;
  final double margin;
  final List<BoxShadow>? boxShadow;

  /// if animatedIcon and icon are passed, icon will be ignored
  final AnimatedIcon? animatedIcon;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Material(
          color: color ?? Theme.of(context).primaryColor,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: animatedIcon ??
                  Padding(
                    padding: const EdgeInsets.only(right: 1, bottom: 1),
                    child: SizedBox(
                      height: iconSize,
                      width: iconSize,
                      child: Center(
                        child: image,
                      ),
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
