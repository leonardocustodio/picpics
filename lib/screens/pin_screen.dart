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
import 'package:picPics/widgets/general_modal.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:provider/provider.dart';

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

  GlobalKey<AnimatorWidgetState> _shakeKey = GlobalKey<AnimatorWidgetState>();
  GlobalKey<AnimatorWidgetState> _shakeKeyConfirm = GlobalKey<AnimatorWidgetState>();

  Future<void> validateAccessCode() async {
    setState(() {
      isLoading = true;
    });

    bool valid = await pinStore.validateAccessCode();

    pinStore.setAccessCode('');
    setState(() {
      isLoading = false;
    });
    if (valid) {
      print('Is valid: $valid');
      showCreatedKeyModal();
    } else {
      _shakeKey.currentState.forward();
      pinStore.setInvalidAccessCode(true);
      // showErrorModal('The access code you typed is invalid!');
    }
  }

  void setPinAndPop() {
    appStore.setIsPinRegistered(true);
    appStore.switchSecretPhotos();

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
  }

  Widget _buildPinPad(BuildContext context, int index) {
    print('&&&&&&&& BUILD PIN PAD SLIDER!!!!!');
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
            index == 0 ? S.of(context).new_secret_key : S.of(context).confirm_secret_key,
            style: TextStyle(
              fontFamily: 'Lato',
              color: kSecondaryColor,
              fontSize: 24.0,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.4099999964237213,
            ),
          ),
          Spacer(),
          Shake(
            key: index == 0 ? _shakeKey : _shakeKeyConfirm,
            preferences: AnimationPreferences(autoPlay: AnimationPlayStates.None),
            child: Observer(builder: (_) {
              return PinPlaceholder(
                filledPositions: index == 0 ? pinStore.pinTemp.length : pinStore.confirmPinTemp.length,
                totalPositions: 6,
              );
            }),
          ),
          Spacer(),
          NumberPad(
            onPinTapped: pinTapped,
          ),
          Spacer(),
        ],
      ),
    );
  }

  void pinTapped(String value) {
    print('Value: $value');
    if (appStore.isPinRegistered == true) {
      if (value == '\u0008') {
        pinStore.setPinTemp(Helpers.removeLastCharacter(pinStore.pinTemp));
        return;
      }
      pinStore.setPinTemp('${pinStore.pinTemp}${value}');

      if (pinStore.pinTemp.length == 6) {
        // set true
        appStore.switchSecretPhotos();
        galleryStore.checkIsLibraryUpdated();
        pinStore.setPinTemp('');
        pinStore.setConfirmPinTemp('');
        Navigator.pop(context);
      }

      return;
    }

    if (appStore.waitingAccessCode == true) {
      if (value == '\u0008') {
        pinStore.setAccessCode(Helpers.removeLastCharacter(pinStore.accessCode));
        return;
      }
      pinStore.setAccessCode('${pinStore.accessCode}${value}');

      if (pinStore.accessCode.length == 6) {
        validateAccessCode();
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
      pinStore.setConfirmPinTemp(Helpers.removeLastCharacter(pinStore.confirmPinTemp));
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
                        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset('lib/images/backarrowwithdropshadow.png'),
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
                      if (appStore.isPinRegistered == true) {
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
                              preferences: AnimationPreferences(autoPlay: AnimationPlayStates.None),
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
                            Text(
                              S.of(context).forgot_secret_key,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                color: kWhiteColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
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
                            pinStore.invalidAccessCode ? 'Invalid Access Code' : S.of(context).access_code,
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
                              S.of(context).access_code_sent,
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
                            preferences: AnimationPreferences(autoPlay: AnimationPlayStates.None),
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
