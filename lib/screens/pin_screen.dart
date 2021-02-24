import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animator/animation/animator_play_states.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/screens/email_screen.dart';
import 'package:picPics/screens/settings_screen.dart';
import 'package:picPics/screens/tabs_screen.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/stores/pin_store.dart';
import 'package:picPics/utils/helpers.dart';
import 'package:picPics/widgets/color_animated_background.dart';
import 'package:picPics/widgets/cupertino_input_dialog.dart';
import 'package:picPics/widgets/general_modal.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';

class PinScreen extends StatefulWidget {
  static const String id = 'pin_screen';

  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  AppStore appStore;
  GalleryStore galleryStore;
  PinStore pinStore;

  bool isLoading = false;

  CarouselController carouselController = CarouselController();
  int carouselPage = 0;

  Future<void> _authenticate() async {
    try {
      bool authenticated =
          await appStore.biometricAuth.authenticateWithBiometrics(
        localizedReason: 'Scan your fingerprint to authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
      );

      if (authenticated == true) {
        bool valid = await pinStore.isBiometricValidated(appStore);

        if (valid == true) {
          appStore.switchSecretPhotos();
          galleryStore.checkIsLibraryUpdated();
          pinStore.setPinTemp('');
          pinStore.setConfirmPinTemp('');
          Navigator.pop(context);
          return;
        }

        _shakeKey.currentState.forward();
        pinStore.setPinTemp('');
        pinStore.setConfirmPinTemp('');
      }
    } on PlatformException catch (e) {
      //print(e);
      _shakeKey.currentState.forward();
      pinStore.setPinTemp('');
      pinStore.setConfirmPinTemp('');
    }
  }

  void _cancelAuthentication() {
    appStore.biometricAuth.stopAuthentication();
  }

  GlobalKey<AnimatorWidgetState> _shakeKey = GlobalKey<AnimatorWidgetState>();
  GlobalKey<AnimatorWidgetState> _shakeKeyConfirm =
      GlobalKey<AnimatorWidgetState>();
  GlobalKey<AnimatorWidgetState> _shakeRecovery =
      GlobalKey<AnimatorWidgetState>();

  Future<void> validateAccessCode() async {
    setState(() {
      isLoading = true;
    });

    bool valid = await pinStore.validateAccessCode(appStore);

    pinStore.setAccessCode('');
    setState(() {
      isLoading = false;
    });

    if (valid) {
      //print('Is valid: $valid');
      showCreatedKeyModal();
    } else {
      _shakeKey.currentState.forward();
      pinStore.setInvalidAccessCode(true);
      // showErrorModal('The access code you typed is invalid!');
    }
  }

