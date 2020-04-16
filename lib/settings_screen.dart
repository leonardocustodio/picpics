import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picPics/constants.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'dart:io';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class SettingsScreen extends StatefulWidget {
  static const id = 'settings_Screen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  RateMyApp rateMyApp = RateMyApp(
    googlePlayIdentifier: 'br.com.inovatso.picPics',
    appStoreIdentifier: '1503352127',
  );

  void shareApp() {
//    Share.share('Veja esse aplicativo da para organizar todas suas fotos https://appsto.re/picpics', subject: 'Teste');
    Share.text(
      'Da uma olhada nesse app!',
      'Veja esse aplicativo da para organizar todas suas fotos https://appsto.re/picpics',
      'text/plain',
    );
  }

  void rateDialog() {
    rateMyApp.init().then((_) async {
      if (Platform.isAndroid) {
        await rateMyApp.launchStore();
      } else {
        rateMyApp.showStarRateDialog(
          context,
          ignoreIOS: false,
          onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Image.asset('lib/images/backarrowgray.png'),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        height: 60.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Desafios diários",
                              style: TextStyle(
                                fontFamily: 'Lato',
                                color: Color(0xff606566),
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.normal,
                                letterSpacing: -0.4099999964237213,
                              ),
                            ),
                            CupertinoSwitch(
                              value: true,
                              activeColor: kSecondaryColor,
                              onChanged: (value) {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: kLightGrayColor,
                      thickness: 1.0,
                    ),
                    Container(
                      height: 60.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Quantidade de fotos",
                              style: TextStyle(
                                fontFamily: 'Lato',
                                color: Color(0xff606566),
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.normal,
                                letterSpacing: -0.4099999964237213,
                              ),
                            ),
                            Text(
                              "15",
                              style: TextStyle(
                                fontFamily: 'Lato',
                                color: Color(0xff606566),
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: kLightGrayColor,
                      thickness: 1.0,
                    ),
                    Container(
                      height: 60.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Horário da notificação",
                              style: TextStyle(
                                fontFamily: 'Lato',
                                color: Color(0xff606566),
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.normal,
                                letterSpacing: -0.4099999964237213,
                              ),
                            ),
                            Text(
                              "21:00",
                              style: TextStyle(
                                fontFamily: 'Lato',
                                color: Color(0xff606566),
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: kLightGrayColor,
                      thickness: 1.0,
                    ),
                    Spacer(
//                      flex: 2,
                        ),
                    Center(
                      child: Column(
                        children: <Widget>[
                          CupertinoButton(
                            onPressed: () {
                              shareApp();
                            },
                            child: Container(
                              width: 166.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Image.asset('lib/images/sharewithfriends.png'),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Text(
                                    "Share with friends",
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      color: Color(0xff979a9b),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: -0.4099999964237213,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          CupertinoButton(
                            onPressed: () {
                              rateDialog();
                            },
                            child: Container(
                              width: 166.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Image.asset('lib/images/starrateapp.png'),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Text(
                                    "Rate this app",
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      color: Color(0xff979a9b),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: -0.4099999964237213,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: CupertinoButton(
                        onPressed: () {
                          print('test');
                        },
                        padding: const EdgeInsets.all(0),
                        child: OutlineGradientButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('lib/images/logopremium.png'),
                              SizedBox(
                                width: 16.0,
                              ),
                              Text(
                                "Get Premium now!",
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  color: kSecondaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: -0.4099999964237213,
                                ),
                              ),
                            ],
                          ),
                          gradient: LinearGradient(colors: [Color(0xFFFFA4D1), Color(0xFFFFCC00)]),
                          strokeWidth: 2.0,
                          radius: Radius.circular(8.0),
                        ),
                      ),
                    ),
//                    Spacer(
//                      flex: 1,
//                    ),
//                    Container(
//                      height: 44.0,
//                      decoration: BoxDecoration(
//                        gradient: kPrimaryGradient,
//                        borderRadius: BorderRadius.circular(8.0),
//                      ),
//                      child: Center(
//                        child: Text(
//                          "Exportar biblioteca",
//                          style: TextStyle(
//                            fontFamily: 'Lato',
//                            color: kWhiteColor,
//                            fontSize: 16,
//                            fontWeight: FontWeight.w700,
//                            fontStyle: FontStyle.normal,
//                            letterSpacing: -0.4099999964237213,
//                          ),
//                        ),
//                      ),
//                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
