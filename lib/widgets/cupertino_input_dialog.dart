import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/constants.dart';

class CupertinoInputDialog extends StatelessWidget {
  final String title;
  final String? inputPlaceholder;

  final String destructiveButtonTitle;
  final String defaultButtonTitle;

  final Function() onPressedDestructive;
  final Function() onPressedDefault;

  final Image? prefixImage;
  final TextEditingController alertInputController;

  const CupertinoInputDialog({
    super.key,
    required this.title,
    this.inputPlaceholder,
    required this.destructiveButtonTitle,
    required this.defaultButtonTitle,
    required this.onPressedDestructive,
    required this.onPressedDefault,
    this.prefixImage,
    required this.alertInputController,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 156.0,
        width: 270.0,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Color(0xFFF1F3F5),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(14),
            bottom: Radius.circular(19.0),
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 19.0, bottom: 10.0),
              child: Text(
                title,
                textScaleFactor: 1.0,
                style: const TextStyle(
                  color: Color(0xff606566),
                  fontSize: 16,
                  fontFamily: 'Lato',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              height: 30.0,
              decoration: BoxDecoration(
                border: Border.all(color: kLightGrayColor, width: 1.0),
                borderRadius: BorderRadius.circular(12.0),
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
                        contentPadding: EdgeInsets.only(left: 6.0),
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
                      height: 48.0,
                      child: Center(
                        child: Text(
                          destructiveButtonTitle,
                          textScaleFactor: 1.0,
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
                      height: 48.0,
                      child: Center(
                        child: Text(
                          defaultButtonTitle,
                          textScaleFactor: 1.0,
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
            )
          ],
        ),
      ),
    );
  }
}
