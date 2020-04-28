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
//      backgroundColor: Color(0xffff6666),
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
                    style: TextStyle(
                      fontFamily: 'Lato',
                      color: kWhiteColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  Text(
                    S.of(context).photos_always_organized,
                    style: TextStyle(
                      fontFamily: 'Lato',
                      color: kWhiteColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
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
                          style: TextStyle(
                            fontFamily: 'Lato',
                            color: Color(0xfff5fafa),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            letterSpacing: -0.4099999964237213,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
//                  Container(
//                    height: 44.0,
//                    decoration: BoxDecoration(
//                      border: Border.all(color: kWhiteColor, width: 1.0),
//                      borderRadius: BorderRadius.circular(8.0),
//                    ),
//                    child: Center(
//                      child: Text(
//                        "Criar conta",
//                        style: TextStyle(
//                          fontFamily: 'Lato',
//                          color: kWhiteColor,
//                          fontSize: 16,
//                          fontWeight: FontWeight.w700,
//                          fontStyle: FontStyle.normal,
//                          letterSpacing: -0.4099999964237213,
//                        ),
//                      ),
//                    ),
//                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
