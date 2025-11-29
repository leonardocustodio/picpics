import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/screens/email_screen.dart';
import 'package:picpics/stores/language_controller.dart';
import 'package:picpics/stores/pin_controller.dart';
import 'package:picpics/stores/private_photos_controller.dart';
import 'package:picpics/stores/user_controller.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/helpers.dart';
import 'package:picpics/widgets/color_animated_background.dart';

// ignore_for_file: must_be_immutable
class PinScreen extends GetWidget<PinController> {

  PinScreen({super.key});
  static const String id = 'pin_screen';

  CarouselSliderController carouselController = CarouselSliderController();
  // late GlobalKey<AnimatorWidgetState> animatorKey;

  int carouselPage = 0;

/*   @override
  void initState() {
    super.initState();
//    Analytics.sendCurrentScreen(Screen.login_screen);
  } */

  Widget _buildPinPad(BuildContext context, int index) {
    AppLogger.d('&&&&&&&& BUILD PIN PAD SLIDER!!!!!');

    String title;

    if (controller.isWaitingRecoveryKey.value == true) {
      if (index == 0) {
        title = 'Recovery Code';
        // animatorKey = controller.shakeRecovery;
      } else if (index == 1) {
        title = LangControl.to.S.value.new_secret_key;
        // animatorKey = controller.shakeKey;
      } else {
        title = LangControl.to.S.value.confirm_secret_key;
        // animatorKey = controller.shakeKeyConfirm;
      }
    } else {
      if (index == 0) {
        title = LangControl.to.S.value.new_secret_key;
        // animatorKey = controller.shakeKey;
      } else {
        title = LangControl.to.S.value.confirm_secret_key;
        // animatorKey = controller.shakeKeyConfirm;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 4,
      ),
      child: Column(
        children: [
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Lato',
              color: kSecondaryColor,
              fontSize: 24,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.4099999964237213,
            ),
          ),
          const Spacer(
            flex: 2,
          ),
          Shake(
            key: key,
            preferences:
                const AnimationPreferences(autoPlay: AnimationPlayStates.None),
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
              );
            }),
          ),
          const Spacer(),
          NumberPad(
            onPinTapped: pinTapped,
          ),
          const Spacer(),
          if (controller.isWaitingRecoveryKey.value != true) ...[
            CupertinoButton(
              onPressed: () {
                if (UserController.to.email == null) {
                  controller.askEmail();
                  return;
                }
                controller.recoverPin();
              },
              child: const Text(
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
            const Spacer(
              flex: 2,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> pinTapped(String value, bool backspace) async {
    AppLogger.d('Value: ${controller.recoveryCode}$value');
    if (controller.isWaitingRecoveryKey.value == true) {
      if (carouselPage == 0) {
        if (backspace) {
          controller.setRecoveryCode(
              Helpers.removeLastCharacter(controller.recoveryCode.value),);
          return;
        }
        controller.setRecoveryCode('${controller.recoveryCode.value}$value');

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
        if (backspace) {
          controller.setPinTemp(
              Helpers.removeLastCharacter(controller.pinTemp.value),);
          return;
        }
        controller.setPinTemp('${controller.pinTemp.value}$value');

        if (controller.pinTemp.value.length == 6) {
          carouselPage = 2;
          await carouselController.nextPage();
        }
        return;
      }

      if (backspace) {
        controller.setConfirmPinTemp(
            Helpers.removeLastCharacter(controller.confirmPinTemp.value),);
        return;
      }
      controller.setConfirmPinTemp('${controller.confirmPinTemp.value}$value');

      if (controller.confirmPinTemp.value.length == 6) {
        if (controller.pinTemp.value == controller.confirmPinTemp.value) {
          AppLogger.d('Setting new pin!!!!!');
          carouselPage = 0;
          controller.pin = controller.pinTemp.value;
          await UserController.to.setEmail(controller.email
              .value,); // Tem que deixar antes pois é utilizado quando salva o pin

          await controller.saveNewPin(UserController.to);

          await UserController.to.setIsPinRegistered(true);
          await PrivatePhotosController.to.switchSecretPhotos();
          //GalleryStore.to.checkIsLibraryUpdated();
          controller.setPinTemp('');
          controller.setConfirmPinTemp('');
          UserController.to.setWaitingAccessCode(false);
          await carouselController.animateToPage(0);

          Get.back<void>();
        } else {
          controller.shakeKeyConfirm.currentState?.forward();
          Future.delayed(const Duration(seconds: 1, milliseconds: 300), () {
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
      if (backspace) {
        controller
            .setPinTemp(Helpers.removeLastCharacter(controller.pinTemp.value));
        return;
      }
      controller.setPinTemp('${controller.pinTemp.value}$value');

      if (controller.pinTemp.value.length == 6) {
        // set true
        final valid = await controller.isPinValid();

        if (valid) {
          if (UserController.to.wantsToActivateBiometric) {
            await controller.activateBiometric();
            await UserController.to.setIsBiometricActivated(true);

            controller.setPinTemp('');
            controller.setConfirmPinTemp('');
            Get.back<void>();
            return;
          }

          await PrivatePhotosController.to.switchSecretPhotos();
          //GalleryStore.to.checkIsLibraryUpdated();

          controller.setPinTemp('');
          controller.setConfirmPinTemp('');
          Get.back<void>();
          return;
        }

        controller.shakeKey.currentState?.forward();
        controller.setPinTemp('');
        controller.setConfirmPinTemp('');
      }
      return;
    }

    if (UserController.to.waitingAccessCode.value == true) {
      if (backspace) {
        controller.setAccessCode(
            Helpers.removeLastCharacter(controller.accessCode.value),);
        return;
      }
      controller.setAccessCode('${controller.accessCode.value}$value');

      if (controller.accessCode.value.length == 6) {
        await controller.validateAccessCode();
      }
      return;
    }

    if (carouselPage == 0) {
      if (backspace) {
        controller
            .setPinTemp(Helpers.removeLastCharacter(controller.pinTemp.value));
        return;
      }
      controller.setPinTemp('${controller.pinTemp.value}$value');

      if (controller.pinTemp.value.length == 6) {
        carouselPage = 1;
        await carouselController.nextPage();
      }
      return;
    }

    if (backspace) {
      controller.setConfirmPinTemp(
          Helpers.removeLastCharacter(controller.confirmPinTemp.value),);
      return;
    }

    controller.setConfirmPinTemp('${controller.confirmPinTemp.value}$value');

    if (controller.confirmPinTemp.value.length == 6) {
      if (controller.pinTemp.value == controller.confirmPinTemp.value) {
        carouselPage = 0;
        controller.pin = controller.pinTemp.value;
        controller.setPinTemp('');
        controller.setConfirmPinTemp('');
        await carouselController.animateToPage(0);
        await Get.toNamed<void>(EmailScreen.id);
      } else {
        controller.shakeKeyConfirm.currentState?.forward();
        Future.delayed(const Duration(seconds: 1, milliseconds: 300), () {
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
        child: Obx(
          () => Stack(
            children: <Widget>[
              const ColorAnimatedBackground(
                moveByX: 60,
                moveByY: 40,
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
                              horizontal: 5, vertical: 10,),
                          onPressed: () {
                            if (controller.isWaitingRecoveryKey.value == true) {
                              controller.setIsWaitingRecoveryKey(false);
                            }
                            Get.back<void>();
                          },
                          child: Image.asset(
                              'lib/images/backarrowwithdropshadow.png',),
                        ),
                        /*  CupertinoButton(
                            onPressed: () {
                                restorePurchase();
                            },
                            child: Text(
                              LangControl.to.S.value.restore_purchase,
                              textScaler: TextScaler.linear(1.0),
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
                              enableInfiniteScroll: false,
                              height: double.maxFinite,
                              viewportFraction: 1,
                              scrollPhysics:
                                  const NeverScrollableScrollPhysics(),
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
                              const Spacer(),
                              Obx(
                                () => Text(
                                  LangControl.to.S.value.your_secret_key,
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    color: kSecondaryColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: -0.4099999964237213,
                                  ),
                                ),
                              ),
                              const Spacer(
                                flex: 2,
                              ),
                              Shake(
                                key: controller.shakeKey,
                                preferences: const AnimationPreferences(
                                    autoPlay: AnimationPlayStates.None,),
                                child: Obx(() {
                                  return PinPlaceholder(
                                    filledPositions:
                                        controller.pinTemp.value.length,
                                  );
                                }),
                              ),
                              const Spacer(),
                              NumberPad(
                                onPinTapped: pinTapped,
                              ),
                              const Spacer(),
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
                                  child: Obx(
                                    () => Text(
                                      LangControl.to.S.value.forgot_secret_key,
                                      style: const TextStyle(
                                        fontFamily: 'Lato',
                                        color: kWhiteColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              const Spacer(
                                flex: 2,
                              ),
                            ],
                          );
                        }

                        if (UserController.to.waitingAccessCode.value ==
                            false) {
                          return CarouselSlider.builder(
                            carouselController: carouselController,
                            itemCount: 2,
                            itemBuilder:
                                (BuildContext context, int index, int _) {
                              return _buildPinPad(context, index);
                            },
                            options: CarouselOptions(
                              enableInfiniteScroll: false,
                              height: double.maxFinite,
                              viewportFraction: 1,
                              scrollPhysics:
                                  const NeverScrollableScrollPhysics(),
                            ),
                          );
                        }
                        return Column(
                          children: [
                            const Spacer(),
                            Obx(
                              () => Text(
                                controller.invalidAccessCode.value
                                    ? 'Invalid Access Code'
                                    : LangControl.to.S.value.access_code,
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  color: kSecondaryColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: -0.4099999964237213,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Obx(
                                () => Text(
                                  LangControl.to.S.value.access_code_sent(
                                      controller.email.value.isEmpty
                                          ? 'user@email.com'
                                          : controller.email.value,),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    color: kWhiteColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Shake(
                              key: controller.shakeKey,
                              preferences: const AnimationPreferences(
                                  autoPlay: AnimationPlayStates.None,),
                              child: Obx(
                                () {
                                  return PinPlaceholder(
                                    filledPositions:
                                        controller.accessCode.value.length,
                                  );
                                },
                              ),
                            ),
                            const Spacer(),
                            NumberPad(
                              onPinTapped: pinTapped,
                            ),
                            const Spacer(),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
              if (controller.isLoading.value)
                ColoredBox(
                  color: Colors.black.withValues(alpha: 0.7),
                  child: const Center(
                    child: SpinKitChasingDots(
                      color: kPrimaryColor,
                      size: 80,
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

class PinPlaceholder extends StatelessWidget {

  const PinPlaceholder({
    super.key,
    this.totalPositions = 6,
    this.filledPositions = 0,
  });
  final int totalPositions;
  final int filledPositions;

  List<Widget> _buildPinPlaceholders() {
    final items = <Widget>[];

    for (var x = 0; x < totalPositions; x++) {
      items.add(
        Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: x < filledPositions ? kWhiteColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: kWhiteColor,
              width: 2,
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

  const NumberPad({
    required this.onPinTapped, super.key,
  });
  final void Function(String, bool) onPinTapped;

  List<Widget> _buildPinNumbers() {
    final items = <Widget>[];

    for (var x = 1; x < 13; (x += 3)) {
      final number = <Widget>[];
      for (var y = 0; y < 3; y++) {
        final pin = x + y;
        if (pin == 10) {
          number.add(
            Expanded(
              child: CupertinoButton(
                onPressed: () {
                  onPinTapped('', true);
                },
                child: Container(
                  margin: const EdgeInsets.all(2),
                  child: Image.asset('lib/images/backspacewhite.png'),
                ),
              ),
            ),
          );
          continue;
        }
        if (pin == 12) {
          number.add(Expanded(
              child: Container(
            margin: const EdgeInsets.all(2),
          ),),);
          continue;
        }
        number.add(
          Expanded(
            child: CupertinoButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                onPinTapped('${pin == 11 ? '0' : pin}', false);
              },
              child: Container(
                margin: const EdgeInsets.all(2),
                height: double.infinity,
                alignment: Alignment.center,
                // color: Colors.white.withOpacity(0.1),
                child: Text(
                  '${pin == 11 ? '0' : pin}',
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    color: kWhiteColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.4099999964237213,
                  ),
                ),
              ),
            ),
          ),
        );
      }

      items.add(
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: number,
          ),
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 304,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _buildPinNumbers(),
      ),
    );
  }
}
