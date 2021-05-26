import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_device_locale/flutter_device_locale.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';

import 'package:picPics/generated/l10n.dart';
import 'package:picPics/managers/admob_manager.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/managers/widget_manager.dart';
import 'package:picPics/screens/add_location.dart';
import 'package:picPics/screens/email_screen.dart';
import 'package:picPics/screens/login_screen.dart';
import 'package:picPics/screens/migration/migration_screen.dart';
import 'package:picPics/screens/photo_screen.dart';
import 'package:picPics/screens/pin_screen.dart';
import 'package:picPics/screens/premium/premium_screen.dart';
import 'package:picPics/screens/settings_screen.dart';
import 'package:picPics/screens/tabs_screen.dart';
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/stores/gallery_store.dart';

import 'screens/all_tags_screen.dart';
import 'stores/database_controller.dart';
import 'stores/login_store.dart';
import 'stores/pin_store.dart';
import 'stores/swiper_tab_controller.dart';
import 'stores/tabs_controller.dart';
import 'stores/tagged_controller.dart';
import 'stores/tags_controller.dart';

Future<String> checkForUserControllerInitiatedProducts() async {
  //print('Checking if appstore initiated products');
  List<IAPItem> appStoreProducts =
      await FlutterInappPurchase.instance.getAppStoreInitiatedProducts();
  if (appStoreProducts.length > 0) {
    return appStoreProducts.last.productId;
  }
  return null;
}

void backgroundFetchHeadlessTask(String taskId) async {
  //print('[BackgroundFetch] Headless event received.');
  await WidgetManager.sendAndUpdate();
  BackgroundFetch.finish(taskId);
}

String initialRoute = LoginScreen.id;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Get.lazyPut(() => UserController());
  await Get.lazyPut(() => AllTagsController());
  await Get.lazyPut(() => TaggedController());
  await Get.lazyPut(() => SwiperTabController());
  await Get.lazyPut(() => GalleryStore());
  await Get.lazyPut(() => DatabaseController());
  await Get.lazyPut(() => TabsController());
  await Get.lazyPut(() => TagsController());
  await Get.lazyPut(() => PinStore());
  await Get.lazyPut(() => LoginStore());
  await Get.lazyPut(() => PinStore());
  await Get.lazyPut(() => PhotoScreenController());

  await Hive.initFlutter();
