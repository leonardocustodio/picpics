import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:home_widget/home_widget.dart';
import 'package:picPics/model/secret.dart';
import 'package:picPics/screens/add_location.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/screens/email_screen.dart';
import 'package:picPics/screens/login_screen.dart';
import 'package:picPics/screens/tags_screen.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/model/tag.dart';
import 'package:picPics/model/user.dart';
import 'package:picPics/model/user_key.dart';
import 'package:picPics/screens/photo_screen.dart';
import 'package:picPics/screens/pin_screen.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/stores/pin_store.dart';
import 'package:picPics/stores/tabs_store.dart';
import 'package:picPics/screens/tabs_screen.dart';
import 'package:picPics/screens/premium_screen.dart';
import 'package:picPics/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:picPics/managers/database_manager.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hive/hive.dart';
import 'package:picPics/managers/admob_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_device_locale/flutter_device_locale.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'dart:io';
import 'package:picPics/tutorial/tabs_screen.dart';
import 'package:picPics/tutorial/add_location.dart';
import 'package:picPics/tutorial/photo_screen.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:picPics/managers/widget_manager.dart';

Future<String> checkForAppStoreInitiatedProducts() async {
  print('Checking if appstore initiated products');
  List<IAPItem> appStoreProducts = await FlutterInappPurchase.instance.getAppStoreInitiatedProducts();
  if (appStoreProducts.length > 0) {
    return appStoreProducts.last.productId;
  }
  return null;
}

void backgroundFetchHeadlessTask(String taskId) async {
  print('[BackgroundFetch] Headless event received.');
  await WidgetManager.sendAndUpdate();
  BackgroundFetch.finish(taskId);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;

  // CloudFunctions.instance.useFunctionsEmulator(origin: Platform.isAndroid ? 'http://10.0.2.2:5001' : 'http://localhost:5001');

  await Firebase.initializeApp();
  // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kDebugMode ? false : true);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
    );
  }).sendPort);

  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(PicAdapter());
  Hive.registerAdapter(TagAdapter());
  Hive.registerAdapter(SecretAdapter());
  Hive.registerAdapter(UserKeyAdapter());

  var userBox = await Hive.openBox('user');
  var picsBox = await Hive.openBox('pics');
  var tagsBox = await Hive.openBox('tags');

  var secretKey = Uint8List.fromList(
      [76, 224, 117, 70, 57, 101, 39, 29, 48, 239, 215, 240, 41, 149, 198, 69, 64, 5, 207, 227, 190, 126, 8, 133, 136, 234, 130, 91, 254, 104, 196, 158]);
  var secretBox = await Hive.openBox('secrets', encryptionKey: secretKey);

  var skey =
      Uint8List.fromList([71, 204, 179, 71, 12, 51, 19, 9, 98, 19, 225, 200, 1, 5, 6, 79, 55, 18, 13, 18, 19, 25, 6, 5, 18, 22, 135, 97, 22, 17, 188, 155]);
  var keyBox = await Hive.openBox('userkey', encryptionKey: skey);

  String deviceLocale = await DeviceLocale.getCurrentLocale().then((Locale locale) => locale.toString());
  String appVersion = await PackageInfo.fromPlatform().then((PackageInfo packageInfo) => packageInfo.version);
  print('Device Locale: $deviceLocale');

  String initiatedWithProduct;
  if (Platform.isIOS) {
    initiatedWithProduct = await checkForAppStoreInitiatedProducts();
  }

  Analytics.sendAppOpen();
  Ads.initialize();
  Ads.loadRewarded();

  // FlutterBranchSdk.setRequestMetadata(r'$google_analytics_user_id', userId);
  StreamSubscription<Map> streamSubscription = FlutterBranchSdk.initSession().listen((data) {
    if (data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true) {
      //Link clicked. Add logic to get link data
      // print('Custom string: ${data["custom_string"]}');
    }
  }, onError: (error) {
    PlatformException platformException = error as PlatformException;
    // print('InitSession error: ${platformException.code} - ${platformException.message}');
  });

  bool setAppGroup = await HomeWidget.setAppGroupId('group.br.com.inovatso.picPics.Widgets');
  print('Has setted app group: $setAppGroup');

  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

  runZonedGuarded<Future<void>>(() async {
    runApp(
      PicPicsApp(
        appVersion: appVersion,
        deviceLocale: deviceLocale,
        initiatedWithProduct: initiatedWithProduct,
      ),
    );
  }, FirebaseCrashlytics.instance.recordError);
}

class PicPicsApp extends StatefulWidget {
  final String appVersion;
  final String deviceLocale;
  final String initiatedWithProduct;

  PicPicsApp({
    @required this.appVersion,
    @required this.deviceLocale,
    @required this.initiatedWithProduct,
  });

  @override
  _PicPicsAppState createState() => _PicPicsAppState();
}

class _PicPicsAppState extends State<PicPicsApp> with WidgetsBindingObserver {
  AppStore appStore;
  GalleryStore galleryStore;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    appStore = AppStore(
      appVersion: widget.appVersion,
      deviceLocale: widget.deviceLocale,
      initiatedWithProduct: widget.initiatedWithProduct,
    );
    galleryStore = GalleryStore(
      appStore: appStore,
    );

    if (appStore.encryptionKey == null) {
      if (appStore.secretPhotos == true) {
        appStore.switchSecretPhotos();
        galleryStore.removeAllPrivatePics();
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      print('&&&& Here lifecycle!');
      WidgetManager.sendAndUpdate();
    }

    if (state == AppLifecycleState.resumed) {
      // print('&&&&&&&&& App got back from background');
      // if (appStore.secretPhotos) {
      //   appStore.switchSecretPhotos();
      //   galleryStore.removeAllPrivatePics();
      // }
      //
      // galleryStore.checkIsLibraryUpdated();
//      appStore.checkNotificationPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Main Build!!!');
    return MultiProvider(
      providers: [
        Provider<AppStore>.value(
          value: appStore,
        ),
        Provider<GalleryStore>.value(
          value: galleryStore,
        ),
        Provider<TabsStore>.value(
          value: TabsStore(
            appStore: appStore,
            galleryStore: galleryStore,
          ),
        ),
        Provider<PinStore>.value(
          value: PinStore(),
        ),
        ChangeNotifierProvider<DatabaseManager>(
          create: (_) => DatabaseManager.instance,
        ),
      ],
      child: Center(
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
            PinScreen.id: (context) => PinScreen(),
            EmailScreen.id: (context) => EmailScreen(),
            TutsTabsScreen.id: (context) => TutsTabsScreen(),
            TutsPhotoScreen.id: (context) => TutsPhotoScreen(),
            TutsAddLocationScreen.id: (context) => TutsAddLocationScreen(),
            TagsScreen.id: (context) => TagsScreen(),
          },
        ),
      ),
    );
  }
}
