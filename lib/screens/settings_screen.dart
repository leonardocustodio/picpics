import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/constants.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:picPics/screens/pin_screen.dart';
import 'package:picPics/screens/premium/premium_screen.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/utils/languages.dart';
import 'package:picPics/widgets/fadein.dart';
import 'package:picPics/widgets/secret_switch.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'dart:io';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:local_auth/local_auth.dart';

class SettingsScreen extends StatefulWidget {
  static const id = 'settings_Screen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with WidgetsBindingObserver {
  AppStore appStore;
  GalleryStore galleryStore;

  @override
  void dispose() {
    super.dispose();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      //print('Could not launch $url');
    }
  }

  void contactUs(BuildContext context) {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'picpics@inovatso.com.br',
    );
    launch(_emailLaunchUri.toString());
  }

  RateMyApp rateMyApp = RateMyApp(
    googlePlayIdentifier: 'br.com.inovatso.picPics',
    appStoreIdentifier: '1503352127',
  );

  void shareApp(BuildContext context) {
    Share.text(
      S.of(context).take_a_look,
      S.of(context).take_a_look_description('https://picpics.link/share'),
      'text/plain',
    );
    Analytics.sendEvent(Event.shared_app);
  }

  void rateDialog() {
    rateMyApp.init().then((_) async {
      if (Platform.isAndroid) {
        await rateMyApp.launchStore();
      } else {
        rateMyApp.showStarRateDialog(
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
    FixedExtentScrollController extentScrollController =
        FixedExtentScrollController(
            initialItem: AppStore.to.requireSecret.value);

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        int temporaryOption = AppStore.to.requireSecret.value;

        return Container(
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
                    child: Container(
                      width: 80.0,
                      child: Text(
                        S.of(context).cancel,
                        textScaleFactor: 1.0,
                        style: kBottomSheetTextStyle,
                      ),
                    ),
                  ),
                  Text(
                    'Require secret key',
                    textScaleFactor: 1.0,
                    style: kBottomSheetTitleTextStyle,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      AppStore.to.setRequireSecret(temporaryOption);
                      Get.back();
                    },
                    child: Container(
                      width: 80.0,
                      child: Text(
                        S.of(context).ok,
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end,
                        style: kBottomSheetTextStyle,
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
                      '${kRequireOptions[index]}',
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
    List<String> supportedLanguages =
        supportedLocales.map((e) => e.languageCode).toList();
    List<String> appSplit = AppStore.to.appLanguage.split('_');
    int languageIndex = supportedLanguages.indexOf(appSplit[0]);

    FixedExtentScrollController extentScrollController =
        FixedExtentScrollController(initialItem: languageIndex);

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        int temporaryLanguage = languageIndex;

        return Container(
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
                    child: Container(
                      width: 80.0,
                      child: Text(
                        S.of(context).cancel,
                        textScaleFactor: 1.0,
                        style: kBottomSheetTextStyle,
                      ),
                    ),
                  ),
                  Text(
                    S.of(context).language,
                    textScaleFactor: 1.0,
                    style: kBottomSheetTitleTextStyle,
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: CupertinoActivityIndicator(),
                                  ),
                                ),
                              ));
                      AppStore.to
                          .changeUserLanguage(
                              supportedLocales[temporaryLanguage].toString())
                          .then((_) {
                        setState(
                            () => S.load(supportedLocales[temporaryLanguage]));
                        Get.back();
                      });
                    },
                    child: Container(
                      width: 80.0,
                      child: Text(
                        S.of(context).ok,
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end,
                        style: kBottomSheetTextStyle,
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
//                        S.of(context).cancel,
//                        textScaleFactor: 1.0,
//                        style: kBottomSheetTextStyle,
//                      ),
//                    ),
//                  ),
//                  Text(
//                    S.of(context).how_many_pics,
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
//                        S.of(context).ok,
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
        DateTime now = DateTime.now();
        DateTime time = DateTime(now.year, now.month, now.day,
            AppStore.to.hourOfDay.value, AppStore.to.minutesOfDay.value);

        return Container(
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
                    child: Container(
                      width: 80.0,
                      child: Text(
                        S.of(context).cancel,
                        textScaleFactor: 1.0,
                        style: kBottomSheetTextStyle,
                      ),
                    ),
                  ),
                  Text(
                    S.of(context).time,
                    textScaleFactor: 1.0,
                    style: kBottomSheetTitleTextStyle,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      AppStore.to.changeUserTimeOfDay(time.hour, time.minute);
                      Get.back();
                    },
                    child: Container(
                      width: 80.0,
                      child: Text(
                        S.of(context).ok,
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end,
                        style: kBottomSheetTextStyle,
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
//              S.of(context).notifications,
//              textScaleFactor: 1.0,
//            ),
//            content: SingleChildScrollView(
//              child: ListBody(
//                children: <Widget>[
//                  Text(
//                    S.of(context).daily_challenge_permission_description,
//                    textScaleFactor: 1.0,
//                  ),
//                ],
//              ),
//            ),
//            actions: <Widget>[
//              PlatformDialogAction(
//                child: Text(
//                  S.of(context).ok,
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
      AppStore.to.checkNotificationPermission();
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
                  Text(
                    S.of(context).settings,
                    textScaleFactor: 1.0,
                    style: kGraySettingsBoldTextStyle,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      //print('do nothing');
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
                                Divider(
                                  color: kLightGrayColor,
                                  thickness: 1.0,
                                ),
                                Container(
                                  height: 60.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: CupertinoButton(
                                      padding: const EdgeInsets.all(0),
                                      pressedOpacity: 1.0,
                                      onPressed: () {
                                        if (AppStore.to.secretPhotos == true) {
                                          AppStore.to.switchSecretPhotos();
                                          galleryStore.removeAllPrivatePics();
                                          return;
                                        }
                                        AppStore.to.popPinScreen =
                                            PopPinScreenTo.SettingsScreen;
                                        Get.toNamed(PinScreen.id);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            S.of(context).private_photos,
                                            textScaleFactor: 1.0,
                                            style: kGraySettingsFieldTextStyle,
                                          ),
                                          Obx(
                                            () {
                                              return SecretSwitch(
                                                value: AppStore
                                                    .to.secretPhotos.value,
                                                onChanged: (value) {
                                                  if (value == false) {
                                                    AppStore.to
                                                        .switchSecretPhotos();
                                                    galleryStore
                                                        .removeAllPrivatePics();
                                                    return;
                                                  }

                                                  AppStore.to
                                                          .wantsToActivateBiometric =
                                                      false;
                                                  AppStore.to.popPinScreen =
                                                      PopPinScreenTo
                                                          .SettingsScreen;
                                                  Get.toNamed(PinScreen.id);
                                                },
                                              );
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
                                Obx(() {
                                  if (AppStore.to.secretPhotos == true &&
                                      // TODO: throwing error at AppStore.to.availableBiometrics.isNotEmpty :
                                      // error: The getter 'isNotEmpty' was called on null.
                                      (AppStore.to.availableBiometrics
                                              ?.isNotEmpty ??
                                          false)) {
                                    String enableBiometric;

                                    if (AppStore.to.availableBiometrics
                                        .contains(BiometricType.face)) {
                                      enableBiometric =
                                          S.of(context).enable_faceid;
                                    } else if (AppStore.to.availableBiometrics
                                        .contains(BiometricType.iris)) {
                                      enableBiometric =
                                          S.of(context).enable_irisscanner;
                                    } else if (AppStore.to.availableBiometrics
                                        .contains(BiometricType.fingerprint)) {
                                      enableBiometric = Platform.isIOS
                                          ? S.of(context).enable_touchid
                                          : S.of(context).enable_fingerprint;
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
                                                        if (AppStore.to
                                                                .isBiometricActivated !=
                                                            true) {
                                                          AppStore.to
                                                                  .wantsToActivateBiometric =
                                                              true;
                                                          AppStore.to
                                                                  .popPinScreen =
                                                              PopPinScreenTo
                                                                  .SettingsScreen;
                                                          Get.toNamed(
                                                              PinScreen.id);
                                                          return;
                                                        }
                                                        AppStore.to
                                                            .setIsBiometricActivated(
                                                                false);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Text(
                                                            enableBiometric,
                                                            textScaleFactor:
                                                                1.0,
                                                            style:
                                                                kGraySettingsFieldTextStyle,
                                                          ),
                                                          Obx(() {
                                                            return CupertinoSwitch(
                                                              value: AppStore
                                                                  .to
                                                                  .isBiometricActivated
                                                                  .value,
                                                              activeColor:
                                                                  kSecondaryColor,
                                                              onChanged:
                                                                  (value) async {
                                                                if (value ==
                                                                    true) {
                                                                  AppStore.to
                                                                          .wantsToActivateBiometric =
                                                                      true;
                                                                  AppStore.to
                                                                          .popPinScreen =
                                                                      PopPinScreenTo
                                                                          .SettingsScreen;
                                                                  Get.toNamed(
                                                                      PinScreen
                                                                          .id);
                                                                  return;
                                                                }

                                                                await AppStore
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
                                              Divider(
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
                                //   if (AppStore.to.secretPhotos == true) {
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
                                //                               kRequireOptions[AppStore.to.requireSecret],
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
                                //         AppStore.to.switchDailyChallenges(
                                //           notificationTitle: S.of(context).daily_notification_title,
                                //           notificationDescription: S.of(context).daily_notification_description,
                                //         );
                                //       },
                                //       child: Row(
                                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //         children: <Widget>[
                                //           Text(
                                //             S.of(context).daily_challenge,
                                //             textScaleFactor: 1.0,
                                //             style: kGraySettingsFieldTextStyle,
                                //           ),
                                //           Obx(
                                //              () {
                                //               return CupertinoSwitch(
                                //                 value: AppStore.to.dailyChallenges, // Provider.of<DatabaseManager>(context).userSettings.dailyChallenges,
                                //                 activeColor: kSecondaryColor,
                                //                 onChanged: (value) {
                                //                   AppStore.to.switchDailyChallenges(
                                //                     notificationTitle: S.of(context).daily_notification_title,
                                //                     notificationDescription: S.of(context).daily_notification_description,
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
                                //             S.of(context).notification_time,
                                //             textScaleFactor: 1.0,
                                //             style: kGraySettingsFieldTextStyle,
                                //           ),
                                //           Obx(
                                //              () {
                                //               return Text(
                                //                 '${'${AppStore.to.hourOfDay}'.padLeft(2, '0')}: ${'${AppStore.to.minutesOfDay}'.padLeft(2, '0')}',
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
//                                S.of(context).daily_goal,
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
                                Container(
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
                                          Text(
                                            S.of(context).language,
                                            textScaleFactor: 1.0,
                                            style: kGraySettingsFieldTextStyle,
                                          ),
                                          Obx(
                                            () {
                                              return Text(
                                                AppStore
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
                                Divider(
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
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Text(
                                        S.of(context).share_with_friends,
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
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Text(
                                        S.of(context).rate_this_app,
                                        textScaleFactor: 1.0,
                                        style: kGraySettingsBoldTextStyle,
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
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Text(
                                        S.of(context).feedback_bug_report,
                                        textScaleFactor: 1.0,
                                        style: kGraySettingsBoldTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 32.0,
                                  right: 32.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: CupertinoButton(
                                onPressed: () {
                                  if (AppStore.to.isPremium.value) {
                                    return;
                                  }
                                  Get.toNamed(PremiumScreen.id);
                                },
                                padding: const EdgeInsets.all(0),
                                child: OutlineGradientButton(
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
                                              AppStore.to.isPremium.value
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
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFFFA4D1),
                                      Color(0xFFFFCC00),
                                    ],
                                  ),
                                  strokeWidth: 2.0,
                                  radius: Radius.circular(8.0),
                                ),
                              ),
                            ),
                            // Spacer(),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CupertinoButton(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                            'lib/images/facebookico.png'),
                                      ),
                                      onPressed: () {
                                        _launchURL(
                                            'https://picpics.link/e/facebook');
                                      },
                                    ),
                                    CupertinoButton(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                            'lib/images/webico.png'),
                                      ),
                                      onPressed: () {
                                        _launchURL(
                                            'https://picpics.link/e/website');
                                      },
                                    ),
                                    CupertinoButton(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                            'lib/images/instagramico.png'),
                                      ),
                                      onPressed: () {
                                        _launchURL(
                                            'https://picpics.link/e/instagram');
                                      },
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
                                      child: Text(
                                        S.of(context).privacy_policy,
                                        style: const TextStyle(
                                          color: const Color(0xff606566),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Lato",
                                          fontStyle: FontStyle.normal,
                                          decoration: TextDecoration.underline,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "  &   ",
                                      style: const TextStyle(
                                        color: const Color(0xff606566),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Lato",
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
                                      child: Text(
                                        S.of(context).terms_of_use,
                                        style: const TextStyle(
                                          color: const Color(0xff606566),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Lato",
                                          fontStyle: FontStyle.normal,
                                          decoration: TextDecoration.underline,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Center(
                                    child: Text(
                                      'VERSION: ${AppStore.to.appVersion}',
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
