import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/screens/tabs_screen.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with AnimationMixin {
  AppStore appStore;

  AnimationController widthController;
  AnimationController heightController;
  Animation<double> moveByX;
  Animation<double> moveByY;

  @override
  void initState() {
    super.initState();
    widthController = createController()..mirror(duration: 3.seconds);
    heightController = createController()..mirror(duration: 3.seconds);
    moveByX = 0.0.tweenTo(30.0).animatedBy(widthController);
    moveByY = 0.0.tweenTo(20.0).animatedBy(heightController);

    Analytics.sendCurrentScreen(Screen.login_screen);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appStore = Provider.of<AppStore>(context);
    appStore.createDefaultTags(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: CustomPaint(
          painter: ColorfulBackground(
            moveBy: Point(moveByX.value, moveByY.value),
          ),
          child: Container(
            constraints: BoxConstraints.expand(),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(
                      flex: 2,
                    ),
                    Image.asset('lib/images/picpics_small.png'),
                    Spacer(
                      flex: 1,
                    ),
                    Text(
                      S.of(context).welcome,
                      textScaleFactor: 1.0,
                      style: kLoginDescriptionTextStyle,
                    ),
                    Text(
                      S.of(context).photos_always_organized,
                      textScaleFactor: 1.0,
                      style: kLoginDescriptionTextStyle,
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () async {
                        await appStore.requestGalleryPermission();
                        appStore.setLoggedIn(true);
                        Navigator.pushReplacementNamed(context, TabsScreen.id);
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
                    SizedBox(
                      height: 40.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ColorfulBackground extends CustomPainter {
  final Point moveBy;
  ColorfulBackground({@required this.moveBy});

  @override
  void paint(Canvas canvas, Size size) {
    Paint primaryGradient = Paint()..shader = kPrimaryGradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    Paint secondaryGradient = Paint()..shader = kSecondaryGradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    Paint pinkGradient = Paint()..shader = kPinkGradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    Paint yellowPaint = Paint()
      ..color = kYellowColor
      ..style = PaintingStyle.fill;

    Path secondaryPath = getSecondaryPath(size.width, size.height, moveBy.x - 20, moveBy.y * 2);
    Path pinkPath = getPinkPath(size.width, size.height, -(moveBy.x / 3), (moveBy.y / 2 - 20));
    Path yellowPath = getYellowPath(size.width, size.height, moveBy.x / 2, -moveBy.y);

    canvas.drawPaint(primaryGradient);
    canvas.drawPath(pinkPath, pinkGradient);
    canvas.drawPath(secondaryPath, secondaryGradient);
    canvas.drawPath(yellowPath, yellowPaint);
  }

  Path getPinkPath(double x, double y, double moveByX, double moveByY) {
    return Path()
      ..moveTo(x * 1, y * 0.35 + moveByY)
      ..quadraticBezierTo(x * 0.5 + moveByX, y * 0.4 + moveByY, 0 + moveByX, y * 0.3 + moveByY)
      ..lineTo(0 * x + moveByX, 1 * y + moveByY)
      ..lineTo(1 * x, y * 1 + moveByY)
      ..close();
  }

  Path getYellowPath(double x, double y, double moveByX, double moveByY) {
    return Path()
      ..moveTo(x * 0.1 + moveByX, -20 + moveByY)
      ..quadraticBezierTo(x * 0.2, y * 0.1, -x * 0.1, y * 0.2)
      ..lineTo(0, 0)
      ..close();
  }

  Path getSecondaryPath(double x, double y, double moveByX, double moveByY) {
    return Path()
      ..moveTo(0, y * 0.25 + moveByY / 3)
      ..quadraticBezierTo(x * 0.75 + moveByX, y * 0.3 + moveByY, x, y * 0.5 - moveByY / 2)
      ..lineTo(x * 1, y * 1)
      ..lineTo(0, y * 1)
      ..close();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
