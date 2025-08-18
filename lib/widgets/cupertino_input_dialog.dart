import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picpics/constants.dart';

class CupertinoInputDialog extends StatelessWidget {

  const CupertinoInputDialog({
    required this.title, required this.destructiveButtonTitle, required this.defaultButtonTitle, required this.onPressedDestructive, required this.onPressedDefault, required this.alertInputController, super.key,
    this.inputPlaceholder,
    this.prefixImage,
  });
  final String title;
  final String? inputPlaceholder;

  final String destructiveButtonTitle;
  final String defaultButtonTitle;

  final Function() onPressedDestructive;
  final Function() onPressedDefault;

  final Image? prefixImage;
  final TextEditingController alertInputController;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 156,
        width: 270,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Color(0xFFF1F3F5),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(14),
            bottom: Radius.circular(19),
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 19, bottom: 10),
              child: Text(
                title,
                textScaler: const TextScaler.linear(1),
                style: const TextStyle(
                  color: Color(0xff606566),
                  fontSize: 16,
                  fontFamily: 'Lato',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(color: kLightGrayColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: <Widget>[
                  if (prefixImage != null) prefixImage!,
                  Expanded(
                    child: TextField(
                      controller: alertInputController,
                      autofocus: true,
                      style: const TextStyle(
                        color: Color(0xff606566),
                        fontSize: 16,
                        fontFamily: 'Lato',
                      ),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 6),
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: <Widget>[
                Expanded(
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: onPressedDestructive,
                    child: Container(
                      color: const Color(0xFFF5FAFA),
                      height: 48,
                      child: Center(
                        child: Text(
                          destructiveButtonTitle,
                          textScaler: const TextScaler.linear(1),
                          style: const TextStyle(
                            color: Color(0xFFE01717),
                            fontSize: 16,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: onPressedDefault,
                    child: Container(
                      color: const Color(0xFFF5FAFA),
                      height: 48,
                      child: Center(
                        child: Text(
                          defaultButtonTitle,
                          textScaler: const TextScaler.linear(1),
                          style: const TextStyle(
                            color: Color(0xFF606566),
                            fontSize: 16,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
