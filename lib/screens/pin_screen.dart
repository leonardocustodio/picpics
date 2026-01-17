import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_auth/local_auth.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/pin_provider_full.dart';
import 'package:picpics/providers/private_photos_provider.dart';
import 'package:picpics/providers/user_provider.dart';
import 'package:picpics/screens/email_screen.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/helpers.dart';
import 'package:picpics/widgets/color_animated_background.dart';

class PinScreen extends ConsumerStatefulWidget {
  const PinScreen({super.key});
  static const String id = 'pin_screen';

  @override
  ConsumerState<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinScreen> {
  final CarouselSliderController carouselController = CarouselSliderController();
  int carouselPage = 0;

  Widget _buildPinPad(BuildContext context, int index) {
    AppLogger.d('&&&&&&&& BUILD PIN PAD SLIDER!!!!!');

    final pinState = ref.watch<PinFullState>(pinFullProvider);
    final s = ref.watch(sProvider);
    String title;

    if (pinState.isWaitingRecoveryKey) {
      if (index == 0) {
        title = 'Recovery Code';
      } else if (index == 1) {
        title = s.new_secret_key;
      } else {
        title = s.confirm_secret_key;
      }
    } else {
      if (index == 0) {
        title = s.new_secret_key;
      } else {
        title = s.confirm_secret_key;
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
            preferences: const AnimationPreferences(autoPlay: AnimationPlayStates.None),
            child: Builder(builder: (context) {
              var filledPositions = 0;

              if (pinState.isWaitingRecoveryKey) {
                if (index == 0) {
                  filledPositions = pinState.recoveryCode.length;
                } else if (index == 1) {
                  filledPositions = pinState.pinTemp.length;
                } else {
                  filledPositions = pinState.confirmPinTemp.length;
                }
              } else {
                if (index == 0) {
                  filledPositions = pinState.pinTemp.length;
                } else {
                  filledPositions = pinState.confirmPinTemp.length;
                }
              }

              return PinPlaceholder(
                filledPositions: filledPositions,
              );
            },),
          ),
          const Spacer(),
          NumberPad(
            onPinTapped: pinTapped,
          ),
          const Spacer(),
          if (!pinState.isWaitingRecoveryKey) ...[
            CupertinoButton(
              onPressed: () {
                final userState = ref.read(userProvider);
                if (userState.email == null) {
                  unawaited(ref.read<PinFullNotifier>(pinFullProvider.notifier).askEmail(context));
                  return;
                }
                unawaited(ref.read<PinFullNotifier>(pinFullProvider.notifier).recoverPin());
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

  Future<void> pinTapped(String value, {required bool backspace}) async {
    final pinNotifier = ref.read<PinFullNotifier>(pinFullProvider.notifier);
    final pinState = ref.read<PinFullState>(pinFullProvider);
    final userState = ref.read(userProvider);

    AppLogger.d('Value: ${pinState.recoveryCode}$value');
    if (pinState.isWaitingRecoveryKey) {
      if (carouselPage == 0) {
        if (backspace) {
          pinNotifier.setRecoveryCode(
            Helpers.removeLastCharacter(pinState.recoveryCode),
          );
          return;
        }
        pinNotifier.setRecoveryCode('${pinState.recoveryCode}$value');

        if (pinState.recoveryCode.length == 6) {
          // set true
          final valid = await pinNotifier.isRecoveryCodeValid();

          if (valid) {
            await carouselController.nextPage();
            carouselPage = 1;
            pinNotifier.setRecoveryCode('');
            return;
          }

          pinNotifier.shakeRecovery.currentState?.forward();
          pinNotifier.setRecoveryCode('');
        }
        return;
      }

      if (carouselPage == 1) {
        if (backspace) {
          pinNotifier.setPinTemp(
            Helpers.removeLastCharacter(pinState.pinTemp),
          );
          return;
        }
        pinNotifier.setPinTemp('${pinState.pinTemp}$value');

        if (pinState.pinTemp.length == 6) {
          carouselPage = 2;
          await carouselController.nextPage();
        }
        return;
      }

      if (backspace) {
        pinNotifier.setConfirmPinTemp(
          Helpers.removeLastCharacter(pinState.confirmPinTemp),
        );
        return;
      }
      pinNotifier.setConfirmPinTemp('${pinState.confirmPinTemp}$value');

      if (pinState.confirmPinTemp.length == 6) {
        if (pinState.pinTemp == pinState.confirmPinTemp) {
          AppLogger.d('Setting new pin!!!!!');
          carouselPage = 0;
          pinNotifier.setPin(pinState.pinTemp);

          // Set email before saving pin (used when saving the pin)
          ref.read<UserNotifier>(userProvider.notifier).setEmail(pinState.email);
          await pinNotifier.saveNewPin();
          ref.read<UserNotifier>(userProvider.notifier).setIsPinRegistered(value: true);
          ref.read(privatePhotosProvider.notifier).toggleShowPrivate();

          pinNotifier
            ..setPinTemp('')
            ..setConfirmPinTemp('');
          ref.read<UserNotifier>(userProvider.notifier).setWaitingAccessCode(value: false);
          await carouselController.animateToPage(0);

          if (mounted) {
            Navigator.of(context).pop();
          }
        } else {
          pinNotifier.shakeKeyConfirm.currentState?.forward();
          unawaited(Future.delayed(const Duration(seconds: 1, milliseconds: 300), () {
            carouselPage = 1;
            pinNotifier
              ..setPinTemp('')
              ..setConfirmPinTemp('');
            unawaited(carouselController.animateToPage(1));
          }));
        }
      }

      return;
    }

    if (userState.isPinRegistered) {
      if (backspace) {
        pinNotifier.setPinTemp(Helpers.removeLastCharacter(pinState.pinTemp));
        return;
      }
      pinNotifier.setPinTemp('${pinState.pinTemp}$value');

      if (pinState.pinTemp.length == 6) {
        // set true
        final valid = await pinNotifier.isPinValid();

        if (valid) {
          await pinNotifier.activateBiometric();
          ref.read<UserNotifier>(userProvider.notifier).setIsBiometricActivated(value: true);

          ref.read(privatePhotosProvider.notifier).toggleShowPrivate();

          pinNotifier
            ..setPinTemp('')
            ..setConfirmPinTemp('');
          if (mounted) {
            Navigator.of(context).pop();
          }
          return;
        }

        pinNotifier
          ..shakeKey.currentState?.forward()
          ..setPinTemp('')
          ..setConfirmPinTemp('');
      }
      return;
    }

    if (userState.waitingAccessCode) {
      if (backspace) {
        pinNotifier.setAccessCode(
          Helpers.removeLastCharacter(pinState.accessCode),
        );
        return;
      }
      pinNotifier.setAccessCode('${pinState.accessCode}$value');

      if (pinState.accessCode.length == 6) {
        await pinNotifier.validateAccessCode();
      }
      return;
    }

    if (carouselPage == 0) {
      if (backspace) {
        pinNotifier.setPinTemp(Helpers.removeLastCharacter(pinState.pinTemp));
        return;
      }
      pinNotifier.setPinTemp('${pinState.pinTemp}$value');

      if (pinState.pinTemp.length == 6) {
        carouselPage = 1;
        await carouselController.nextPage();
      }
      return;
    }

    if (backspace) {
      pinNotifier.setConfirmPinTemp(
        Helpers.removeLastCharacter(pinState.confirmPinTemp),
      );
      return;
    }

    pinNotifier.setConfirmPinTemp('${pinState.confirmPinTemp}$value');

    if (pinState.confirmPinTemp.length == 6) {
      if (pinState.pinTemp == pinState.confirmPinTemp) {
        carouselPage = 0;
        pinNotifier
          ..setPin(pinState.pinTemp)
          ..setPinTemp('')
          ..setConfirmPinTemp('');
        await carouselController.animateToPage(0);
        if (mounted) {
          await Navigator.of(context).pushNamed(EmailScreen.id);
        }
      } else {
        pinNotifier.shakeKeyConfirm.currentState?.forward();
        unawaited(Future.delayed(const Duration(seconds: 1, milliseconds: 300), () {
          carouselPage = 0;
          pinNotifier
            ..setPinTemp('')
            ..setConfirmPinTemp('');
          unawaited(carouselController.animateToPage(0));
        }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pinState = ref.watch<PinFullState>(pinFullProvider);
    final pinNotifier = ref.read<PinFullNotifier>(pinFullProvider.notifier);
    final userState = ref.watch<UserState>(userProvider);
    final s = ref.watch(sProvider);

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
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
                          horizontal: 5,
                          vertical: 10,
                        ),
                        onPressed: () {
                          if (pinState.isWaitingRecoveryKey) {
                            pinNotifier.setIsWaitingRecoveryKey(value: false);
                          }
                          Navigator.of(context).pop();
                        },
                        child: Image.asset(
                          'lib/images/backarrowwithdropshadow.png',
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Builder(builder: (context) {
                      if (pinState.isWaitingRecoveryKey) {
                        return CarouselSlider.builder(
                          carouselController: carouselController,
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index, int _) {
                            return _buildPinPad(context, index);
                          },
                          options: CarouselOptions(
                            enableInfiniteScroll: false,
                            height: double.maxFinite,
                            viewportFraction: 1,
                            scrollPhysics: const NeverScrollableScrollPhysics(),
                          ),
                        );
                      }

                      if (userState.isPinRegistered) {
                        String? assetImage;

                        if (userState.isBiometricActivated) {
                          if (userState.availableBiometrics.contains(BiometricType.face)) {
                            assetImage = 'lib/images/faceidwhiteico.png';
                          } else if (userState.availableBiometrics.contains(BiometricType.iris)) {
                            assetImage = 'lib/images/irisscannerwhiteico.png';
                          } else if (userState.availableBiometrics.contains(BiometricType.fingerprint)) {
                            assetImage = 'lib/images/fingerprintwhiteico.png';
                          }
                        }

                        return Column(
                          children: [
                            const Spacer(),
                            Text(
                              s.your_secret_key,
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
                              key: pinNotifier.shakeKey,
                              preferences: const AnimationPreferences(
                                autoPlay: AnimationPlayStates.None,
                              ),
                              child: PinPlaceholder(
                                filledPositions: pinState.pinTemp.length,
                              ),
                            ),
                            const Spacer(),
                            NumberPad(
                              onPinTapped: pinTapped,
                            ),
                            const Spacer(),
                            if (assetImage != null)
                              CupertinoButton(
                                onPressed: pinNotifier.authenticate,
                                child: Image.asset(assetImage),
                              ),
                            const SizedBox(height: 16),
                            CupertinoButton(
                              onPressed: pinNotifier.recoverPin,
                              child: Text(
                                s.forgot_secret_key,
                                style: const TextStyle(
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
                        );
                      }

                      if (!userState.waitingAccessCode) {
                        return CarouselSlider.builder(
                          carouselController: carouselController,
                          itemCount: 2,
                          itemBuilder: (BuildContext context, int index, int _) {
                            return _buildPinPad(context, index);
                          },
                          options: CarouselOptions(
                            enableInfiniteScroll: false,
                            height: double.maxFinite,
                            viewportFraction: 1,
                            scrollPhysics: const NeverScrollableScrollPhysics(),
                          ),
                        );
                      }
                      return Column(
                        children: [
                          const Spacer(),
                          Text(
                            (pinState.invalidAccessCode) ? 'Invalid Access Code' : s.access_code,
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              color: kSecondaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              letterSpacing: -0.4099999964237213,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              s.access_code_sent(
                                pinState.email.isEmpty ? 'user@email.com' : pinState.email,
                              ),
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
                          const Spacer(),
                          Shake(
                            key: pinNotifier.shakeKey,
                            preferences: const AnimationPreferences(
                              autoPlay: AnimationPlayStates.None,
                            ),
                            child: PinPlaceholder(
                              filledPositions: pinState.accessCode.length,
                            ),
                          ),
                          const Spacer(),
                          NumberPad(
                            onPinTapped: pinTapped,
                          ),
                          const Spacer(),
                        ],
                      );
                    },),
                  ),
                ],
              ),
            ),
            if (pinState.isLoading)
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
    required this.onPinTapped,
    super.key,
  });
  final Future<void> Function(String, bool) onPinTapped;

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
                  unawaited(onPinTapped('', true));
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
          number.add(
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(2),
              ),
            ),
          );
          continue;
        }
        number.add(
          Expanded(
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                unawaited(onPinTapped('${pin == 11 ? '0' : pin}', false));
              },
              child: Container(
                margin: const EdgeInsets.all(2),
                height: double.infinity,
                alignment: Alignment.center,
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
