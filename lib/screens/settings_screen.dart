import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/screens/pin_screen.dart';
import 'package:picPics/stores/language_controller.dart';
import 'package:picPics/stores/private_photos_controller.dart';
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/utils/languages.dart';
import 'package:picPics/widgets/fadein.dart';
import 'package:picPics/widgets/secret_switch.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'dart:io';

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:local_auth/local_auth.dart';

class SettingsScreen extends StatefulWidget {
  static const id = 'settings_Screen';

  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with WidgetsBindingObserver {
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  void contactUs(BuildContext context) {
    final emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'picpics@inovatso.com.br',
    );
    launch(emailLaunchUri.toString());
  }

  final rateMyApp = RateMyApp(
    googlePlayIdentifier: 'br.com.inovatso.picPics',
    appStoreIdentifier: '1503352127',
  );

  void shareApp(BuildContext context) {
    Share.share(LangControl.to.S.value.take_a_look,
        subject: S
            .of(context)
            .take_a_look_description('https://picpics.link/share'));

    Analytics.sendEvent(Event.shared_app);
  }

  void rateDialog() {
    rateMyApp.init().then((_) async {
      if (Platform.isAndroid) {
        await rateMyApp.launchStore();
      } else {
        await rateMyApp.showStarRateDialog(
          context,
          ignoreNativeDialog: false,
          onDismissed: () =>
              rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        );
      }
    });
    Analytics.sendEvent(Event.rated_app);
  }

