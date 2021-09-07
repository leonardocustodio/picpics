import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/stores/language_controller.dart';

class GeneralModal extends StatelessWidget {
  final String message;
  final Function() onPressedDelete;
  final Function() onPressedOk;

  GeneralModal({
    required this.message,
    required this.onPressedDelete,
    required this.onPressedOk,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 187.0,
        width: 270.0,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Color(0xFFF1F3F5),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(14),
            bottom: Radius.circular(19.0),
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    onPressed: onPressedDelete,
                    child: Image.asset('lib/images/closegrayico.png'),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Lato',
                  color: Color(0xff606566),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            Spacer(
              flex: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoButton(
                padding: const EdgeInsets.all(0),
                onPressed: onPressedOk,
                child: Container(
                  height: 44.0,
                  decoration: BoxDecoration(
                    gradient: kPrimaryGradient,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Obx(
                      () => Text(
                        LangControl.to.S.value.continue_string,
                        textScaleFactor: 1.0,
                        style: kLoginButtonTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
