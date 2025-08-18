import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/stores/language_controller.dart';

class GeneralModal extends StatelessWidget {

  const GeneralModal({
    required this.message, required this.onPressedDelete, required this.onPressedOk, super.key,
  });
  final String message;
  final Function() onPressedDelete;
  final Function() onPressedOk;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 187,
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
              padding: const EdgeInsets.all(8),
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
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  color: Color(0xff606566),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            const Spacer(
              flex: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CupertinoButton(
                padding: const EdgeInsets.all(0),
                onPressed: onPressedOk,
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: kPrimaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Obx(
                      () => Text(
                        LangControl.to.S.value.continue_string,
                        textScaler: const TextScaler.linear(1),
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
