import 'dart:async';
import 'dart:isolate';

import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';

import 'package:picPics/generated/l10n.dart' as lang;
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/managers/widget_manager.dart';
import 'package:picPics/screens/add_location.dart';
import 'package:picPics/screens/email_screen.dart';
import 'package:picPics/screens/login_screen.dart';
import 'package:picPics/screens/photo_screen.dart';
import 'package:picPics/screens/pin_screen.dart';
import 'package:picPics/screens/tabs_screen.dart';
import 'package:picPics/stores/blur_hash_controller.dart';
import 'package:picPics/stores/language_controller.dart';
import 'package:picPics/stores/percentage_dialog_controller.dart';
import 'package:picPics/stores/private_photos_controller.dart';
import 'package:picPics/stores/user_controller.dart';

import 'firebase_options.dart';
import 'screens/all_tags_screen.dart';
import 'screens/settings_screen.dart';
import 'stores/database_controller.dart';
import 'stores/login_store.dart';
import 'stores/pin_controller.dart';
import 'stores/swiper_tab_controller.dart';
import 'stores/tabs_controller.dart';
import 'stores/tagged_controller.dart';
import 'stores/tags_controller.dart';

/* Future<String?> checkForUserControllerInitiatedProducts() async {
  print('Checking if appstore initiated products');
  var appStoreProducts =
      await FlutterInappPurchase.instance.getAppStoreInitiatedProducts();
  if (appStoreProducts.isNotEmpty) {
    return appStoreProducts.last.productId;
  }
  return null;
} */

void backgroundFetchHeadlessTask(String taskId) async {
  print('[BackgroundFetch] Headless event received.');
  await WidgetManager.sendAndUpdate();
  BackgroundFetch.finish(taskId);
}

String initialRoute = LoginScreen.id;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Get.lazyPut(() => RefreshPicPicsController());
  //Get.lazyPut(() => GalleryStore());

  Get.lazyPut<LangControl>(() => LangControl());

  Get.lazyPut<BlurHashController>(() => BlurHashController());
  Get.lazyPut<PercentageDialogController>(() => PercentageDialogController());
  Get.lazyPut<UserController>(() => UserController());
  await lang.S.load(Locale(UserController.to.appLanguage.value)).then((value) {
    LangControl.to.S = Rx<lang.S>(value);
  });
  Get.lazyPut<PrivatePhotosController>(() => PrivatePhotosController());
  Get.lazyPut<AllTagsController>(() => AllTagsController());
  Get.lazyPut<TagsController>(() => TagsController());
  Get.lazyPut<TaggedController>(() => TaggedController());
  Get.lazyPut<SwiperTabController>(() => SwiperTabController());
  Get.lazyPut<DatabaseController>(() => DatabaseController());
  Get.lazyPut<TabsController>(() => TabsController());
  Get.lazyPut<PinController>(() => PinController());
  Get.lazyPut<LoginStore>(() => LoginStore());
  Get.lazyPut<PhotoScreenController>(() => PhotoScreenController());

  // GestureBinding.instance.resamplingEnabled = true;

  // CloudFunctions.instance.useFunctionsEmulator(origin: Platform.isAndroid ? 'http://10.0.2.2:5001' : 'http://localhost:5001');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  /* if (Platform.isIOS) {
    initiatedWithProduct = await checkForUserControllerInitiatedProducts();
  } */
  var user = UserController();
  await user.initialize();

  // FlutterBranchSdk.setRequestMetadata(r'$google_analytics_user_id', userId);
  var streamSubscription = FlutterBranchSdk.initSession().listen((data) {
    if (data.containsKey('+clicked_branch_link') &&
        data['+clicked_branch_link'] == true) {
      //Link clicked. Add logic to get link data
      print('Custom string: ${data["custom_string"]}');
    }
  }, onError: (error) {
    //PlatformException platformException = error as PlatformException;
    print('InitSession error: ${error.code}');
    print(' - ${error.message}');
  });

  var setAppGroup =
      await HomeWidget.setAppGroupId('group.br.com.inovatso.picPics.Widgets');
  print('Has setted app group: $setAppGroup');

  await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

  runApp(
    PicPicsApp(
      user: user,
    ),
  );
}

class PicPicsApp extends StatefulWidget {
  final UserController user;
  const PicPicsApp({super.key, required this.user});

  @override
  _PicPicsAppState createState() => _PicPicsAppState();
}

class _PicPicsAppState extends State<PicPicsApp> with WidgetsBindingObserver {
  @override
  void initState() {
    var tutorial = widget.user.tutorialCompleted.value;
    if (tutorial) {
      initialRoute = TabsScreen.id;
      //TODO: uncomment
      //Hive.deleteFromDisk();
    }
    WidgetsBinding.instance.addObserver(this);

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    if (widget.user.encryptionKey == null) {
      /* if (widget.user.secretPhotos == true) {
        widget.user.switchSecretPhotos();
        galleryStore.removeAllPrivatePics();
      } */
    }
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      print('&&&& Here lifecycle!');
      WidgetManager.sendAndUpdate();
    }

    if (state == AppLifecycleState.resumed) {
      print('&&&&&&&&& App got back from background');
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
    print('lang: ${widget.user.appLocale.value}');
    return GetMaterialApp(
      localizationsDelegates: const [
        lang.S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale(widget.user.appLocale.value),
      supportedLocales: lang.S.delegate.supportedLocales,
      debugShowCheckedModeBanner: kDebugMode,
      initialRoute: initialRoute,
      navigatorObservers: [Analytics.observer],
      routes: {
        AllTagsScreen.id: (context) => AllTagsScreen(picStore: null),
        LoginScreen.id: (context) => const LoginScreen(),
        TabsScreen.id: (context) => const TabsScreen(),
        PhotoScreen.id: (context) => PhotoScreen(
              picId: '',
              picIdList: const <String>[],
            ),
        SettingsScreen.id: (context) => const SettingsScreen(),
        AddLocationScreen.id: (context) => const AddLocationScreen(null),
        PinScreen.id: (context) => PinScreen(),
        EmailScreen.id: (context) => const EmailScreen(),
      },
    );
  }
}
