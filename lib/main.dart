import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:picPics/add_location.dart';
import 'package:picPics/asset_provider.dart';
import 'package:picPics/login_screen.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/model/tag.dart';
import 'package:picPics/model/user.dart';
import 'package:picPics/photo_screen.dart';
import 'package:picPics/tabs_screen.dart';
import 'package:picPics/premium_screen.dart';
import 'package:picPics/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:picPics/database_manager.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hive/hive.dart';
import 'package:picPics/admob_manager.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_device_locale/flutter_device_locale.dart';
import 'package:package_info/package_info.dart';

Future<void> initPlatformState() async {
  if (kDebugMode) {
    Purchases.setDebugLogsEnabled(true);
  }
  await Purchases.setup(
    'FccxPqqfiDFQRbkTkvorJKTrokkeNUMu',
    appUserId: DatabaseManager.instance.userSettings.id,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  Ads.initialize();
//  Ads.loadInterstitial();
  Ads.loadRewarded();

  DatabaseManager.instance.analytics = FirebaseAnalytics();
  DatabaseManager.instance.observer = FirebaseAnalyticsObserver(analytics: DatabaseManager.instance.analytics);

  await Hive.initFlutter();
//  var dir = await getApplicationDocumentsDirectory();
//  Hive.init(dir.path);

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(PicAdapter());
  Hive.registerAdapter(TagAdapter());

  var userBox = await Hive.openBox('user');
  var picsBox = await Hive.openBox('pics');
  var tagsBox = await Hive.openBox('tags');

  String initialRoute = TabsScreen.id;

  if (userBox.length == 0) {
    Locale locale = await DeviceLocale.getCurrentLocale();

    var uuid = Uuid();
    User user = User(
      id: uuid.v4(),
      email: null,
      password: null,
      notifications: false,
      dailyChallenges: false,
      goal: 20,
      hourOfDay: 21,
      minutesOfDay: 30,
      isPremium: false,
      recentTags: [],
      tutorialCompleted: false,
      picsTaggedToday: 0,
      lastTaggedPicDate: DateTime.now(),
      canTagToday: true,
      appLanguage: locale.toString(),
      hasSwiped: false,
    );

    userBox.add(user);
    DatabaseManager.instance.userSettings = user;
    initialRoute = LoginScreen.id;
  } else {
    DatabaseManager.instance.loadUserSettings();
    DatabaseManager.instance.checkNotificationPermission();

    if (DatabaseManager.instance.userSettings.hasSwiped == null) {
      DatabaseManager.instance.userSettings.hasSwiped = false;
    }
  }

  if (DatabaseManager.instance.userSettings.appLanguage == null) {
    Locale locale = await DeviceLocale.getCurrentLocale();
    DatabaseManager.instance.changeUserLanguage(
      locale.toString().split('_')[0],
      notify: false,
    );
  }

  Locale userLocale = Locale(DatabaseManager.instance.userSettings.appLanguage.split('_')[0]);
  DatabaseManager.instance.loadRemoteConfig();
  initPlatformState();

  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    DatabaseManager.instance.setAppVersion(packageInfo.version);
  });

  runZonedGuarded(() {
    runApp(
      PicPicsApp(
        initialRoute: initialRoute,
        userLocale: userLocale,
      ),
    );
  }, (Object error, StackTrace stack) {
    Crashlytics.instance.recordError(error, stack);
  });
}

class PicPicsApp extends StatefulWidget {
  final String initialRoute;
  final Locale userLocale;

  PicPicsApp({
    @required this.initialRoute,
    @required this.userLocale,
  });

  @override
  _PicPicsAppState createState() => _PicPicsAppState();
}

class _PicPicsAppState extends State<PicPicsApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DatabaseManager>(
          create: (_) => DatabaseManager.instance,
        ),
        ChangeNotifierProvider<PhotoProvider>(
          create: (_) => PhotoProvider.instance,
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: widget.userLocale,
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false, // kDebugMode
        initialRoute: widget.initialRoute,
        navigatorObservers: [DatabaseManager.instance.observer],
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          TabsScreen.id: (context) => TabsScreen(),
          PhotoScreen.id: (context) => PhotoScreen(),
          SettingsScreen.id: (context) => SettingsScreen(),
          AddLocationScreen.id: (context) => AddLocationScreen(),
          PremiumScreen.id: (context) => PremiumScreen(),
        },
      ),
    );
  }
}
