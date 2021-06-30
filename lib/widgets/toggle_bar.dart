import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ToggleBar extends StatefulWidget {
  final int activeToggle;
  final Function onToggle;

  final String titleLeft;
  final String titleRight;

  ToggleBar({
    required this.titleLeft,
    required this.titleRight,
    required this.activeToggle,
    required this.onToggle,
  });

  @override
  _ToggleBarState createState() => _ToggleBarState();
}

class _ToggleBarState extends State<ToggleBar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 2.0,
          sigmaY: 2.0,
        ),
        child: Container(
          height: 44.0,
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5).withOpacity(0.8),
            borderRadius: BorderRadius.circular(22.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Stack(
                children: [
                  Positioned.fill(
                    child: AnimatedAlign(
                      alignment: widget.activeToggle == 0
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFB7B7B7),
                          borderRadius: BorderRadius.circular(19.0),
                        ),
                        child: Opacity(
                          opacity: 0.0,
                          child: CupertinoButton(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            onPressed: null,
                            child: Text(
                              widget.activeToggle == 0
                                  ? widget.titleLeft
                                  : widget.titleRight,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF7E7E80),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        onPressed: () {
                          //print('Teste');
                          widget.onToggle(0);
                        },
                        child: Text(
                          widget.titleLeft,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: widget.activeToggle == 0
                                ? Colors.white
                                : Color(0xFF7E7E80),
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        onPressed: () {
                          //print('Teste');
                          widget.onToggle(1);
                        },
                        child: Text(
                          widget.titleRight,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: widget.activeToggle == 0
                                ? Color(0xFF7E7E80)
                                : Colors.white,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
