import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:picPics/components/colorful_background.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/screens/email_screen.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class PinScreen extends StatefulWidget {
  static const String id = 'pin_screen';

  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> with AnimationMixin {
  AppStore appStore;

  bool isLoading = false;

  AnimationController widthController;
  AnimationController heightController;
  Animation<double> moveByX;
  Animation<double> moveByY;

  showCreatedKeyModal() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext buildContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 187.0,
            width: 270.0,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Color(0xFFF1F3F5),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(14),
                bottom: Radius.circular(19.0),
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CupertinoButton(
                        onPressed: () {
                          print('teste');
                        },
                        child: Image.asset('lib/images/closegrayico.png'),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Text(
                  "Secret Key successfully created!",
                  style: TextStyle(
                    fontFamily: 'Lato',
                    color: Color(0xff606566),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                Spacer(
                  flex: 2,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () async {
                      widthController.stop();
                      heightController.stop();

//                                  await appStore.requestGalleryPermission();
//                                  appStore.setLoggedIn(true);
//                                  Navigator.pushReplacementNamed(context, TabsScreen.id);
//                    appStore.setWaitingAccessCode(true);
//                    Navigator.pushNamed(context, PinScreen.id);
                    },
                    child: Container(
                      height: 44.0,
                      decoration: BoxDecoration(
                        gradient: kPrimaryGradient,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          S.of(context).continue_string,
                          textScaleFactor: 1.0,
                          style: kLoginButtonTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    widthController = createController()..mirror(duration: 3.seconds);
    heightController = createController()..mirror(duration: 3.seconds);
    moveByX = 0.0.tweenTo(60.0).animatedBy(widthController);
    moveByY = 0.0.tweenTo(40.0).animatedBy(heightController);

//    Analytics.sendCurrentScreen(Screen.login_screen);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appStore = Provider.of<AppStore>(context);
  }

  void pinTapped() {
    if (appStore.waitingAccessCode) {
      showCreatedKeyModal();
      return;
    }
    Navigator.pushNamed(context, EmailScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
          children: <Widget>[
            CustomPaint(
              painter: ColorfulBackground(
                moveBy: Point(moveByX.value, moveByY.value),
              ),
              child: Container(
                constraints: BoxConstraints.expand(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 18.0,
                    sigmaY: 18.0,
                  ),
                  child: Container(
                    decoration: new BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x66ffffff), Color(0x33ffffff)],
                        stops: [0, 1],
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CupertinoButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Image.asset('lib/images/backarrowgray.png'),
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
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 4.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Spacer(),
                                  Text(
                                    appStore.waitingAccessCode ? 'Access code' : 'New secret key',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      color: kSecondaryColor,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: -0.4099999964237213,
                                    ),
                                  ),
                                  if (appStore.waitingAccessCode)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: Text(
                                        'An acess key was sended to\nola@pombastudio.com',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          color: Color(0xff979a9b),
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  Spacer(),
                                  PinPlaceholder(),
                                  Spacer(),
                                  NumberPad(
                                    onPinTapped: pinTapped,
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
            Image.asset('lib/images/backspacewhite.png'),
          );
          pin++;
          continue;
        }

        number.add(
          CupertinoButton(
            padding: const EdgeInsets.all(0),
            minSize: 0,
            onPressed: () {
              onPinTapped();
            },
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
      height: 300.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: _buildPinNumbers(),
      ),
    );
  }
}
