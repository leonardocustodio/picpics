import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animator/animation/animator_play_states.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/screens/email_screen.dart';
import 'package:picPics/stores/private_photos_controller.dart';
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/stores/pin_controller.dart';
import 'package:picPics/utils/helpers.dart';
import 'package:picPics/widgets/color_animated_background.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:local_auth/local_auth.dart';

// ignore_for_file: must_be_immutable
class PinScreen extends GetWidget<PinController> {
  static const String id = 'pin_screen';

  bool isLoading = false;

  CarouselController carouselController = CarouselController();
  int carouselPage = 0;

/*   @override
  void initState() {
    super.initState();
//    Analytics.sendCurrentScreen(Screen.login_screen);
  } */

  Widget _buildPinPad(BuildContext context, int index) {
    //print('&&&&&&&& BUILD PIN PAD SLIDER!!!!!');

    String title;
    GlobalKey<AnimatorWidgetState> key;

    if (controller.isWaitingRecoveryKey.value == true) {
      if (index == 0) {
        title = 'Recovery Code';
        key = controller.shakeRecovery;
      } else if (index == 1) {
        title = S.current.new_secret_key;
        key = controller.shakeKey;
      } else {
        title = S.current.confirm_secret_key;
        key = controller.shakeKeyConfirm;
      }
    } else {
      if (index == 0) {
        title = S.current.new_secret_key;
        key = controller.shakeKey;
      } else {
        title = S.current.confirm_secret_key;
        key = controller.shakeKeyConfirm;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 4.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Spacer(),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Lato',
              color: kSecondaryColor,
              fontSize: 24.0,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.4099999964237213,
            ),
          ),
          Spacer(
            flex: 2,
          ),
          Shake(
            key: key,
            preferences:
                AnimationPreferences(autoPlay: AnimationPlayStates.None),
            child: Obx(() {
              int filledPositions;

              if (controller.isWaitingRecoveryKey.value == true) {
                if (index == 0) {
                  filledPositions = controller.recoveryCode.value.length;
                } else if (index == 1) {
                  filledPositions = controller.pinTemp.value.length;
                } else {
                  filledPositions = controller.confirmPinTemp.value.length;
                }
              } else {
                if (index == 0) {
                  filledPositions = controller.pinTemp.value.length;
                } else {
                  filledPositions = controller.confirmPinTemp.value.length;
                }
              }

              return PinPlaceholder(
                filledPositions: filledPositions,
                totalPositions: 6,
              );
            }),
          ),
          Spacer(),
          NumberPad(
            onPinTapped: pinTapped,
          ),
          Spacer(),
          if (controller.isWaitingRecoveryKey.value != true) ...[
            CupertinoButton(
              onPressed: () {
                if (UserController.to.email == null) {
                  controller.askEmail();
                  return;
                }
                controller.recoverPin();
              },
              child: Text(
                'Already have an account?',
                style: TextStyle(
                  fontFamily: 'Lato',
                  color: kWhiteColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            Spacer(
              flex: 2,
            ),
          ]
        ],
      ),
    );
  }