  void showRequirePinPicker(BuildContext context) async {
    final extentScrollController = FixedExtentScrollController(
        initialItem: UserController.to.requireSecret.value);

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        var temporaryOption = UserController.to.requireSecret.value;

        return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: SizedBox(
                      width: 80.0,
                      child: Obx(
                        () => Text(
                          LangControl.to.S.value.cancel,
                          textScaleFactor: 1.0,
                          style: kBottomSheetTextStyle,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Require secret key',
                    textScaleFactor: 1.0,
                    style: kBottomSheetTitleTextStyle,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      UserController.to.setRequireSecret(temporaryOption);
                      Get.back();
                    },
                    child: SizedBox(
                      width: 80.0,
                      child: Obx(
                        () => Text(
                          LangControl.to.S.value.ok,
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.end,
                          style: kBottomSheetTextStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker.builder(
                  scrollController: extentScrollController,
                  childCount: kRequireOptions.length,
                  itemExtent: 36.0,
                  useMagnifier: true,
                  magnification: 1.2,
                  onSelectedItemChanged: (int index) {
                    if (mounted) {
                      temporaryOption = index;
                    }
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                        child: Text(
                      kRequireOptions[index],
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
  }

  void showLanguagePicker(BuildContext context) async {
    var language = LanguageLocal();
    var supportedLocales = S.delegate.supportedLocales;
    final supportedLanguages =
        supportedLocales.map((e) => e.languageCode).toList();
    final appSplit = UserController.to.appLanguage.split('_');
    final languageIndex = supportedLanguages.indexOf(appSplit[0]);

    final extentScrollController =
        FixedExtentScrollController(initialItem: languageIndex);

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        var temporaryLanguage = languageIndex;

        return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: SizedBox(
                      width: 80.0,
                      child: Obx(
                        () => Text(
                          LangControl.to.S.value.cancel,
                          textScaleFactor: 1.0,
                          style: kBottomSheetTextStyle,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => Text(
                      LangControl.to.S.value.language,
                      textScaleFactor: 1.0,
                      style: kBottomSheetTitleTextStyle,
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Center(
                                child: Container(
                                  width: 60.0,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: CupertinoActivityIndicator(),
                                  ),
                                ),
                              ));
                      UserController.to
                          .changeUserLanguage(
                              supportedLocales[temporaryLanguage].toString())
                          .then((_) {
                        LangControl.to
                            .changeLanguageTo(
                                supportedLocales[temporaryLanguage].toString())
                            .then((value) {
                          setState(() {});
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      });
                    },
                    child: SizedBox(
                      width: 80.0,
                      child: Obx(
                        () => Text(
                          LangControl.to.S.value.ok,
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.end,
                          style: kBottomSheetTextStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker.builder(
                  scrollController: extentScrollController,
                  childCount: supportedLocales.length,
                  itemExtent: 36.0,
                  useMagnifier: true,
                  magnification: 1.2,
                  onSelectedItemChanged: (int index) {
                    if (mounted) {
                      temporaryLanguage = index;
                    }
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                        child: Text(
                      '${language.getDisplayLanguage(supportedLocales[index].languageCode)['name']} / ${language.getDisplayLanguage(supportedLocales[index].languageCode)['nativeName']}',
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
  }

//  void showGoalPicker(BuildContext context) async {
//    int goalIndex = DatabaseManager.instance.userSettings.goal - 1;
//
//    FixedExtentScrollController extentScrollController = FixedExtentScrollController(initialItem: goalIndex);
//
//    await showModalBottomSheet(
//      context: context,
//      builder: (BuildContext builder) {
//        int temporaryGoal = goalIndex;
//
//        return Container(
//          height: MediaQuery.of(context).copyWith().size.height / 3,
//          child: Column(
//            children: <Widget>[
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  CupertinoButton(
//                    onPressed: () {
//                      Get.back();
//                    },
//                    child: Container(
//                      width: 80.0,
//                      child: Text(
//                        LangControl.to.S.value.cancel,
//                        textScaleFactor: 1.0,
//                        style: kBottomSheetTextStyle,
//                      ),
//                    ),
//                  ),
//                  Text(
//                    LangControl.to.S.value.how_many_pics,
//                    textScaleFactor: 1.0,
//                    style: kBottomSheetTitleTextStyle,
//                  ),
//                  CupertinoButton(
//                    onPressed: () {
//                      DatabaseManager.instance.changeUserGoal(temporaryGoal);
//                      Get.back();
//                    },
//                    child: Container(
//                      width: 80.0,
//                      child: Text(
//                        LangControl.to.S.value.ok,
//                        textScaleFactor: 1.0,
//                        textAlign: TextAlign.end,
//                        style: kBottomSheetTextStyle,
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//              Expanded(
//                child: CupertinoPicker.builder(
//                  scrollController: extentScrollController,
//                  childCount: 200,
//                  itemExtent: 36.0,
//                  useMagnifier: true,
//                  magnification: 1.2,
//                  onSelectedItemChanged: (int index) {
//                    if (mounted) {
//                      temporaryGoal = index + 1;
//                    }
//                  },
//                  itemBuilder: (BuildContext context, int index) {
//                    return Center(
//                        child: Text(
//                      '${index + 1}',
//                      textScaleFactor: 1.0,
//                    ));
//                  },
//                ),
//              ),
//            ],
//          ),
//        );
//      },
//    );
//  }

  void showTimePicker(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        var now = DateTime.now();
        var time = DateTime(
            now.year,
            now.month,
            now.day,
            UserController.to.hourOfDay.value,
            UserController.to.minutesOfDay.value);

        return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: SizedBox(
                      width: 80.0,
                      child: Obx(
                        () => Text(
                          LangControl.to.S.value.cancel,
                          textScaleFactor: 1.0,
                          style: kBottomSheetTextStyle,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => Text(
                      LangControl.to.S.value.time,
                      textScaleFactor: 1.0,
                      style: kBottomSheetTitleTextStyle,
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      UserController.to
                          .changeUserTimeOfDay(time.hour, time.minute);
                      Get.back();
                    },
                    child: SizedBox(
                      width: 80.0,
                      child: Obx(
                        () => Text(
                          LangControl.to.S.value.ok,
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.end,
                          style: kBottomSheetTextStyle,
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
  }

//  void changeDailyChallenges(BuildContext context, bool value) async {
//    if (value == false) {
//      DatabaseManager.instance.changeDailyChallenges();
//    } else if (value == true && DatabaseManager.instance.userSettings.notifications == false) {
//      showDialog<void>(
//        context: context,
//        builder: (BuildContext context) {
//          return PlatformAlertDialog(
//            title: Text(
//              LangControl.to.S.value.notifications,
//              textScaleFactor: 1.0,
//            ),
//            content: SingleChildScrollView(
//              child: ListBody(
//                children: <Widget>[
//                  Text(
//                    LangControl.to.S.value.daily_challenge_permission_description,
//                    textScaleFactor: 1.0,
//                  ),
//                ],
//              ),
//            ),
//            actions: <Widget>[
//              PlatformDialogAction(
//                child: Text(
//                  LangControl.to.S.value.ok,
//                  textScaleFactor: 1.0,
//                ),
//                actionType: ActionType.Preferred,
//                onPressed: () {
//                  NotificationPermissions.requestNotificationPermissions(iosSettings: const NotificationSettingsIos(sound: true, badge: true, alert: true))
//                      .then((_) {});
//                  Navigator.of(context).pop();
//                },
//              ),
//            ],
//          );
//        },
//      );
//    } else {
//      DatabaseManager.instance.changeDailyChallenges();
//    }
//  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Analytics.sendCurrentScreen(Screen.settings_screen);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      UserController.to.checkNotificationPermission();
    }
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
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 10.0),
                    onPressed: () => Get.back(),
                    child: Image.asset('lib/images/backarrowgray.png'),
                  ),
                  Obx(
                    () => Text(
                      LangControl.to.S.value.settings,
                      textScaleFactor: 1.0,
                      style: kGraySettingsBoldTextStyle,
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      print('do nothing');
                    },
                    child: Container(),
                  ),
                ],
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context,
                      BoxConstraints viewportConstraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: viewportConstraints.maxHeight,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: [
                                const Divider(
                                  color: kLightGrayColor,
                                  thickness: 1.0,
                                ),
                                SizedBox(
                                  height: 60.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: CupertinoButton(
                                      padding: const EdgeInsets.all(0),
                                      pressedOpacity: 1.0,
                                      onPressed: () async {
                                        if (PrivatePhotosController
                                                .to.showPrivate.value ==
                                            true) {
                                          await PrivatePhotosController.to
                                              .switchSecretPhotos();
                                          //galleryStore.removeAllPrivatePics();
                                          return;
                                        }
                                        UserController.to.popPinScreenToId =
                                            SettingsScreen.id;
                                        await Get.toNamed(PinScreen.id);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            LangControl
                                                .to.S.value.private_photos,
                                            textScaleFactor: 1.0,
                                            style: kGraySettingsFieldTextStyle,
                                          ),
                                          Obx(
                                            () {
                                              return SecretSwitch(
                                                value: PrivatePhotosController
                                                    .to.showPrivate.value,
                                                onChanged: (value) async {
                                                  if (value == false) {
                                                    await PrivatePhotosController
                                                        .to
                                                        .switchSecretPhotos();
                                                    //galleryStore .removeAllPrivatePics();
                                                    return;
                                                  }

                                                  UserController.to
                                                          .wantsToActivateBiometric =
                                                      false;
                                                  UserController
                                                          .to.popPinScreenToId =
                                                      SettingsScreen.id;
                                                  await Get.toNamed(
                                                      PinScreen.id);
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(
                                  color: kLightGrayColor,
                                  thickness: 1.0,
                                ),
                                Obx(() {
                                  if (PrivatePhotosController
                                              .to.showPrivate.value ==
                                          true &&
                                      // TODO: throwing error at UserController.to.availableBiometrics.isNotEmpty :
                                      // error: The getter 'isNotEmpty' was called on null.
                                      (UserController
                                          .to.availableBiometrics.isNotEmpty)) {
                                    String? enableBiometric;

                                    if (UserController.to.availableBiometrics
                                        .contains(BiometricType.face)) {
                                      enableBiometric =
                                          LangControl.to.S.value.enable_faceid;
                                    } else if (UserController
                                        .to.availableBiometrics
                                        .contains(BiometricType.iris)) {
                                      enableBiometric = LangControl
                                          .to.S.value.enable_irisscanner;
                                    } else if (UserController
                                        .to.availableBiometrics
                                        .contains(BiometricType.fingerprint)) {
                                      enableBiometric = Platform.isIOS
                                          ? LangControl
                                              .to.S.value.enable_touchid
                                          : LangControl
                                              .to.S.value.enable_fingerprint;
                                    }

                                    return FadeIn(
                                      delay: 0,
                                      child: LayoutBuilder(
                                        builder: (context, constraint) {
                                          if (constraint.maxHeight < 30.0) {
                                            return Container();
                                          }
                                          return Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16.0),
                                                    child: CupertinoButton(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      onPressed: () {
                                                        if (UserController
                                                                .to
                                                                .isBiometricActivated
                                                                .value !=
                                                            true) {
                                                          UserController.to
                                                                  .wantsToActivateBiometric =
                                                              true;
                                                          UserController.to
                                                                  .popPinScreenToId =
                                                              SettingsScreen.id;
                                                          Get.to(
                                                              () => PinScreen);
                                                          return;
                                                        }
                                                        UserController.to
                                                            .setIsBiometricActivated(
                                                                false);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Text(
                                                            enableBiometric ??
                                                                '',
                                                            textScaleFactor:
                                                                1.0,
                                                            style:
                                                                kGraySettingsFieldTextStyle,
                                                          ),
                                                          Obx(() {
                                                            return CupertinoSwitch(
                                                              value: UserController
                                                                  .to
                                                                  .isBiometricActivated
                                                                  .value,
                                                              activeColor:
                                                                  kSecondaryColor,
                                                              onChanged:
                                                                  (value) async {
                                                                if (value ==
                                                                    true) {
                                                                  UserController
                                                                          .to
                                                                          .wantsToActivateBiometric =
                                                                      true;
                                                                  UserController
                                                                          .to
                                                                          .popPinScreenToId =
                                                                      SettingsScreen
                                                                          .id;
                                                                  await Get.to(() =>
                                                                      PinScreen());
                                                                  return;
                                                                }

                                                                await UserController
                                                                    .to
                                                                    .setIsBiometricActivated(
                                                                        value);
                                                              },
                                                            );
                                                          }),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const Divider(
                                                color: kLightGrayColor,
                                                thickness: 1.0,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    );
                                  }
                                  return Container();
                                }),
                                // Divider(
                                //   color: kLightGrayColor,
                                //   thickness: 1.0,
                                // ),
                                // Obx( () {
                                //   if (UserController.to.secretPhotos == true) {
                                //     return FadeIn(
                                //       delay: 0,
                                //       child: LayoutBuilder(
                                //         builder: (context, constraint) {
                                //           if (constraint.maxHeight < 30.0) {
                                //             return Container();
                                //           }
                                //           return Column(
                                //             mainAxisSize: MainAxisSize.max,
                                //             children: [
                                //               Expanded(
                                //                 child: Container(
                                //                   child: Padding(
                                //                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                //                     child: CupertinoButton(
                                //                       padding: const EdgeInsets.all(0),
                                //                       onPressed: () => showRequirePinPicker(context),
                                //                       child: Row(
                                //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //                         children: <Widget>[
                                //                           Text(
                                //                             'Require Secret Key',
                                //                             textScaleFactor: 1.0,
                                //                             style: kGraySettingsFieldTextStyle,
                                //                           ),
                                //                           Obx( () {
                                //                             return Text(
                                //                               kRequireOptions[UserController.to.requireSecret],
                                //                               textScaleFactor: 1.0,
                                //                               style: kGraySettingsValueTextStyle,
                                //                             );
                                //                           }),
                                //                         ],
                                //                       ),
                                //                     ),
                                //                   ),
                                //                 ),
                                //               ),
                                //               Divider(
                                //                 color: kLightGrayColor,
                                //                 thickness: 1.0,
                                //               ),
                                //             ],
                                //           );
                                //         },
                                //       ),
                                //     );
                                //   }
                                //   return Container();
                                // }),
                                // Container(
                                //   height: 60.0,
                                //   child: Padding(
                                //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                //     child: CupertinoButton(
                                //       padding: const EdgeInsets.all(0),
                                //       pressedOpacity: 1.0,
                                //       onPressed: () {
                                //         UserController.to.switchDailyChallenges(
                                //           notificationTitle: LangControl.to.S.value.daily_notification_title,
                                //           notificationDescription: LangControl.to.S.value.daily_notification_description,
                                //         );
                                //       },
                                //       child: Row(
                                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //         children: <Widget>[
                                //           Text(
                                //             LangControl.to.S.value.daily_challenge,
                                //             textScaleFactor: 1.0,
                                //             style: kGraySettingsFieldTextStyle,
                                //           ),
                                //           Obx(
                                //              () {
                                //               return CupertinoSwitch(
                                //                 value: UserController.to.dailyChallenges, // Provider.of<DatabaseManager>(context).userSettings.dailyChallenges,
                                //                 activeColor: kSecondaryColor,
                                //                 onChanged: (value) {
                                //                   UserController.to.switchDailyChallenges(
                                //                     notificationTitle: LangControl.to.S.value.daily_notification_title,
                                //                     notificationDescription: LangControl.to.S.value.daily_notification_description,
                                //                   );
                                //                 },
                                //               );
                                //             },
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // Divider(
                                //   color: kLightGrayColor,
                                //   thickness: 1.0,
                                // ),
                                // Container(
                                //   height: 60.0,
                                //   child: Padding(
                                //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                //     child: CupertinoButton(
                                //       padding: const EdgeInsets.all(0),
                                //       onPressed: () => showTimePicker(context),
                                //       child: Row(
                                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //         children: <Widget>[
                                //           Text(
                                //             LangControl.to.S.value.notification_time,
                                //             textScaleFactor: 1.0,
                                //             style: kGraySettingsFieldTextStyle,
                                //           ),
                                //           Obx(
                                //              () {
                                //               return Text(
                                //                 '${'${UserController.to.hourOfDay}'.padLeft(2, '0')}: ${'${UserController.to.minutesOfDay}'.padLeft(2, '0')}',
                                //                 textScaleFactor: 1.0,
                                //                 style: kGraySettingsValueTextStyle,
                                //               );
                                //             },
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
//                    Container(
//                      height: 60.0,
//                      child: Padding(
//                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                        child: CupertinoButton(
//                          padding: const EdgeInsets.all(0),
//                          onPressed: () => showGoalPicker(context),
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            children: <Widget>[
//                              Text(
//                                LangControl.to.S.value.daily_goal,
//                                textScaleFactor: 1.0,
//                                style: kGraySettingsFieldTextStyle,
//                              ),
//                              Text(
//                                '${Provider.of<DatabaseManager>(context).userSettings.goal}',
//                                textScaleFactor: 1.0,
//                                style: kGraySettingsValueTextStyle,
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ),
//                                 Divider(
//                                   color: kLightGrayColor,
//                                   thickness: 1.0,
//                                 ),
                                SizedBox(
                                  height: 60.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: CupertinoButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () =>
                                          showLanguagePicker(context),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Obx(
                                            () => Text(
                                              LangControl.to.S.value.language,
                                              textScaleFactor: 1.0,
                                              style:
                                                  kGraySettingsFieldTextStyle,
                                            ),
                                          ),
                                          Obx(
                                            () {
                                              return Text(
                                                UserController
                                                    .to.currentLanguage.value,
                                                textScaleFactor: 1.0,
                                                style:
                                                    kGraySettingsValueTextStyle,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(
                                  color: kLightGrayColor,
                                  thickness: 1.0,
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                CupertinoButton(
                                  onPressed: () => shareApp(context),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                          'lib/images/sharegrayicon.png'),
                                      const SizedBox(
                                        width: 15.0,
                                      ),
                                      Text(
                                        LangControl
                                            .to.S.value.share_with_friends,
                                        textScaleFactor: 1.0,
                                        style: kGraySettingsBoldTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                CupertinoButton(
                                  onPressed: () => rateDialog(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset('lib/images/starrateapp.png'),
                                      const SizedBox(
                                        width: 15.0,
                                      ),
                                      Obx(
                                        () => Text(
                                          LangControl.to.S.value.rate_this_app,
                                          textScaleFactor: 1.0,
                                          style: kGraySettingsBoldTextStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                CupertinoButton(
                                  onPressed: () => contactUs(context),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset('lib/images/feedbackico.png'),
                                      const SizedBox(
                                        width: 15.0,
                                      ),
                                      Text(
                                        LangControl
                                            .to.S.value.feedback_bug_report,
                                        textScaleFactor: 1.0,
                                        style: kGraySettingsBoldTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Spacer(),
                            /* Padding(
                              padding: const EdgeInsets.only(
                                  left: 32.0,
                                  right: 32.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: CupertinoButton(
                                onPressed: () {
                                  if (UserController.to.isPremium.value) {
                                    return;
                                  }
                                  /*  Get.to(() => PremiumScreen); */
                                },
                                padding: const EdgeInsets.all(0),
                                child: OutlineGradientButton(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFFFA4D1),
                                      Color(0xFFFFCC00),
                                    ],
                                  ),
                                  strokeWidth: 2.0,
                                  radius: Radius.circular(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 16.0,
                                      ),
                                      Image.asset('lib/images/logopremium.png'),
                                      SizedBox(
                                        width: 16.0,
                                      ),
                                      Flexible(
                                        child: Obx(
                                          () {
                                            return Text(
                                              UserController.to.isPremium.value
                                                  ? S
                                                      .of(context)
                                                      .you_are_premium
                                                  : S
                                                      .of(context)
                                                      .get_premium_now,
                                              maxLines: 2,
                                              textAlign: TextAlign.left,
                                              textScaleFactor: 1.0,
                                              style: kGraySettingsBoldTextStyle
                                                  .copyWith(
                                                      color: kSecondaryColor),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                             */ // Spacer(),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CupertinoButton(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      onPressed: () {
                                        _launchURL(
                                            'https://picpics.link/e/facebook');
                                      },
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                            'lib/images/facebookico.png'),
                                      ),
                                    ),
                                    CupertinoButton(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      onPressed: () {
                                        _launchURL(
                                            'https://picpics.link/e/website');
                                      },
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                            'lib/images/webico.png'),
                                      ),
                                    ),
                                    CupertinoButton(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      onPressed: () {
                                        _launchURL(
                                            'https://picpics.link/e/instagram');
                                      },
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                            'lib/images/instagramico.png'),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CupertinoButton(
                                      onPressed: () {
                                        _launchURL(
                                            'https://picpics.link/e/privacy');
                                      },
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      minSize: 32.0,
                                      child: Obx(
                                        () => Text(
                                          LangControl.to.S.value.privacy_policy,
                                          style: const TextStyle(
                                            color: Color(0xff606566),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Lato',
                                            fontStyle: FontStyle.normal,
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 10.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      '  &   ',
                                      style: TextStyle(
                                        color: Color(0xff606566),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Lato',
                                        fontStyle: FontStyle.normal,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                    CupertinoButton(
                                      onPressed: () {
                                        _launchURL(
                                            'https://picpics.link/e/terms');
                                      },
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      minSize: 32.0,
                                      child: Obx(
                                        () => Text(
                                          LangControl.to.S.value.terms_of_use,
                                          style: const TextStyle(
                                            color: Color(0xff606566),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Lato',
                                            fontStyle: FontStyle.normal,
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 10.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Center(
                                    child: Text(
                                      'VERSION: ${UserController.to.appVersion}',
                                      textScaleFactor: 1.0,
                                      style: kGraySettingsFieldTextStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
