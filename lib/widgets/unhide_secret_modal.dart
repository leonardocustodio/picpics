import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/stores/language_controller.dart';
import 'package:picPics/utils/app_logger.dart';

class UnhideSecretModal extends StatelessWidget {
  final Function() onPressedDelete;
  final Function() onPressedOk;

  const UnhideSecretModal({
    super.key,
    required this.onPressedDelete,
    required this.onPressedOk,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: width < 360
          ? const EdgeInsets.symmetric(horizontal: 20.0)
          : const EdgeInsets.symmetric(horizontal: 40.0),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Color(0xFFF1F3F5),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(14),
            bottom: Radius.circular(19.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Opacity(
                    opacity: 0.0,
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
                    onPressed: () {
                      AppLogger.d('teste');
                    },
                    child: Image.asset('lib/images/closegrayico.png'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 44.0),
                child: Image.asset('lib/images/lockmodalico.png'),
              ),
              Obx(
                () => Text(
                  LangControl.to.S.value.disable_secret,
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
                padding: const EdgeInsets.only(top: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: onPressedDelete,
                        child: Container(
                          height: 44.0,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: kSecondaryColor, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Obx(
                              () => Text(
                                LangControl.to.S.value.no,
                                textScaler: TextScaler.linear(1.0),
                                style: const TextStyle(
                                  color: kSecondaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Lato',
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
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
                                LangControl.to.S.value.yes,
                                textScaler: TextScaler.linear(1.0),
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
            ],
          ),
        ),
      ),
    );
  }
}
