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
import 'package:picPics/widgets/color_animated_background.dart';
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
    appStore.createDefaultTags(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
          children: [
            ColorAnimatedBackground(
              moveByX: 30.0,
              moveByY: 20.0,
            ),
            SafeArea(
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
          ],
        ),
      ),
    );
  }
}
