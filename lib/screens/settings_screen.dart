// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/generated/l10n.dart';
import 'package:picpics/managers/analytics_manager.dart';
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/private_photos_provider.dart';
import 'package:picpics/providers/user_provider.dart';
import 'package:picpics/screens/pin_screen.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/languages.dart';
import 'package:picpics/widgets/fadein.dart';
import 'package:picpics/widgets/secret_switch.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  static const id = 'settings_Screen';

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with WidgetsBindingObserver {

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      AppLogger.d('Could not launch $url');
    }
  }

  void contactUs(BuildContext context) {
    final emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'picpics@inovatso.com.br',
    );
    launchUrl(emailLaunchUri);
  }

  final rateMyApp = RateMyApp(
    googlePlayIdentifier: 'br.com.inovatso.picPics',
    appStoreIdentifier: '1503352127',
  );

  void shareApp(BuildContext context) {
    final s = ref.read(sProvider);
    Share.share(s.take_a_look,
        subject: S.of(context).take_a_look_description('https://picpics.link/share'));
    Analytics.sendEvent(Event.shared_app);
  }

  Future<void> rateDialog() async {
    final dialogContext = context;
    await rateMyApp.init();

    if (Platform.isAndroid) {
      await rateMyApp.launchStore();
    } else {
      if (!mounted) return;
      await rateMyApp.showStarRateDialog(
        dialogContext,
        onDismissed: () =>
            rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
      );
    }

    Analytics.sendEvent(Event.rated_app);
  }

  Future<void> showRequirePinPicker(BuildContext context) async {
    final userState = ref.read(userProvider);
    final extentScrollController = FixedExtentScrollController(
        initialItem: userState.requireSecret);

    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext builder) {
        var temporaryOption = userState.requireSecret;
        final s = ref.read(sProvider);

        return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: SizedBox(
                      width: 80,
                      child: Text(
                        s.cancel,
                        textScaler: const TextScaler.linear(1),
                        style: kBottomSheetTextStyle,
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
                      ref.read(userProvider.notifier).setRequireSecret(temporaryOption);
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: 80,
                      child: Text(
                        s.ok,
                        textScaler: const TextScaler.linear(1),
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

  Future<void> showLanguagePicker(BuildContext context) async {
    final language = LanguageLocal();
    final supportedLocales = S.delegate.supportedLocales;
    final supportedLanguages =
        supportedLocales.map((e) => e.languageCode).toList();
    final userState = ref.read(userProvider);
    final appSplit = userState.appLanguage.split('_');
    final languageIndex = supportedLanguages.indexOf(appSplit[0]);

    final extentScrollController =
        FixedExtentScrollController(initialItem: languageIndex);

    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext builder) {
        var temporaryLanguage = languageIndex;
        final s = ref.read(sProvider);

        return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: SizedBox(
                      width: 80,
                      child: Text(
                        s.cancel,
                        textScaler: const TextScaler.linear(1),
                        style: kBottomSheetTextStyle,
                      ),
                    ),
                  ),
                  Text(
                    s.language,
                    textScaler: const TextScaler.linear(1),
                    style: kBottomSheetTitleTextStyle,
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
                              ));

                      // TODO: Implement language change through providers
                      ref.read(userProvider.notifier).setAppLanguage(
                        supportedLocales[temporaryLanguage].toString()
                      );

                      setState(() {});
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      width: 80,
                      child: Text(
                        s.ok,
                        textScaler: const TextScaler.linear(1),
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

  Future<void> showTimePicker(BuildContext context) async {
    final userState = ref.read(userProvider);

    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext builder) {
        final now = DateTime.now();
        var time = DateTime(
            now.year,
            now.month,
            now.day,
            userState.hourOfDay,
            userState.minutesOfDay);
        final s = ref.read(sProvider);

        return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: SizedBox(
                      width: 80,
                      child: Text(
                        s.cancel,
                        textScaler: const TextScaler.linear(1),
                        style: kBottomSheetTextStyle,
                      ),
                    ),
                  ),
                  Text(
                    s.time,
                    textScaler: const TextScaler.linear(1),
                    style: kBottomSheetTitleTextStyle,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      ref.read(userProvider.notifier).setHourOfDay(time.hour);
                      ref.read(userProvider.notifier).setMinutesOfDay(time.minute);
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: 80,
                      child: Text(
                        s.ok,
                        textScaler: const TextScaler.linear(1),
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
                  mode: CupertinoDatePickerMode.time,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Analytics.sendCurrentScreen(Screen.settings_screen);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(userProvider.notifier).checkNotificationPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final privatePhotosState = ref.watch(privatePhotosProvider);
    final s = ref.watch(sProvider);

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
                        horizontal: 5, vertical: 10),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Image.asset('lib/images/backarrowgray.png'),
                  ),
                  Text(
                    s.settings,
                    textScaler: const TextScaler.linear(1),
                    style: kGraySettingsBoldTextStyle,
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
                                  thickness: 1,
                                ),
                                SizedBox(
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: CupertinoButton(
                                      padding: const EdgeInsets.all(0),
                                      pressedOpacity: 1,
                                      onPressed: () async {
                                        if (privatePhotosState.showPrivate == true) {
                                          ref.read(privatePhotosProvider.notifier).toggleShowPrivate();
                                          return;
                                        }
                                        // TODO: Set popPinScreenToId properly
                                        await Navigator.of(context).pushNamed(PinScreen.id);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            s.private_photos,
                                            textScaler: const TextScaler.linear(1),
                                            style: kGraySettingsFieldTextStyle,
                                          ),
                                          SecretSwitch(
                                            value: privatePhotosState.showPrivate,
                                            onChanged: (bool value) async {
                                              if (value == false) {
                                                ref.read(privatePhotosProvider.notifier).toggleShowPrivate();
                                                return;
                                              }
                                              // TODO: Set wantsToActivateBiometric and popPinScreenToId
                                              await Navigator.of(context).pushNamed(PinScreen.id);
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
                                if (privatePhotosState.showPrivate == true &&
                                    userState.availableBiometrics.isNotEmpty)
                                  Builder(
                                    builder: (context) {
                                      String? enableBiometric;

                                      if (userState.availableBiometrics.contains(BiometricType.face)) {
                                        enableBiometric = s.enable_faceid;
                                      } else if (userState.availableBiometrics.contains(BiometricType.iris)) {
                                        enableBiometric = s.enable_irisscanner;
                                      } else if (userState.availableBiometrics.contains(BiometricType.fingerprint)) {
                                        enableBiometric = Platform.isIOS
                                            ? s.enable_touchid
                                            : s.enable_fingerprint;
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
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                    child: CupertinoButton(
                                                      padding: const EdgeInsets.all(0),
                                                        onPressed: () {
                                                          if (userState.isBiometricActivated != true) {
                                                            // TODO: Set wantsToActivateBiometric
                                                            Navigator.of(context).push<void>(
                                                              MaterialPageRoute<void>(
                                                                builder: (_) => PinScreen(),
                                                              )
                                                            );
                                                            return;
                                                          }
                                                          ref.read(userProvider.notifier).setIsBiometricActivated(false);
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                              enableBiometric ?? '',
                                                              textScaler: const TextScaler.linear(1),
                                                              style: kGraySettingsFieldTextStyle,
                                                            ),
                                                            CupertinoSwitch(
                                                              value: userState.isBiometricActivated,
                                                              activeTrackColor: kSecondaryColor,
                                                              onChanged: (value) async {
                                                                if (value == true) {
                                                                  // TODO: Set wantsToActivateBiometric
                                                                  await Navigator.of(context).push<dynamic>(
                                                                    MaterialPageRoute<dynamic>(
                                                                      builder: (_) => PinScreen(),
                                                                    )
                                                                  );
                                                                  return;
                                                                }
                                                                ref.read(userProvider.notifier).setIsBiometricActivated(value);
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
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                SizedBox(
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: CupertinoButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () => showLanguagePicker(context),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            s.language,
                                            textScaler: const TextScaler.linear(1),
                                            style: kGraySettingsFieldTextStyle,
                                          ),
                                          Text(
                                            userState.currentLanguage,
                                            textScaler: const TextScaler.linear(1),
                                            style: kGraySettingsValueTextStyle,
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
                                      Image.asset('lib/images/sharegrayicon.png'),
                                      const SizedBox(width: 15),
                                      Text(
                                        s.share_with_friends,
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
                                      const SizedBox(width: 15),
                                      Text(
                                        s.rate_this_app,
                                        textScaler: const TextScaler.linear(1),
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
                                      const SizedBox(width: 15),
                                      Text(
                                        s.feedback_bug_report,
                                        textScaler: const TextScaler.linear(1),
                                        style: kGraySettingsBoldTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CupertinoButton(
                                      padding: const EdgeInsets.only(top: 8),
                                      onPressed: () {
                                        _launchURL('https://picpics.link/e/facebook');
                                      },
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset('lib/images/facebookico.png'),
                                      ),
                                    ),
                                    CupertinoButton(
                                      padding: const EdgeInsets.only(top: 8),
                                      onPressed: () {
                                        _launchURL('https://picpics.link/e/website');
                                      },
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset('lib/images/webico.png'),
                                      ),
                                    ),
                                    CupertinoButton(
                                      padding: const EdgeInsets.only(top: 8),
                                      onPressed: () {
                                        _launchURL('https://picpics.link/e/instagram');
                                      },
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset('lib/images/instagramico.png'),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CupertinoButton(
                                      onPressed: () {
                                        _launchURL('https://picpics.link/e/privacy');
                                      },
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      minimumSize: const Size(32, 32),
                                      child: Text(
                                        s.privacy_policy,
                                        style: const TextStyle(
                                          color: Color(0xff606566),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Lato',
                                          fontStyle: FontStyle.normal,
                                          decoration: TextDecoration.underline,
                                          fontSize: 10,
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
                                        _launchURL('https://picpics.link/e/terms');
                                      },
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      minimumSize: const Size(32, 32),
                                      child: Text(
                                        s.terms_of_use,
                                        style: const TextStyle(
                                          color: Color(0xff606566),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Lato',
                                          fontStyle: FontStyle.normal,
                                          decoration: TextDecoration.underline,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Center(
                                    child: Text(
                                      'VERSION: ${userState.appVersion}',
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
