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

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AppStore appStore;

  @override
  void initState() {
    super.initState();
    Analytics.sendCurrentScreen(Screen.login_screen);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appStore = Provider.of<AppStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    appStore.createDefaultTags(context);

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: CustomPaint(
          painter: ColorfulBackground(),
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
//  final Color strokeColor;
//  final PaintingStyle paintingStyle;
//  final double strokeWidth;
//
//  ColorfulBackground({this.strokeColor = Colors.black, this.strokeWidth = 3, this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint primaryGradient = Paint()..shader = kPrimaryGradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    Paint secondaryGradient = Paint()..shader = kSecondaryGradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    Paint pinkGradient = Paint()..shader = kPinkGradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    Paint yellowPaint = Paint()
      ..color = kYellowColor
      ..style = PaintingStyle.fill;

    Path secondaryPath = getSecondaryPath(size.width, size.height);
    Path pinkPath = getPinkPath(size.width, size.height);
    Path yellowPath = getYellowPath(size.width, size.height);

    canvas.drawPaint(primaryGradient);
    canvas.drawPath(pinkPath, pinkGradient);
    canvas.drawPath(secondaryPath, secondaryGradient);
    canvas.drawPath(yellowPath, yellowPaint);
  }

  Path getPinkPath(double x, double y) {
    return Path()
      ..moveTo(x * 1, y * 0.35)
      ..quadraticBezierTo(x * 0.5, y * 0.4, 0, y * 0.3)
      ..lineTo(0 * x, 1 * y)
      ..lineTo(1 * x, y * 1)
      ..close();
  }

  Path getYellowPath(double x, double y) {
    return Path()
      ..moveTo(x * 0.1, -20)
      ..quadraticBezierTo(x * 0.2, y * 0.1, -x * 0.1, y * 0.2)
      ..lineTo(0, 0)
      ..close();
  }

  Path getSecondaryPath(double x, double y) {
    return Path()
      ..moveTo(0, y * 0.25)
      ..quadraticBezierTo(x * 0.75, y * 0.3, x, y * 0.5)
      ..lineTo(x * 1, y * 1)
      ..lineTo(x * 0, y * 1)
      ..close();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
