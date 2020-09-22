import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picPics/components/colorful_background.dart';
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
                        widthController.stop();
                        heightController.stop();
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
