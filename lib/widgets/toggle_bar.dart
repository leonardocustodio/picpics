import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picpics/utils/app_logger.dart';

class ToggleBar extends StatefulWidget {

  const ToggleBar({
    required this.titleLeft, required this.titleRight, required this.activeToggle, required this.onToggle, super.key,
  });
  final int activeToggle;
  final Function onToggle;

  final String titleLeft;
  final String titleRight;

  @override
  ToggleBarState createState() => ToggleBarState();
}

class ToggleBarState extends State<ToggleBar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 2,
          sigmaY: 2,
        ),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(22),
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
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 4,),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB7B7B7),
                          borderRadius: BorderRadius.circular(19),
                        ),
                        child: Opacity(
                          opacity: 0,
                          child: CupertinoButton(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            onPressed: null,
                            child: Text(
                              widget.activeToggle == 0
                                  ? widget.titleLeft
                                  : widget.titleRight,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        onPressed: () {
                          AppLogger.d('Teste');
                          widget.onToggle(0);
                        },
                        child: Text(
                          widget.titleLeft,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: widget.activeToggle == 0
                                ? Colors.white
                                : const Color(0xFF7E7E80),
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        onPressed: () {
                          AppLogger.d('Teste');
                          widget.onToggle(1);
                        },
                        child: Text(
                          widget.titleRight,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: widget.activeToggle == 0
                                ? const Color(0xFF7E7E80)
                                : Colors.white,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
