import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/generated/l10n.dart';
import 'package:picpics/managers/analytics_manager.dart';
import 'package:picpics/screens/pin_screen.dart';
import 'package:picpics/stores/language_controller.dart';
import 'package:picpics/stores/private_photos_controller.dart';
import 'package:picpics/stores/user_controller.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/languages.dart';
import 'package:picpics/widgets/fadein.dart';
import 'package:picpics/widgets/secret_switch.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {

  const SettingsScreen({super.key});
  static const id = 'settings_Screen';

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
      AppLogger.d('Could not launch $url');
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
            .take_a_look_description('https://picpics.link/share'),);

    Analytics.sendEvent(Event.shared_app);
  }

  void rateDialog() {
    rateMyApp.init().then((_) async {
      if (Platform.isAndroid) {
        await rateMyApp.launchStore();
      } else {
        await rateMyApp.showStarRateDialog(
          context,
          onDismissed: () =>
              rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        );
      }
    });
    Analytics.sendEvent(Event.rated_app);
  }

  Future<void> showRequirePinPicker(BuildContext context) async {
    final extentScrollController = FixedExtentScrollController(
        initialItem: UserController.to.requireSecret.value,);

    await showModalBottomSheet<void>(
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
                    onPressed: () => Get.back<void>(),
                    child: SizedBox(
                      width: 80,
                      child: Obx(
                        () => Text(
                          LangControl.to.S.value.cancel,
                          textScaler: const TextScaler.linear(1),
                          style: kBottomSheetTextStyle,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Require secret key',
                    textScaler: TextScaler.linear(1),
                    style: kBottomSheetTitleTextStyle,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      UserController.to.setRequireSecret(temporaryOption);
                      Get.back<void>();
                    },
                    child: SizedBox(
                      width: 80,
                      child: Obx(
                        () => Text(
                          LangControl.to.S.value.ok,
                          textScaler: const TextScaler.linear(1),
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
                  itemExtent: 36,
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
                      textScaler: const TextScaler.linear(1),
                    ),);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showLanguagePicker(BuildContext context) async {
    final language = LanguageLocal();
    final supportedLocales = S.delegate.supportedLocales;
    final supportedLanguages =
        supportedLocales.map((e) => e.languageCode).toList();
    final appSplit = UserController.to.appLanguage.split('_');
    final languageIndex = supportedLanguages.indexOf(appSplit[0]);

    final extentScrollController =
        FixedExtentScrollController(initialItem: languageIndex);

    await showModalBottomSheet<void>(
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
                    onPressed: () => Get.back<void>(),
                    child: SizedBox(
                      width: 80,
                      child: Obx(
                        () => Text(
                          LangControl.to.S.value.cancel,
                          textScaler: const TextScaler.linear(1),
                          style: kBottomSheetTextStyle,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => Text(
                      LangControl.to.S.value.language,
                      textScaler: const TextScaler.linear(1),
                      style: kBottomSheetTitleTextStyle,
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      showDialog<void>(
                          context: context,
                          builder: (context) => Center(
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: CupertinoActivityIndicator(),
                                  ),
                                ),
                              ),);
                      UserController.to
                          .changeUserLanguage(
                              supportedLocales[temporaryLanguage].toString(),)
                          .then((_) {
                        LangControl.to
                            .changeLanguageTo(
                                supportedLocales[temporaryLanguage].toString(),)
                            .then((value) {
                          setState(() {});
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      });
                    },
                    child: SizedBox(
                      width: 80,
                      child: Obx(
                        () => Text(
                          LangControl.to.S.value.ok,
                          textScaler: const TextScaler.linear(1),
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
                  itemExtent: 36,
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
                      textScaler: const TextScaler.linear(1),
                    ),);
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
//                      Get.back<void>();
//                    },
//                    child: Container(
//                      width: 80.0,
//                      child: Text(
//                        LangControl.to.S.value.cancel,
//                        textScaler: TextScaler.linear(1.0),
//                        style: kBottomSheetTextStyle,
//                      ),
//                    ),
//                  ),
//                  Text(
//                    LangControl.to.S.value.how_many_pics,
//                    textScaler: TextScaler.linear(1.0),
//                    style: kBottomSheetTitleTextStyle,
//                  ),
//                  CupertinoButton(
//                    onPressed: () {
//                      DatabaseManager.instance.changeUserGoal(temporaryGoal);
//                      Get.back<void>();
//                    },
//                    child: Container(
//                      width: 80.0,
//                      child: Text(
//                        LangControl.to.S.value.ok,
//                        textScaler: TextScaler.linear(1.0),
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
//                      textScaler: TextScaler.linear(1.0),
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

  Future<void> showTimePicker(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext builder) {
        final now = DateTime.now();
        var time = DateTime(
            now.year,
            now.month,
            now.day,
            UserController.to.hourOfDay.value,
            UserController.to.minutesOfDay.value,);

        return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    onPressed: () => Get.back<void>(),
                    child: SizedBox(
                      width: 80,
                      child: Obx(
                        () => Text(
                          LangControl.to.S.value.cancel,
                          textScaler: const TextScaler.linear(1),
                          style: kBottomSheetTextStyle,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => Text(
                      LangControl.to.S.value.time,
                      textScaler: const TextScaler.linear(1),
                      style: kBottomSheetTitleTextStyle,
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      UserController.to
                          .changeUserTimeOfDay(time.hour, time.minute);
                      Get.back<void>();
                    },
                    child: SizedBox(
                      width: 80,
                      child: Obx(
                        () => Text(
                          LangControl.to.S.value.ok,
                          textScaler: const TextScaler.linear(1),
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
//              textScaler: TextScaler.linear(1.0),
//            ),
//            content: SingleChildScrollView(
//              child: ListBody(
//                children: <Widget>[
//                  Text(
//                    LangControl.to.S.value.daily_challenge_permission_description,
//                    textScaler: TextScaler.linear(1.0),
//                  ),
//                ],
//              ),
//            ),
//            actions: <Widget>[
//              PlatformDialogAction(
//                child: Text(
//                  LangControl.to.S.value.ok,
//                  textScaler: TextScaler.linear(1.0),
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
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 10,),
                    onPressed: () => Get.back<void>(),
                    child: Image.asset('lib/images/backarrowgray.png'),
                  ),
                  Obx(
                    () => Text(
                      LangControl.to.S.value.settings,
                      textScaler: const TextScaler.linear(1),
                      style: kGraySettingsBoldTextStyle,
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      AppLogger.d('do nothing');
                    },
                    child: Container(),
                  ),
                ],
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context,
                      BoxConstraints viewportConstraints,) {
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
                                  thickness: 1,
                                ),
                                SizedBox(
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16,),
                                    child: CupertinoButton(
                                      padding: const EdgeInsets.all(0),
                                      pressedOpacity: 1,
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
                                        await Get.toNamed<void>(PinScreen.id);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            LangControl
                                                .to.S.value.private_photos,
                                            textScaler: const TextScaler.linear(1),
                                            style: kGraySettingsFieldTextStyle,
                                          ),
                                          Obx(
                                            () {
                                              return SecretSwitch(
                                                value: PrivatePhotosController
                                                    .to.showPrivate.value,
                                                onChanged: (bool value) async {
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
                                                  await Get.toNamed<void>(
                                                      PinScreen.id,);
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
                                  thickness: 1,
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
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,),
                                                    child: CupertinoButton(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0,),
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
                                                          Get.to<void>(
                                                              () => PinScreen,);
                                                          return;
                                                        }
                                                        UserController.to
                                                            .setIsBiometricActivated(
                                                                false,);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Text(
                                                            enableBiometric ??
                                                                '',
                                                            textScaler:
                                                                const TextScaler
                                                                    .linear(
                                                                        1,),
                                                            style:
                                                                kGraySettingsFieldTextStyle,
                                                          ),
                                                          Obx(() {
                                                            return CupertinoSwitch(
                                                              value: UserController
                                                                  .to
                                                                  .isBiometricActivated
                                                                  .value,
                                                              activeTrackColor:
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
                                                                  await Get.to<dynamic>(PinScreen.new,);
                                                                  return;
                                                                }

                                                                await UserController
                                                                    .to
                                                                    .setIsBiometricActivated(
                                                                        value,);
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
                                                thickness: 1,
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
                                //                             textScaler: TextScaler.linear(1.0),
                                //                             style: kGraySettingsFieldTextStyle,
                                //                           ),
                                //                           Obx( () {
                                //                             return Text(
                                //                               kRequireOptions[UserController.to.requireSecret],
                                //                               textScaler: TextScaler.linear(1.0),
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
                                //             textScaler: TextScaler.linear(1.0),
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
                                //             textScaler: TextScaler.linear(1.0),
                                //             style: kGraySettingsFieldTextStyle,
                                //           ),
                                //           Obx(
                                //              () {
                                //               return Text(
                                //                 '${'${UserController.to.hourOfDay}'.padLeft(2, '0')}: ${'${UserController.to.minutesOfDay}'.padLeft(2, '0')}',
                                //                 textScaler: TextScaler.linear(1.0),
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
//                                textScaler: TextScaler.linear(1.0),
//                                style: kGraySettingsFieldTextStyle,
//                              ),
//                              Text(
//                                '${Provider.of<DatabaseManager>(context).userSettings.goal}',
//                                textScaler: TextScaler.linear(1.0),
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
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16,),
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
                                              textScaler:
                                                  const TextScaler.linear(1),
                                              style:
                                                  kGraySettingsFieldTextStyle,
                                            ),
                                          ),
                                          Obx(
                                            () {
                                              return Text(
                                                UserController
                                                    .to.currentLanguage.value,
                                                textScaler:
                                                    const TextScaler.linear(1),
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
                                  thickness: 1,
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
                                          'lib/images/sharegrayicon.png',),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        LangControl
                                            .to.S.value.share_with_friends,
                                        textScaler: const TextScaler.linear(1),
                                        style: kGraySettingsBoldTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                CupertinoButton(
                                  onPressed: rateDialog,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset('lib/images/starrateapp.png'),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Obx(
                                        () => Text(
                                          LangControl.to.S.value.rate_this_app,
                                          textScaler: const TextScaler.linear(1),
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
                                        width: 15,
                                      ),
                                      Text(
                                        LangControl
                                            .to.S.value.feedback_bug_report,
                                        textScaler: const TextScaler.linear(1),
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
                                  /*  Get.to<void>(() => PremiumScreen); */
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
                                              textScaler: TextScaler.linear(1.0),
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
                                      padding: const EdgeInsets.only(top: 8),
                                      onPressed: () {
                                        _launchURL(
                                            'https://picpics.link/e/facebook',);
                                      },
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                            'lib/images/facebookico.png',),
                                      ),
                                    ),
                                    CupertinoButton(
                                      padding: const EdgeInsets.only(top: 8),
                                      onPressed: () {
                                        _launchURL(
                                            'https://picpics.link/e/website',);
                                      },
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                            'lib/images/webico.png',),
                                      ),
                                    ),
                                    CupertinoButton(
                                      padding: const EdgeInsets.only(top: 8),
                                      onPressed: () {
                                        _launchURL(
                                            'https://picpics.link/e/instagram',);
                                      },
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                            'lib/images/instagramico.png',),
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
                                            'https://picpics.link/e/privacy',);
                                      },
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8,),
                                      minimumSize: const Size(32, 32),
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
                                            fontSize: 10,
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
                                        fontSize: 10,
                                      ),
                                    ),
                                    CupertinoButton(
                                      onPressed: () {
                                        _launchURL(
                                            'https://picpics.link/e/terms',);
                                      },
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10,),
                                      minimumSize: const Size(32, 32),
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
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Center(
                                    child: Text(
                                      'VERSION: ${UserController.to.appVersion}',
                                      textScaler: const TextScaler.linear(1),
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
