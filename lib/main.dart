import 'dart:async';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:picPics/add_location.dart';
import 'package:picPics/asset_provider.dart';
import 'package:picPics/login_screen.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/model/tag.dart';
import 'package:picPics/model/user.dart';
import 'package:picPics/photo_screen.dart';
import 'package:picPics/pic_screen.dart';
import 'package:picPics/premium_screen.dart';
import 'package:picPics/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:picPics/database_manager.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:picPics/admob_manager.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:picPics/generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  Ads.initialize();
  Ads.loadRewarded();
  DatabaseManager.instance.analytics = FirebaseAnalytics();
  DatabaseManager.instance.observer = FirebaseAnalyticsObserver(analytics: DatabaseManager.instance.analytics);

  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(PicAdapter());
  Hive.registerAdapter(TagAdapter());

  var userBox = await Hive.openBox('user');
  var picsBox = await Hive.openBox('pics');
  var tagsBox = await Hive.openBox('tags');

  Future<void> initPlatformState() async {
    Purchases.setDebugLogsEnabled(true);
    await Purchases.setup("FccxPqqfiDFQRbkTkvorJKTrokkeNUMu");
  }

  String initialRoute = PicScreen.id;

  if (userBox.length == 0) {
    print('creating user entry...');

    User user = User(
      id: 'userId',
      email: 'leonardo@custodio.me',
      password: 'pass',
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
      swiperIndex: 0,
    );

    userBox.add(user);
    DatabaseManager.instance.userSettings = user;
    initialRoute = LoginScreen.id;

    Tag tag1 = Tag('Família', []);
    Tag tag2 = Tag('Viagens', []);
    Tag tag3 = Tag('Pets', []);
    Tag tag4 = Tag('Selfies', []);
    Tag tag5 = Tag('Screenshots', []);
    Tag tag6 = Tag('Comidas', []);
    Tag tag7 = Tag('Esportes', []);
    Tag tag8 = Tag('Casa', []);

    Map<String, Tag> entries = {
      DatabaseManager.instance.encryptTag('Família'): tag1,
      DatabaseManager.instance.encryptTag('Viagens'): tag2,
      DatabaseManager.instance.encryptTag('Pets'): tag3,
      DatabaseManager.instance.encryptTag('Selfies'): tag4,
      DatabaseManager.instance.encryptTag('Screenshots'): tag5,
      DatabaseManager.instance.encryptTag('Comidas'): tag6,
      DatabaseManager.instance.encryptTag('Esportes'): tag7,
      DatabaseManager.instance.encryptTag('Casa'): tag8,
    };
    tagsBox.putAll(entries);
  } else {
    DatabaseManager.instance.loadUserSettings();
    DatabaseManager.instance.checkNotificationPermission();
  }

  DatabaseManager.instance.loadRemoteConfig();
  initPlatformState();

  runZonedGuarded(() {
    runApp(
      PicPicsApp(
        initialRoute: initialRoute,
      ),
    );
  }, (Object error, StackTrace stack) {
    Crashlytics.instance.recordError(error, stack);
  });
}

class PicPicsApp extends StatefulWidget {
  final String initialRoute;

  PicPicsApp({@required this.initialRoute});

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
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        initialRoute: widget.initialRoute,
        navigatorObservers: [DatabaseManager.instance.observer],
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          PicScreen.id: (context) => PicScreen(),
          PhotoScreen.id: (context) => PhotoScreen(),
          SettingsScreen.id: (context) => SettingsScreen(),
          AddLocationScreen.id: (context) => AddLocationScreen(),
          PremiumScreen.id: (context) => PremiumScreen(),
        },
      ),
    );
  }
}