/*   Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(PicAdapter());
  Hive.registerAdapter(TagAdapter());
  Hive.registerAdapter(SecretAdapter());
  Hive.registerAdapter(UserKeyAdapter()); */

  await Hive.openBox('user');
  await Hive.openBox('pics');
  await Hive.openBox('tags');
  await Hive.openBox('secrets',
      encryptionKey: Uint8List.fromList([
        76,
        224,
        117,
        70,
        57,
        101,
        39,
        29,
        48,
        239,
        215,
        240,
        41,
        149,
        198,
        69,
        64,
        5,
        207,
        227,
        190,
        126,
        8,
        133,
        136,
        234,
        130,
        91,
        254,
        104,
        196,
        158
      ]));

  /* var keyBox = */ await Hive.openBox('userkey',
      encryptionKey: Uint8List.fromList([
        71,
        204,
        179,
        71,
        12,
        51,
        19,
        9,
        98,
        19,
        225,
        200,
        1,
        5,
        6,
        79,
        55,
        18,
        13,
        18,
        19,
        25,
        6,
        5,
        18,
        22,
        135,
        97,
        22,
        17,
        188,
        155
      ]));

  var userHiveBox = Hive.box('user');
  var picsuserHiveBox = Hive.box('pics');
  var tagsuserHiveBox = Hive.box('tags');
  var secretuserHiveBox = Hive.box('secrets');
  var keyuserHiveBox = Hive.box('userkey');

  if (keyuserHiveBox.length > 0 ||
      userHiveBox.length > 0 ||
      picsuserHiveBox.length > 0 ||
      tagsuserHiveBox.length > 0 ||
      secretuserHiveBox.length > 0) {
    initialRoute = MigrationScreen.id;
  }

  // GestureBinding.instance.resamplingEnabled = true;

  // CloudFunctions.instance.useFunctionsEmulator(origin: Platform.isAndroid ? 'http://10.0.2.2:5001' : 'http://localhost:5001');

  await Firebase.initializeApp();
  // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(kDebugMode ? false : true);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
    );
  }).sendPort);

  String deviceLocale = await DeviceLocale.getCurrentLocale()
      .then((Locale locale) => locale.toString());
  String appVersion = await PackageInfo.fromPlatform()
      .then((PackageInfo packageInfo) => packageInfo.version);
  //print('Device Locale: $deviceLocale');

  String initiatedWithProduct;
  if (Platform.isIOS) {
    initiatedWithProduct = await checkForUserControllerInitiatedProducts();
  }
  UserController user = UserController()
    ..appVersion = appVersion
    ..deviceLocale = deviceLocale
    ..initiatedWithProduct = initiatedWithProduct;
  await user.initialize();

  Analytics.sendAppOpen();
  Ads.initialize();
  Ads.loadRewarded();

  // FlutterBranchSdk.setRequestMetadata(r'$google_analytics_user_id', userId);
  StreamSubscription<Map> streamSubscription =
      FlutterBranchSdk.initSession().listen((data) {
    if (data.containsKey("+clicked_branch_link") &&
        data["+clicked_branch_link"] == true) {
      //Link clicked. Add logic to get link data
      //print('Custom string: ${data["custom_string"]}');
    }
  }, onError: (error) {
    //PlatformException platformException = error as PlatformException;
    //print('InitSession error: ${platformException.code}');
    //print(' - ${platformException.message}');
  });

  //bool setAppGroup = await HomeWidget.setAppGroupId('group.br.com.inovatso.picPics.Widgets');
  //print('Has setted app group: $setAppGroup');

  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  runZonedGuarded<void>(() {
    runApp(
      PicPicsApp(
        user: user,
      ),
    );
  }, FirebaseCrashlytics.instance.recordError);
}

class PicPicsApp extends StatefulWidget {
  final UserController user;
  const PicPicsApp({@required this.user});

  @override
  _PicPicsAppState createState() => _PicPicsAppState();
}

class _PicPicsAppState extends State<PicPicsApp> with WidgetsBindingObserver {
  GalleryStore galleryStore;

  @override
  void initState() {
    galleryStore = GalleryStore()..user = widget.user;
    var tutorial = widget.user.tutorialCompleted.value;
    if (initialRoute != MigrationScreen.id && tutorial) {
      initialRoute = TabsScreen.id;
      //TODO: uncomment
      //Hive.deleteFromDisk();
    }
    WidgetsBinding.instance.addObserver(this);

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    if (widget.user.encryptionKey == null) {
      if (widget.user.secretPhotos == true) {
        widget.user.switchSecretPhotos();
        galleryStore.removeAllPrivatePics();
      }
    }
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      //print('&&&& Here lifecycle!');
      WidgetManager.sendAndUpdate();
    }

    if (state == AppLifecycleState.resumed) {
      //print('&&&&&&&&& App got back from background');
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
    //print('Main Build!!!');
    return Center(
      child: GetMaterialApp(
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: Locale(widget.user.appLocale.value ?? 'en'),
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: kDebugMode,
        initialRoute: initialRoute,
        navigatorObservers: [Analytics.observer],
        routes: {
          AllTagsScreen.id: (context) => AllTagsScreen(picStore: null),
          LoginScreen.id: (context) => LoginScreen(),
          TabsScreen.id: (context) => TabsScreen(),
          PhotoScreen.id: (context) => PhotoScreen(
                picId: null,
                picIdList: <String>[],
              ),
          SettingsScreen.id: (context) => SettingsScreen(),
          AddLocationScreen.id: (context) => AddLocationScreen(),
          PremiumScreen.id: (context) => PremiumScreen(),
          PinScreen.id: (context) => PinScreen(),
          EmailScreen.id: (context) => EmailScreen(),
          //TagsScreen.id: (context) => TagsScreen(),
          MigrationScreen.id: (context) => MigrationScreen(),
        },
      ),
    );
  }
}
