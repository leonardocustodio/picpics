import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/screens/pin_screen.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/pin_store.dart';
import 'package:picPics/widgets/color_animated_background.dart';
import 'package:picPics/widgets/general_modal.dart';
import 'package:email_validator/email_validator.dart';

class EmailScreen extends StatefulWidget {
  static const String id = 'email_screen';

  final PinStore pinStore;
  EmailScreen({this.pinStore});

  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  AppStore appStore;
  PinStore pinStore;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
//    Analytics.sendCurrentScreen(Screen.login_screen);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appStore = Provider.of<AppStore>(context);
    pinStore = Provider.of<PinStore>(context);
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

  Future<void> startRegistration() async {
    bool isValid = EmailValidator.validate(pinStore.email);

    if (!isValid) {
      showErrorModal('Please type a valid e-mail address to proceed.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> result = await pinStore.register();

    setState(() {
      isLoading = false;
    });

    if (result['success'] == true) {
      appStore.setWaitingAccessCode(true);
      Navigator.pushNamed(context, PinScreen.id);
    } else {
      //print('Result: $result');
      if (result['errorCode'] == 'email-already-in-use') {
        showErrorModal('This e-mail is already in use by another account.');
        //print('Error !!!');
      } else {
        showErrorModal('An error has occured. Please try again!');
        //print('Error !!!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    //print('Height: ${size.height} - Width: ${size.width}');

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
          children: <Widget>[
            ColorAnimatedBackground(
              moveByX: 60.0,
              moveByY: 40.0,
              blurFilter: false,
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
                          appStore.setWaitingAccessCode(false);
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                            'lib/images/backarrowwithdropshadow.png'),
                      ),
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
                          Text(
                            S.of(context).confirm_email,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: kWhiteColor,
                              fontSize: size.width < 400 ? 22.0 : 28.0,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 32.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context).email,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: Color(0xff606566),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: -0.4099999964237213,
                                  ),
                                ),
                                Container(
                                  height: 42.0,
                                  margin: const EdgeInsets.only(top: 6.0),
                                  child: TextField(
                                    maxLines: 1,
                                    onChanged: pinStore.setEmail,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          left: 10.0, right: 5.0),
                                      fillColor:
                                          Color(0xFFF1F3F5).withOpacity(0.3),
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFE2E4E5),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFE2E4E5),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFE2E4E5),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(
                            flex: 2,
                          ),
                          CupertinoButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              startRegistration();
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
