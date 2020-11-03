import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ToggleBar extends StatefulWidget {
  final Function onToggle;

  ToggleBar({this.onToggle});

  @override
  _ToggleBarState createState() => _ToggleBarState();
}

class _ToggleBarState extends State<ToggleBar> {
  Alignment animationAlignment = Alignment.centerLeft;

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
                      alignment: animationAlignment,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFB7B7B7),
                          borderRadius: BorderRadius.circular(19.0),
                        ),
                        child: Opacity(
                          opacity: 0.0,
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              animationAlignment == Alignment.centerLeft ? 'Months' : 'Days',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF7E7E80),
                              ),
                            ),
                            onPressed: null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Months',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: animationAlignment == Alignment.centerLeft ? Colors.white : Color(0xFF7E7E80),
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          print('Teste');
                          widget.onToggle(0);
                          setState(() {
                            animationAlignment = Alignment.centerLeft;
                          });
                        },
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Days',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: animationAlignment == Alignment.centerLeft ? Color(0xFF7E7E80) : Colors.white,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          print('Teste');
                          widget.onToggle(1);
                          setState(() {
                            animationAlignment = Alignment.centerRight;
                          });
                        },
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
