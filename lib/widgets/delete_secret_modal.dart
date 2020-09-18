import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/generated/l10n.dart';

class DeleteSecretModal extends StatelessWidget {
  final Function onPressedDelete;
  final Function onPressedOk;
  final TextEditingController alertInputController;

  DeleteSecretModal({
    @required this.onPressedDelete,
    @required this.onPressedOk,
    @required this.alertInputController,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Color(0xFFF1F3F5),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(14),
            bottom: Radius.circular(19.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Opacity(
                    opacity: 0.0,
                    child: CupertinoButton(
                      onPressed: () {
                        print('teste');
                      },
                      child: Image.asset('lib/images/closegrayico.png'),
                    ),
                  ),
                  Text(
                    "Secret photos",
                    style: TextStyle(
                      fontFamily: 'Lato',
                      color: Color(0xff979a9b),
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: -0.4099999964237213,
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      print('teste');
                    },
                    child: Image.asset('lib/images/closegrayico.png'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 44.0),
                child: Image.asset('lib/images/lockmodalico.png'),
              ),
              Text(
                'Your photo is now safe on picPics. Do you want to delete it from your camera roll?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Lato',
                  color: Color(0xff707070),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 20.0,
                      width: 20.0,
                      margin: const EdgeInsets.only(right: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFB2C2C3),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    Text(
                      "Keep asking",
                      style: TextStyle(
                        fontFamily: 'Lato',
                        color: Color(0xff707070),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    Container(
                      height: 20.0,
                      width: 20.0,
                      margin: const EdgeInsets.only(left: 24.0, right: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFB2C2C3),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    Text(
                      "Don’t ask again.",
                      style: TextStyle(
                        fontFamily: 'Lato',
                        color: Color(0xff707070),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 26.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () async {
//                  widthController.stop();
//                  heightController.stop();
//                                  await appStore.requestGalleryPermission();
//                                  appStore.setLoggedIn(true);
//                                  Navigator.pushReplacementNamed(context, TabsScreen.id);
//                    appStore.setWaitingAccessCode(true);
//                    Navigator.pushNamed(context, PinScreen.id);
                        },
                        child: Container(
                          height: 44.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: kSecondaryColor, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              'No',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Lato',
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Expanded(
                      child: CupertinoButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () async {
//                  widthController.stop();
//                  heightController.stop();

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
                              'Yes',
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
              Text(
                'To view your hidden photos, release the lock in the application settings. You can unlock them with your PIN.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Lato',
                  color: Color(0xff707070),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