  void askEmail() async {
    //print('asking email');

    TextEditingController alertInputController = TextEditingController();

    //print('showModal');
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext buildContext) {
        return CupertinoInputDialog(
          alertInputController: alertInputController,
          title: 'Type your email',
          destructiveButtonTitle: S.of(context).cancel,
          onPressedDestructive: () {
            Navigator.of(context).pop();
          },
          defaultButtonTitle: S.of(context).ok,
          onPressedDefault: () {
            pinStore.setEmail(alertInputController.text);
            Navigator.of(context).pop();
            recoverPin();
          },
        );
      },
    );
  }

  Future<void> recoverPin() async {
    setState(() {
      isLoading = true;
    });

    bool request =
        await pinStore.requestRecoveryKey(appStore.email ?? pinStore.email);

    setState(() {
      isLoading = false;
    });

    if (request == true) {
      showErrorModal('We will send an access code soon');
      return;
    }

    showErrorModal('An error has occurred, please try again!');
  }

  void setPinAndPop() {
    appStore.setEmail(pinStore.email);
    appStore.setIsPinRegistered(true);
    appStore.switchSecretPhotos();
    appStore.setWaitingAccessCode(false);

    if (appStore.popPinScreen == PopPinScreenTo.SettingsScreen) {
      Navigator.popUntil(context, ModalRoute.withName(SettingsScreen.id));
    } else {
      Navigator.popUntil(context, ModalRoute.withName(TabsScreen.id));
    }
  }

  void showErrorModal(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext buildContext) {
        return GeneralModal(
          message: message,
          onPressedDelete: () {
            Navigator.pop(context);
          },
          onPressedOk: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void showCreatedKeyModal() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext buildContext) {
        return GeneralModal(
          message: 'Secret Key successfully created!',
          onPressedDelete: () {
            Navigator.pop(context);
          },
          onPressedOk: () {
            Navigator.pop(context);
          },
        );
      },
    ).then((_) {
      setPinAndPop();
    });
  }

  @override
  void initState() {
    super.initState();
//    Analytics.sendCurrentScreen(Screen.login_screen);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appStore = Provider.of<AppStore>(context);
    galleryStore = Provider.of<GalleryStore>(context);
    pinStore = Provider.of<PinStore>(context);

    if (appStore.isPinRegistered == true &&
        appStore.isBiometricActivated == true) {
      _authenticate();
    }
  }

  Widget _buildPinPad(BuildContext context, int index) {
    //print('&&&&&&&& BUILD PIN PAD SLIDER!!!!!');

    String title;
    GlobalKey<AnimatorWidgetState> key;

    if (pinStore.isWaitingRecoveryKey == true) {
      if (index == 0) {
        title = 'Recovery Code';
        key = _shakeRecovery;
      } else if (index == 1) {
        title = S.of(context).new_secret_key;
        key = _shakeKey;
      } else {
        title = S.of(context).confirm_secret_key;
        key = _shakeKeyConfirm;
      }
    } else {
      if (index == 0) {
        title = S.of(context).new_secret_key;
        key = _shakeKey;
      } else {
        title = S.of(context).confirm_secret_key;
        key = _shakeKeyConfirm;
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
            child: Observer(builder: (_) {
              int filledPositions;

              if (pinStore.isWaitingRecoveryKey == true) {
                if (index == 0) {
                  filledPositions = pinStore.recoveryCode.length;
                } else if (index == 1) {
                  filledPositions = pinStore.pinTemp.length;
                } else {
                  filledPositions = pinStore.confirmPinTemp.length;
                }
              } else {
                if (index == 0) {
                  filledPositions = pinStore.pinTemp.length;
                } else {
                  filledPositions = pinStore.confirmPinTemp.length;
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
          if (pinStore.isWaitingRecoveryKey != true) ...[
            CupertinoButton(
              onPressed: () {
                if (appStore.email == null) {
                  askEmail();
                  return;
                }
                recoverPin();
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
    //print('Value: $value');
    if (pinStore.isWaitingRecoveryKey == true) {
      if (carouselPage == 0) {
        if (value == '\u0008') {
          pinStore.setRecoveryCode(
              Helpers.removeLastCharacter(pinStore.recoveryCode));
          return;
        }
        pinStore.setRecoveryCode('${pinStore.recoveryCode}${value}');

        if (pinStore.recoveryCode.length == 6) {
          // set true
          bool valid = await pinStore.isRecoveryCodeValid(appStore);

          if (valid) {
            carouselController.nextPage();
            carouselPage = 1;
            pinStore.setRecoveryCode('');
            return;
          }

          _shakeRecovery.currentState.forward();
          pinStore.setRecoveryCode('');
        }
        return;
      }

      if (carouselPage == 1) {
        if (value == '\u0008') {
          pinStore.setPinTemp(Helpers.removeLastCharacter(pinStore.pinTemp));
          return;
        }
        pinStore.setPinTemp('${pinStore.pinTemp}${value}');

        if (pinStore.pinTemp.length == 6) {
          carouselPage = 2;
          carouselController.nextPage();
        }
        return;
      }

      if (value == '\u0008') {
        pinStore.setConfirmPinTemp(
            Helpers.removeLastCharacter(pinStore.confirmPinTemp));
        return;
      }
      pinStore.setConfirmPinTemp('${pinStore.confirmPinTemp}${value}');

      if (pinStore.confirmPinTemp.length == 6) {
        if (pinStore.pinTemp == pinStore.confirmPinTemp) {
          //print('Setting new pin!!!!!');
          carouselPage = 0;
          pinStore.pin = pinStore.pinTemp;
          appStore.setEmail(pinStore
              .email); // Tem que deixar antes pois é utilizado quando salva o pin

          await pinStore.saveNewPin(appStore);

          appStore.setIsPinRegistered(true);
          appStore.switchSecretPhotos();
          galleryStore.checkIsLibraryUpdated();
          pinStore.setPinTemp('');
          pinStore.setConfirmPinTemp('');
          appStore.setWaitingAccessCode(false);
          carouselController.animateToPage(0);

          Navigator.pop(context);
        } else {
          _shakeKeyConfirm.currentState.forward();
          Future.delayed(Duration(seconds: 1, milliseconds: 300), () {
            carouselPage = 1;
            pinStore.setPinTemp('');
            pinStore.setConfirmPinTemp('');
            carouselController.animateToPage(1);
          });
        }
      }

      return;
    }

    if (appStore.isPinRegistered == true) {
      if (value == '\u0008') {
        pinStore.setPinTemp(Helpers.removeLastCharacter(pinStore.pinTemp));
        return;
      }
      pinStore.setPinTemp('${pinStore.pinTemp}${value}');

      if (pinStore.pinTemp.length == 6) {
        // set true
        bool valid = await pinStore.isPinValid(appStore);

        if (valid) {
          if (appStore.wantsToActivateBiometric) {
            await pinStore.activateBiometric(appStore);
            await appStore.setIsBiometricActivated(true);

            pinStore.setPinTemp('');
            pinStore.setConfirmPinTemp('');
            Navigator.pop(context);
            return;
          }

          appStore.switchSecretPhotos();
          galleryStore.checkIsLibraryUpdated();

          pinStore.setPinTemp('');
          pinStore.setConfirmPinTemp('');
          Navigator.pop(context);
          return;
        }

        _shakeKey.currentState.forward();
        pinStore.setPinTemp('');
        pinStore.setConfirmPinTemp('');
      }
      return;
    }

    if (appStore.waitingAccessCode == true) {
      if (value == '\u0008') {
        pinStore
            .setAccessCode(Helpers.removeLastCharacter(pinStore.accessCode));
        return;
      }
      pinStore.setAccessCode('${pinStore.accessCode}${value}');

      if (pinStore.accessCode.length == 6) {
        await validateAccessCode();
      }
      return;
    }

    if (carouselPage == 0) {
      pinStore.setPinTemp('${pinStore.pinTemp}${value}');

      if (pinStore.pinTemp.length == 6) {
        carouselPage = 1;
        carouselController.nextPage();
      }
      return;
    }

    if (value == '\u0008') {
      pinStore.setConfirmPinTemp(
          Helpers.removeLastCharacter(pinStore.confirmPinTemp));
      return;
    }
    pinStore.setConfirmPinTemp('${pinStore.confirmPinTemp}${value}');

    if (pinStore.confirmPinTemp.length == 6) {
      if (pinStore.pinTemp == pinStore.confirmPinTemp) {
        carouselPage = 0;
        pinStore.pin = pinStore.pinTemp;
        pinStore.setPinTemp('');
        pinStore.setConfirmPinTemp('');
        carouselController.animateToPage(0);
        Navigator.pushNamed(context, EmailScreen.id);
      } else {
        _shakeKeyConfirm.currentState.forward();
        Future.delayed(Duration(seconds: 1, milliseconds: 300), () {
          carouselPage = 0;
          pinStore.setPinTemp('');
          pinStore.setConfirmPinTemp('');
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
                          if (pinStore.isWaitingRecoveryKey == true) {
                            pinStore.setIsWaitingRecoveryKey(false);
                          }
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                            'lib/images/backarrowwithdropshadow.png'),
                      ),
//                          CupertinoButton(
//                            onPressed: () {
////                              restorePurchase();
//                            },
//                            child: Text(
//                              S.of(context).restore_purchase,
//                              textScaleFactor: 1.0,
//                              style: const TextStyle(
//                                fontWeight: FontWeight.w700,
//                                color: Color(0xff979a9b),
//                                decoration: TextDecoration.underline,
//                                fontFamily: "Lato",
//                                fontStyle: FontStyle.normal,
//                                fontSize: 14.0,
//                                letterSpacing: -0.4099999964237213,
//                              ),
//                            ),
//                          ),
                    ],
                  ),
                  Expanded(
                    child: Observer(builder: (_) {
                      if (pinStore.isWaitingRecoveryKey == true) {
                        return CarouselSlider.builder(
                          carouselController: carouselController,
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index) {
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
                        //       key: _shakeRecovery,
                        //       preferences: AnimationPreferences(autoPlay: AnimationPlayStates.None),
                        //       child: Observer(builder: (_) {
                        //         return PinPlaceholder(
                        //           filledPositions: pinStore.recoveryCode.length,
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

                      if (appStore.isPinRegistered == true) {
                        String assetImage;

                        if (appStore.isBiometricActivated == true) {
                          if (appStore.availableBiometrics
                              .contains(BiometricType.face)) {
                            assetImage = 'lib/images/faceidwhiteico.png';
                          } else if (appStore.availableBiometrics
                              .contains(BiometricType.iris)) {
                            assetImage = 'lib/images/irisscannerwhiteico.png';
                          } else if (appStore.availableBiometrics
                              .contains(BiometricType.fingerprint)) {
                            assetImage = 'lib/images/fingerprintwhiteico.png';
                          }
                        }

                        return Column(
                          children: [
                            Spacer(),
                            Text(
                              S.of(context).your_secret_key,
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
                              key: _shakeKey,
                              preferences: AnimationPreferences(
                                  autoPlay: AnimationPlayStates.None),
                              child: Observer(builder: (_) {
                                return PinPlaceholder(
                                  filledPositions: pinStore.pinTemp.length,
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
                                  _authenticate();
                                },
                                child: Image.asset(assetImage),
                              ),
                            if (appStore.wantsToActivateBiometric != true)
                              CupertinoButton(
                                onPressed: () {
                                  recoverPin();
                                },
                                child: Text(
                                  S.of(context).forgot_secret_key,
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

                      if (appStore.waitingAccessCode == false) {
                        return CarouselSlider.builder(
                          carouselController: carouselController,
                          itemCount: 2,
                          itemBuilder: (BuildContext context, int index) {
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
                            pinStore.invalidAccessCode
                                ? 'Invalid Access Code'
                                : S.of(context).access_code,
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
                              S.of(context).access_code_sent(
                                  '${pinStore.email ?? 'user@email.com'}'),
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
                            key: _shakeKey,
                            preferences: AnimationPreferences(
                                autoPlay: AnimationPlayStates.None),
                            child: Observer(
                              builder: (_) {
                                return PinPlaceholder(
                                  filledPositions: pinStore.accessCode.length,
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
    List<Widget> items = [];

    for (int x = 0; x < totalPositions; x++) {
      items.add(
        Container(
          width: 16.0,
          height: 16.0,
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: new BoxDecoration(
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
    this.onPinTapped,
  });

  List<Widget> _buildPinNumbers() {
    List<Widget> items = [];

    int pin = 1;
    for (int x = 0; x < 4; x++) {
      List<Widget> number = [];

      for (int y = 0; y < 3; y++) {
        if (pin == 10) {
          number.add(
            CupertinoButton(
              onPressed: () {
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

        int value = pin;
        number.add(
          CupertinoButton(
            // padding: const EdgeInsets.all(0),
            minSize: 44.0,
            onPressed: () {
              onPinTapped('${value == 11 ? '0' : value}');
            },
            child: Container(
              width: 44.0,
              height: 44.0,
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
