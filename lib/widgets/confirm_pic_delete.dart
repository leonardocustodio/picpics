import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/stores/language_controller.dart';
import 'package:picpics/utils/app_logger.dart';

class ConfirmPicDelete extends StatelessWidget {

  const ConfirmPicDelete({
    required this.onPressedDelete, super.key,
    this.deleteText = 'Are you sure you want to delete photo ?',
    this.onPressedClose,
  });
  final String deleteText;
  final void Function()? onPressedClose;
  final void Function() onPressedDelete;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: Get.width < 360
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
                        Get.back<void>();
                        AppLogger.d('teste');
                      },
                      child: Image.asset('lib/images/closegrayico.png'),
                    ),
                  ),
                  const Text(
                    'Delete Photo',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      color: Color(0xff979a9b),
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: -0.4099999964237213,
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      onPressedClose?.call();
                      Get.back<void>();
                    },
                    child: Image.asset('lib/images/closegrayico.png'),
                  ),
                ],
              ),
              /* Padding(
                padding: const EdgeInsets.symmetric(vertical: 44.0),
                child: Image.asset('lib/images/lockmodalico.png'),
              ), */
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  deleteText,
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
                padding: const EdgeInsets.only(bottom: 5, top: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          /* if (keepAsking == false) {
                            UserController.to.setKeepAskingToDelete(false);
                          } */
                          onPressedClose?.call();
                          Get.back<void>();
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
                                LangControl.to.S.value.cancel,
                                textScaler: const TextScaler.linear(1),
                                style: kLoginButtonTextStyle,
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
                        onPressed: onPressedDelete,
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
                                LangControl.to.S.value.delete,
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
