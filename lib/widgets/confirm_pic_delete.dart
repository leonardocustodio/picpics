import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/stores/language_controller.dart';

class ConfirmPicDelete extends StatelessWidget {
  final String deleteText;
  final Function()? onPressedClose;
  final Function() onPressedDelete;

  const ConfirmPicDelete({
    super.key,
    this.deleteText = 'Are you sure you want to delete photo ?',
    this.onPressedClose,
    required this.onPressedDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: Get.width < 360
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
                        Get.back();
                        print('teste');
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
                      Get.back();
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
                padding: const EdgeInsets.only(top: 10.0),
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
                padding: const EdgeInsets.only(bottom: 5.0, top: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          /* if (keepAsking == false) {
                            UserController.to.setKeepAskingToDelete(false);
                          } */
                          onPressedClose?.call();
                          Get.back();
                        },
                        child: Container(
                          height: 44.0,
                          decoration: BoxDecoration(
                            gradient: kPrimaryGradient,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Obx(
                              () => Text(
                                LangControl.to.S.value.cancel,
                                textScaler: TextScaler.linear(1.0),
                                style: kLoginButtonTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 16.0),
                    ),
                    Expanded(
                      child: CupertinoButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          /* if (keepAsking == false) {
                            UserController.to.setKeepAskingToDelete(false);
                          } */
                          onPressedDelete();
                        },
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
                                LangControl.to.S.value.delete,
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
