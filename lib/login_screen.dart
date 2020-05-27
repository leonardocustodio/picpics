import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picPics/constants.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/pic_screen.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/generated/l10n.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: new BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
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
                      var result = await PhotoManager.requestPermission();
                      if (result) {
                        DatabaseManager.instance.setupPathList();
                        Navigator.pushNamed(context, PicScreen.id);
                      } else {
                        // fail
                        /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
                      }
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
    );
  }
}
