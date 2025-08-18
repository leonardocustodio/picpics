import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/stores/language_controller.dart';
import 'package:picpics/stores/user_controller.dart';
import 'package:picpics/utils/app_logger.dart';

class DeleteSecretModal extends StatefulWidget {

  const DeleteSecretModal({
    required this.onPressedClose, required this.onPressedDelete, required this.onPressedOk, super.key,
  });
  final Function() onPressedClose;
  final Function() onPressedDelete;
  final Function() onPressedOk;

  @override
  DeleteSecretModalState createState() => DeleteSecretModalState();
}

class DeleteSecretModalState extends State<DeleteSecretModal> {
  bool keepAsking = true;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    AppLogger.d('Width: $width');

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: width < 360
          ? const EdgeInsets.symmetric(horizontal: 20)
          : const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Color(0xFFF1F3F5),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(14),
            bottom: Radius.circular(19),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Opacity(
                    opacity: 0,
                    child: CupertinoButton(
                      onPressed: () {
                        AppLogger.d('teste');
                      },
                      child: Image.asset('lib/images/closegrayico.png'),
                    ),
                  ),
                  Obx(
                    () => Text(
                      LangControl.to.S.value.secret_photos,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        color: Color(0xff979a9b),
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: -0.4099999964237213,
                      ),
                    ),
                  ),
                  CupertinoButton(
                    onPressed: widget.onPressedClose,
                    child: Image.asset('lib/images/closegrayico.png'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 44),
                child: Image.asset('lib/images/lockmodalico.png'),
              ),
              Obx(
                () => Text(
                  LangControl.to.S.value.keep_safe,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    color: Color(0xff707070),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      onPressed: () {
                        setState(() {
                          keepAsking = true;
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: keepAsking
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      colors: [
                                        kSecondaryColor,
                                        Color(0xffff7878),
                                      ],
                                      stops: [0, 1],
                                      end: Alignment(1, -0),
                                    ),
                                  )
                                : BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFFB2C2C3),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                            child: keepAsking
                                ? Image.asset('lib/images/checkwhiteico.png')
                                : null,
                          ),
                          Obx(
                            () => Text(
                              LangControl.to.S.value.keep_asking,
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                color: Color(0xff707070),
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 16),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      onPressed: () {
                        setState(() {
                          keepAsking = false;
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: !keepAsking
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      colors: [
                                        kSecondaryColor,
                                        Color(0xffff7878),
                                      ],
                                      stops: [0, 1],
                                      end: Alignment(1, -0),
                                    ),
                                  )
                                : BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFFB2C2C3),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                            child: !keepAsking
                                ? Image.asset('lib/images/checkwhiteico.png')
                                : null,
                          ),
                          Obx(
                            () => Text(
                              LangControl.to.S.value.dont_ask_again,
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                color: Color(0xff707070),
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 26),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          if (keepAsking == false) {
                            UserController.to.setKeepAskingToDelete(false);
                          }
                          widget.onPressedDelete();
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: kSecondaryColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Obx(
                              () => Text(
                                LangControl.to.S.value.no,
                                textScaler: const TextScaler.linear(1),
                                style: const TextStyle(
                                  color: kSecondaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Lato',
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 16),
                    ),
                    Expanded(
                      child: CupertinoButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          if (keepAsking == false) {
                            UserController.to.setKeepAskingToDelete(false);
                          }
                          widget.onPressedOk();
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: kPrimaryGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Obx(
                              () => Text(
                                LangControl.to.S.value.yes,
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
              Obx(
                () => Text(
                  LangControl.to.S.value.view_hidden_photos,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    color: Color(0xff707070),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
