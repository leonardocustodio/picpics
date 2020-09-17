import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:picPics/components/colorful_background.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class PinScreen extends StatefulWidget {
  static const String id = 'pin_screen';

  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> with AnimationMixin {
  bool isLoading = false;

  AnimationController widthController;
  AnimationController heightController;
  Animation<double> moveByX;
  Animation<double> moveByY;

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
                                    "New secret key",
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
                                  PinPlaceholder(),
                                  Spacer(),
                                  NumberPad(),
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
  const NumberPad({
    Key key,
  }) : super(key: key);

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
          Text(
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
