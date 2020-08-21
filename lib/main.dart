import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:picPics/add_location.dart';
import 'package:picPics/analytics_manager.dart';
import 'package:picPics/asset_provider.dart';
import 'package:picPics/login_screen.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/model/tag.dart';
import 'package:picPics/model/user.dart';
import 'package:picPics/photo_screen.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/stores/tabs_store.dart';
import 'package:picPics/tabs_screen.dart';
import 'package:picPics/premium_screen.dart';
import 'package:picPics/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:picPics/database_manager.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hive/hive.dart';
import 'package:picPics/admob_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_device_locale/flutter_device_locale.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'dart:io';

//void checkForAppStoreInitiatedProducts() async {
//  print('Checking if appstore initiated products');
//  List<IAPItem> appStoreProducts = await FlutterInappPurchase.instance.getAppStoreInitiatedProducts();
//  if (appStoreProducts.length > 0) {
//    DatabaseManager.instance.appStartInPremium = true;
//    DatabaseManager.instance.trybuyId = appStoreProducts.last.productId;
//  } else {
//    DatabaseManager.instance.appStartInPremium = false;
//    DatabaseManager.instance.trybuyId = null;
//  }
//}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  Ads.initialize();
  Ads.loadRewarded();

  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(PicAdapter());
  Hive.registerAdapter(TagAdapter());

  var userBox = await Hive.openBox('user');
  var picsBox = await Hive.openBox('pics');
  var tagsBox = await Hive.openBox('tags');

//  String initialRoute = TabsScreen.id;
  String deviceLocale = await DeviceLocale.getCurrentLocale().toString();

//  if (DatabaseManager.instance.userSettings.appLanguage == null) {
//    Locale locale = await DeviceLocale.getCurrentLocale();
//    DatabaseManager.instance.changeUserLanguage(
//      locale.toString().split('_')[0],
//      notify: false,
//    );
//  }
//
//  Locale userLocale = Locale(DatabaseManager.instance.userSettings.appLanguage.split('_')[0]);
  DatabaseManager.instance.loadRemoteConfig();
//  initPlatformState();

  String appVersion = await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    return packageInfo.version;
  });

//  if (Platform.isIOS) {
//    await checkForAppStoreInitiatedProducts();
//  }

  runZonedGuarded(() {
    runApp(
      PicPicsApp(
//        userLocale: userLocale,
        appVersion: appVersion,
        deviceLocale: deviceLocale,
      ),
    );
  }, (Object error, StackTrace stack) {
    Crashlytics.instance.recordError(error, stack);
  });
}

class PicPicsApp extends StatefulWidget {
//  final Locale userLocale;
  final String appVersion;
  final String deviceLocale;

  PicPicsApp({
//    @required this.userLocale,
    @required this.appVersion,
    @required this.deviceLocale,
  });

  @override
  _PicPicsAppState createState() => _PicPicsAppState();
}

class _PicPicsAppState extends State<PicPicsApp> {
  @override
  Widget build(BuildContext context) {
    AppStore appStore = AppStore(
      appVersion: widget.appVersion,
      deviceLocale: widget.deviceLocale,
    );

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return MultiProvider(
      providers: [
        Provider<AppStore>.value(
          value: appStore,
        ),
        Provider<GalleryStore>.value(
          value: GalleryStore(
            appStore: appStore,
          ),
        ),
        Provider<TabsStore>.value(
          value: TabsStore(
            appStore: appStore,
          ),
        ),
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
        locale: appStore.appLocale,
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: kDebugMode,
        initialRoute: appStore.initialRoute,
        navigatorObservers: [Analytics.observer],
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
