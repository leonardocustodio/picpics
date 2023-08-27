import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';

import 'package:picPics/screens/pin_screen.dart';
import 'package:picPics/stores/language_controller.dart';
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/stores/pin_controller.dart';
import 'package:picPics/widgets/color_animated_background.dart';

class EmailStore extends GetxController {
  final isLoading = false.obs;
}

class EmailScreen extends StatefulWidget {
  static const String id = 'email_screen';
  const EmailScreen({Key? key}) : super(key: key);

  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
//    Analytics.sendCurrentScreen(Screen.login_screen);
  }

  Future<void> startRegistration() async {
    final isValid = EmailValidator.validate(PinController.to.email.value);

    if (!isValid) {
      PinController.to
          .showErrorModal('Please type a valid e-mail address to proceed.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await PinController.to.register();

    setState(() {
      isLoading = false;
    });

    if (result['success'] == true) {
      UserController.to.setWaitingAccessCode(true);
      await Get.toNamed(PinScreen.id);
    } else {
      print('Result: $result');
      if ((result['errorCode'] as FirebaseAuthException).code ==
          'email-already-in-use') {
        PinController.to.showErrorModal(
            'This e-mail is already in use by another account.');
        print('Error !!!');
      } else {
        PinController.to
            .showErrorModal('An error has occured. Please try again!');
        print('Error !!!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print('Height: ${size.height} - Width: ${size.width}');

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
          children: <Widget>[
            const ColorAnimatedBackground(
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
                          UserController.to.setWaitingAccessCode(false);
                          Get.back();
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
                          Obx(
                            () => Text(
                              LangControl.to.S.value.confirm_email,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                color: kWhiteColor,
                                fontSize: size.width < 400 ? 22.0 : 28.0,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          const Spacer(),
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
                                Obx(
                                  () => Text(
                                    LangControl.to.S.value.email,
                                    style: const TextStyle(
                                      fontFamily: 'Lato',
                                      color: Color(0xff606566),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: -0.4099999964237213,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 42.0,
                                  margin: const EdgeInsets.only(top: 6.0),
                                  child: TextField(
                                    maxLines: 1,
                                    onChanged: PinController.to.setEmail,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          left: 10.0, right: 5.0),
                                      fillColor:
                                          const Color(0xFFF1F3F5).withOpacity(0.3),
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFFE2E4E5),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFFE2E4E5),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
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
                          const Spacer(
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
                                child: Obx(
                                  () => Text(
                                    LangControl.to.S.value.continue_string,
                                    textScaleFactor: 1.0,
                                    style: kLoginButtonTextStyle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
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
                child: const Center(
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
