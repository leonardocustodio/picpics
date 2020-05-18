import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picPics/constants.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/premium_screen.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'dart:io';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:provider/provider.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:after_layout/after_layout.dart';
import 'package:picPics/admob_manager.dart';
import 'package:picPics/pic_screen.dart';
import 'package:picPics/generated/l10n.dart';

class SettingsScreen extends StatefulWidget {
  static const id = 'settings_Screen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with WidgetsBindingObserver, AfterLayoutMixin<SettingsScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  RateMyApp rateMyApp = RateMyApp(
    googlePlayIdentifier: 'br.com.inovatso.picPics',
    appStoreIdentifier: '1503352127',
  );

  void shareApp(BuildContext context) {
//    Share.share('Veja esse aplicativo da para organizar todas suas fotos https://appsto.re/picpics', subject: 'Teste');
    Share.text(
      S.of(context).take_a_look,
      S.of(context).take_a_look_description('https://appsto.re/picpics'),
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

  void showGoalPicker(BuildContext context) async {
    int goalIndex = DatabaseManager.instance.userSettings.goal - 1;

    FixedExtentScrollController extentScrollController = FixedExtentScrollController(initialItem: goalIndex);

    Ads.setScreen(HideAdScreen);

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        int temporaryGoal = goalIndex;

        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 80.0,
                      child: Text(
                        S.of(context).cancel,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    S.of(context).how_many_pics,
                    textScaleFactor: 1.0,
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: 24,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      DatabaseManager.instance.changeUserGoal(temporaryGoal);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 80.0,
                      child: Text(
                        S.of(context).ok,
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker.builder(
                  scrollController: extentScrollController,
                  childCount: 200,
                  itemExtent: 36.0,
                  useMagnifier: true,
                  magnification: 1.2,
                  onSelectedItemChanged: (int index) {
                    if (mounted) {
                      temporaryGoal = index + 1;
                    }
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                        child: Text(
                      '${index + 1}',
                      textScaleFactor: 1.0,
                    ));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    Ads.setScreen(SettingsScreen.id);
  }

  void showTimePicker(BuildContext context) async {
    Ads.setScreen(HideAdScreen);

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        DateTime now = DateTime.now();
        DateTime time = DateTime(now.year, now.month, now.day, DatabaseManager.instance.userSettings.hourOfDay,
            DatabaseManager.instance.userSettings.minutesOfDay);

        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 80.0,
                      child: Text(
                        S.of(context).cancel,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    S.of(context).time,
                    textScaleFactor: 1.0,
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: 24,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      DatabaseManager.instance.changeUserTimeOfDay(time.hour, time.minute);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 80.0,
                      child: Text(
                        S.of(context).ok,
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: time,
                  onDateTimeChanged: (DateTime newDate) {
                    print(newDate);
                    time = newDate;
                  },
                  use24hFormat: true,
                  minuteInterval: 1,
                  mode: CupertinoDatePickerMode.time,
                ),
              ),
            ],
          ),
        );
      },
    );

    Ads.setScreen(SettingsScreen.id);
  }

  void changeDailyChallenges(BuildContext context, bool value) async {
    if (value == false) {
      DatabaseManager.instance.changeDailyChallenges();
    } else if (value == true && DatabaseManager.instance.userSettings.notifications == false) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return PlatformAlertDialog(
            title: Text(
              S.of(context).notifications,
              textScaleFactor: 1.0,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    S.of(context).daily_challenge_permission_description,
                    textScaleFactor: 1.0,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              PlatformDialogAction(
                child: Text(
                  S.of(context).ok,
                  textScaleFactor: 1.0,
                ),
                actionType: ActionType.Preferred,
                onPressed: () {
                  NotificationPermissions.requestNotificationPermissions(
                          iosSettings: const NotificationSettingsIos(sound: true, badge: true, alert: true))
                      .then((_) {});
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      DatabaseManager.instance.changeDailyChallenges();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print('#### INIT!!!!');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      DatabaseManager.instance.checkNotificationPermission(shouldNotify: true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('#!#!#!#! did change dependencies');

//    if (myBanner == null) {
//      startBanner();
//      displayBanner();
//    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // Calling the same function "after layout" to resolve the issue.
    print('after layout');
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
                  print('Current tab in picScreen: ${DatabaseManager.instance.currentTab}');
                  Ads.setScreen(PicScreen.id, DatabaseManager.instance.currentTab);
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
                        child: CupertinoButton(
                          padding: const EdgeInsets.all(0),
                          pressedOpacity: 1.0,
                          onPressed: () {
                            DatabaseManager.instance.changeDailyChallenges();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                S.of(context).daily_challenge,
                                textScaleFactor: 1.0,
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
                                value: Provider.of<DatabaseManager>(context).userSettings.dailyChallenges,
                                activeColor: kSecondaryColor,
                                onChanged: (value) {
                                  changeDailyChallenges(context, value);
                                },
                              ),
                            ],
                          ),
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
                        child: CupertinoButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            showGoalPicker(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                S.of(context).daily_goal,
                                textScaleFactor: 1.0,
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
                                '${Provider.of<DatabaseManager>(context).userSettings.goal}',
                                textScaleFactor: 1.0,
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
                    ),
                    Divider(
                      color: kLightGrayColor,
                      thickness: 1.0,
                    ),
                    Container(
                      height: 60.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CupertinoButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            showTimePicker(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                S.of(context).notification_time,
                                textScaleFactor: 1.0,
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
                                '${'${Provider.of<DatabaseManager>(context).userSettings.hourOfDay}'.padLeft(2, '0')}: ${'${Provider.of<DatabaseManager>(context).userSettings.minutesOfDay}'.padLeft(2, '0')}',
                                textScaleFactor: 1.0,
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
                              shareApp(context);
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
                                    S.of(context).share_with_friends,
                                    textScaleFactor: 1.0,
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
                                    S.of(context).rate_this_app,
                                    textScaleFactor: 1.0,
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
                      padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 80.0),
                      child: CupertinoButton(
                        onPressed: () {
                          if (DatabaseManager.instance.userSettings.isPremium) {
                            return;
                          }
                          Ads.setScreen(PremiumScreen.id);
                          Navigator.pushNamed(context, PremiumScreen.id);
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
                                Provider.of<DatabaseManager>(context).userSettings.isPremium
                                    ? S.of(context).you_are_premium
                                    : S.of(context).get_premium_now,
                                textScaleFactor: 1.0,
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