  void pinTapped(String value) async {
    //print('Value: ${controller.recoveryCode}${value}');
    if (controller.isWaitingRecoveryKey.value == true) {
      if (carouselPage == 0) {
        if (value == '\u0008') {
          controller.setRecoveryCode(
              Helpers.removeLastCharacter(controller.recoveryCode.value));
          return;
        }
        controller.setRecoveryCode('${controller.recoveryCode}$value');

        if (controller.recoveryCode.value.length == 6) {
          // set true
          final valid = await controller.isRecoveryCodeValid(UserController.to);

          if (valid) {
            await carouselController.nextPage();
            carouselPage = 1;
            controller.setRecoveryCode('');
            return;
          }

          controller.shakeRecovery.currentState?.forward();
          controller.setRecoveryCode('');
        }
        return;
      }

      if (carouselPage == 1) {
        if (value == '\u0008') {
          controller.setPinTemp(
              Helpers.removeLastCharacter(controller.pinTemp.value));
          return;
        }
        controller.setPinTemp('${controller.pinTemp}$value');

        if (controller.pinTemp.value.length == 6) {
          carouselPage = 2;
          await carouselController.nextPage();
        }
        return;
      }

      if (value == '\u0008') {
        controller.setConfirmPinTemp(
            Helpers.removeLastCharacter(controller.confirmPinTemp.value));
        return;
      }
      controller.setConfirmPinTemp('${controller.confirmPinTemp}$value');

      if (controller.confirmPinTemp.value.length == 6) {
        if (controller.pinTemp == controller.confirmPinTemp) {
          //print('Setting new pin!!!!!');
          carouselPage = 0;
          controller.pin = controller.pinTemp.value;
          await UserController.to.setEmail(controller.email
              .value); // Tem que deixar antes pois é utilizado quando salva o pin

          await controller.saveNewPin(UserController.to);

          await UserController.to.setIsPinRegistered(true);
          await PrivatePhotosController.to.switchSecretPhotos();
          //GalleryStore.to.checkIsLibraryUpdated();
          controller.setPinTemp('');
          controller.setConfirmPinTemp('');
          UserController.to.setWaitingAccessCode(false);
          await carouselController.animateToPage(0);

          Get.back();
        } else {
          controller.shakeKeyConfirm.currentState?.forward();
          Future.delayed(Duration(seconds: 1, milliseconds: 300), () {
            carouselPage = 1;
            controller.setPinTemp('');
            controller.setConfirmPinTemp('');
            carouselController.animateToPage(1);
          });
        }
      }

      return;
    }

    if (UserController.to.isPinRegistered.value == true) {
      if (value == '\u0008') {
        controller
            .setPinTemp(Helpers.removeLastCharacter(controller.pinTemp.value));
        return;
      }
      controller.setPinTemp('${controller.pinTemp}$value');

      if (controller.pinTemp.value.length == 6) {
        // set true
        final valid = await controller.isPinValid(UserController.to);

        if (valid) {
          if (UserController.to.wantsToActivateBiometric) {
            await controller.activateBiometric(UserController.to);
            await UserController.to.setIsBiometricActivated(true);

            controller.setPinTemp('');
            controller.setConfirmPinTemp('');
            Get.back();
            return;
          }

          await PrivatePhotosController.to.switchSecretPhotos();
          //GalleryStore.to.checkIsLibraryUpdated();

          controller.setPinTemp('');
          controller.setConfirmPinTemp('');
          Get.back();
          return;
        }

        controller.shakeKey.currentState?.forward();
        controller.setPinTemp('');
        controller.setConfirmPinTemp('');
      }
      return;
    }

    if (UserController.to.waitingAccessCode.value == true) {
      if (value == '\u0008') {
        controller.setAccessCode(
            Helpers.removeLastCharacter(controller.accessCode.value));
        return;
      }
      controller.setAccessCode('${controller.accessCode}$value');

      if (controller.accessCode.value.length == 6) {
        await controller.validateAccessCode();
      }
      return;
    }

    if (carouselPage == 0) {
      controller.setPinTemp('${controller.pinTemp}$value');

      if (controller.pinTemp.value.length == 6) {
        carouselPage = 1;
        await carouselController.nextPage();
      }
      return;
    }

    if (value == '\u0008') {
      controller.setConfirmPinTemp(
          Helpers.removeLastCharacter(controller.confirmPinTemp.value));
      return;
    }
    controller.setConfirmPinTemp('${controller.confirmPinTemp}$value');

    if (controller.confirmPinTemp.value.length == 6) {
      if (controller.pinTemp == controller.confirmPinTemp) {
        carouselPage = 0;
        controller.pin = controller.pinTemp.value;
        controller.setPinTemp('');
        controller.setConfirmPinTemp('');
        await carouselController.animateToPage(0);
        await Get.toNamed(EmailScreen.id);
      } else {
        controller.shakeKeyConfirm.currentState?.forward();
        Future.delayed(Duration(seconds: 1, milliseconds: 300), () {
          carouselPage = 0;
          controller.setPinTemp('');
          controller.setConfirmPinTemp('');
          carouselController.animateToPage(0);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
          children: <Widget>[
            ColorAnimatedBackground(
              moveByX: 60.0,
              moveByY: 40.0,
            ),
            SafeArea(
              bottom: false,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10.0),
                        onPressed: () {
                          if (controller.isWaitingRecoveryKey.value == true) {
                            controller.setIsWaitingRecoveryKey(false);
                          }
                          Get.back();
                        },
                        child: Image.asset(
                            'lib/images/backarrowwithdropshadow.png'),
                      ),
                      /*  CupertinoButton(
                          onPressed: () {
                              restorePurchase();
                          },
                          child: Text(
                            S.current.restore_purchase,
                            textScaleFactor: 1.0,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xff979a9b),
                              decoration: TextDecoration.underline,
                              fontFamily: "Lato",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0,
                              letterSpacing: -0.4099999964237213,
                            ),
                          ),
                        ), */
                    ],
                  ),
                  Expanded(
                    child: Obx(() {
                      if (controller.isWaitingRecoveryKey.value == true) {
                        return CarouselSlider.builder(
                          carouselController: carouselController,
                          itemCount: 3,
                          itemBuilder:
                              (BuildContext context, int index, int _) {
                            return _buildPinPad(context, index);
                          },
                          options: CarouselOptions(
                            initialPage: 0,
                            enableInfiniteScroll: false,
                            height: double.maxFinite,
                            viewportFraction: 1.0,
                            scrollPhysics: NeverScrollableScrollPhysics(),
                          ),
                        );

                        // return Column(
                        //   children: [
                        //     Spacer(),
                        //     Text(
                        //       'Recovery Code',
                        //       style: TextStyle(
                        //         fontFamily: 'Lato',
                        //         color: kSecondaryColor,
                        //         fontSize: 24.0,
                        //         fontWeight: FontWeight.w400,
                        //         fontStyle: FontStyle.normal,
                        //         letterSpacing: -0.4099999964237213,
                        //       ),
                        //     ),
                        //     Spacer(),
                        //     Shake(
                        //       key: controller.shakeRecovery,
                        //       preferences: AnimationPreferences(autoPlay: AnimationPlayStates.None),
                        //       child: Observer(builder: (_) {
                        //         return PinPlaceholder(
                        //           filledPositions: controller.recoveryCode.length,
                        //           totalPositions: 6,
                        //         );
                        //       }),
                        //     ),
                        //     Spacer(),
                        //     NumberPad(
                        //       onPinTapped: pinTapped,
                        //     ),
                        //     Spacer(),
                        //   ],
                        // );
                      }

                      if (UserController.to.isPinRegistered.value == true) {
                        String? assetImage;

                        if (UserController.to.isBiometricActivated.value ==
                            true) {
                          if (UserController.to.availableBiometrics
                              .contains(BiometricType.face)) {
                            assetImage = 'lib/images/faceidwhiteico.png';
                          } else if (UserController.to.availableBiometrics
                              .contains(BiometricType.iris)) {
                            assetImage = 'lib/images/irisscannerwhiteico.png';
                          } else if (UserController.to.availableBiometrics
                              .contains(BiometricType.fingerprint)) {
                            assetImage = 'lib/images/fingerprintwhiteico.png';
                          }
                        }

                        return Column(
                          children: [
                            Spacer(),
                            Text(
                              S.current.your_secret_key,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                color: kSecondaryColor,
                                fontSize: 24.0,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                letterSpacing: -0.4099999964237213,
                              ),
                            ),
                            Spacer(
                              flex: 2,
                            ),
                            Shake(
                              key: controller.shakeKey,
                              preferences: AnimationPreferences(
                                  autoPlay: AnimationPlayStates.None),
                              child: Obx(() {
                                return PinPlaceholder(
                                  filledPositions:
                                      controller.pinTemp.value.length,
                                  totalPositions: 6,
                                );
                              }),
                            ),
                            Spacer(),
                            NumberPad(
                              onPinTapped: pinTapped,
                            ),
                            Spacer(),
                            if (assetImage != null)
                              CupertinoButton(
                                onPressed: () {
                                  controller.authenticate();
                                },
                                child: Image.asset(assetImage),
                              ),
                            if (UserController.to.wantsToActivateBiometric !=
                                true)
                              CupertinoButton(
                                onPressed: () {
                                  controller.recoverPin();
                                },
                                child: Text(
                                  S.current.forgot_secret_key,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: kWhiteColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            Spacer(
                              flex: 2,
                            ),
                          ],
                        );
                      }

                      if (UserController.to.waitingAccessCode.value == false) {
                        return CarouselSlider.builder(
                          carouselController: carouselController,
                          itemCount: 2,
                          itemBuilder:
                              (BuildContext context, int index, int _) {
                            return _buildPinPad(context, index);
                          },
                          options: CarouselOptions(
                            initialPage: 0,
                            enableInfiniteScroll: false,
                            height: double.maxFinite,
                            viewportFraction: 1.0,
                            scrollPhysics: NeverScrollableScrollPhysics(),
                          ),
                        );
                      }
                      return Column(
                        children: [
                          Spacer(),
                          Text(
                            controller.invalidAccessCode.value
                                ? 'Invalid Access Code'
                                : S.current.access_code,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: kSecondaryColor,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              letterSpacing: -0.4099999964237213,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              S.current.access_code_sent(
                                  '${controller.email.value.isEmpty ? 'user@email.com' : controller.email.value.isEmpty}'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                color: kWhiteColor,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          Spacer(),
                          Shake(
                            key: controller.shakeKey,
                            preferences: AnimationPreferences(
                                autoPlay: AnimationPlayStates.None),
                            child: Obx(
                              () {
                                return PinPlaceholder(
                                  filledPositions:
                                      controller.accessCode.value.length,
                                  totalPositions: 6,
                                );
                              },
                            ),
                          ),
                          Spacer(),
                          NumberPad(
                            onPinTapped: pinTapped,
                          ),
                          Spacer(),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: SpinKitChasingDots(
                    color: kPrimaryColor,
                    size: 80.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PinPlaceholder extends StatelessWidget {
  final int totalPositions;
  final int filledPositions;

  PinPlaceholder({
    this.totalPositions = 6,
    this.filledPositions = 0,
  });

  List<Widget> _buildPinPlaceholders() {
    final items = <Widget>[];

    for (var x = 0; x < totalPositions; x++) {
      items.add(
        Container(
          width: 16.0,
          height: 16.0,
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: x < filledPositions ? kWhiteColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: kWhiteColor,
              width: 2.0,
            ),
          ),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildPinPlaceholders(),
    );
  }
}

class NumberPad extends StatelessWidget {
  final Function onPinTapped;

  const NumberPad({
    required this.onPinTapped,
  });

  List<Widget> _buildPinNumbers() {
    final items = <Widget>[];

    var pin = 1;
    for (var x = 0; x < 4; x++) {
      final number = <Widget>[];

      for (var y = 0; y < 3; y++) {
        if (pin == 10) {
          number.add(
            GestureDetector(
              onTap: () {
                onPinTapped('\u0008');
              },
              child: Container(
                height: 44.0,
                width: 44.0,
                child: Image.asset('lib/images/backspacewhite.png'),
              ),
            ),
          );
          pin++;
          continue;
        }

        var value = pin;
        number.add(
          GestureDetector(
            // padding: const EdgeInsets.all(0),
            //minSize: 44.0,
            onTap: () {
              onPinTapped('${value == 11 ? '0' : value}');
            },
            child: Container(
              width: 44,
              height: 44,
              child: Center(
                child: Text(
                  '${pin == 11 ? '0' : pin}',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    color: pin == 12 ? Colors.transparent : kWhiteColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.4099999964237213,
                  ),
                ),
              ),
            ),
          ),
        );
        pin++;
      }

      items.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: number,
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 304.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: _buildPinNumbers(),
      ),
    );
  }
}
