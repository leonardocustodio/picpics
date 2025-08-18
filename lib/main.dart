import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';
import 'package:picpics/firebase_options.dart';
import 'package:picpics/generated/l10n.dart' as lang;
import 'package:picpics/managers/analytics_manager.dart';
import 'package:picpics/managers/widget_manager.dart';
import 'package:picpics/screens/access_code_screen.dart';
import 'package:picpics/screens/add_location.dart';
import 'package:picpics/screens/all_tags_screen.dart';
import 'package:picpics/screens/email_screen.dart';
import 'package:picpics/screens/login_screen.dart';
import 'package:picpics/screens/photo_screen.dart';
import 'package:picpics/screens/pin_screen.dart';
import 'package:picpics/screens/settings_screen.dart';
import 'package:picpics/screens/tabs_screen.dart';
import 'package:picpics/stores/blur_hash_controller.dart';
import 'package:picpics/stores/database_controller.dart';
import 'package:picpics/stores/language_controller.dart';
import 'package:picpics/stores/login_store.dart';
import 'package:picpics/stores/percentage_dialog_controller.dart';
import 'package:picpics/stores/pin_controller.dart';
import 'package:picpics/stores/private_photos_controller.dart';
import 'package:picpics/stores/swiper_tab_controller.dart';
import 'package:picpics/stores/tabs_controller.dart';
import 'package:picpics/stores/tagged_controller.dart';
import 'package:picpics/stores/tags_controller.dart';
import 'package:picpics/stores/user_controller.dart';
import 'package:picpics/utils/app_logger.dart';

/* Future<String?> checkForUserControllerInitiatedProducts() async {
  AppLogger.d('Checking if appstore initiated products');
  var appStoreProducts =
      await FlutterInappPurchase.instance.getAppStoreInitiatedProducts();
  if (appStoreProducts.isNotEmpty) {
    return appStoreProducts.last.productId;
  }
  return null;
} */

Future<void> backgroundFetchHeadlessTask(String taskId) async {
  AppLogger.d('[BackgroundFetch] Headless event received.');
  await WidgetManager.sendAndUpdate();
  BackgroundFetch.finish(taskId);
}

String initialRoute = LoginScreen.id;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  AppLogger.init();

  //Get.lazyPut(() => RefreshPicPicsController());
  //Get.lazyPut(() => GalleryStore());

  Get.lazyPut<LangControl>(LangControl.new);

  Get.lazyPut<BlurHashController>(BlurHashController.new);
  Get.lazyPut<PercentageDialogController>(PercentageDialogController.new);
  Get.lazyPut<UserController>(UserController.new);
  await lang.S.load(Locale(UserController.to.appLanguage.value)).then((value) {
    LangControl.to.S = Rx<lang.S>(value);
  });
  Get.lazyPut<PrivatePhotosController>(PrivatePhotosController.new);
  Get.lazyPut<AllTagsController>(AllTagsController.new);
  Get.lazyPut<TagsController>(TagsController.new);
  Get.lazyPut<TaggedController>(TaggedController.new);
  Get.lazyPut<SwiperTabController>(SwiperTabController.new);
  Get.lazyPut<DatabaseController>(DatabaseController.new);
  Get.lazyPut<TabsController>(TabsController.new);
  Get.lazyPut<PinController>(PinController.new);
  Get.lazyPut<LoginStore>(LoginStore.new);
  Get.lazyPut<PhotoScreenController>(PhotoScreenController.new);

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
  final user = UserController();
  await user.initialize();

  final setAppGroup =
      await HomeWidget.setAppGroupId('group.br.com.inovatso.picPics.Widgets');
  AppLogger.d('Has setted app group: $setAppGroup');

  await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

  runApp(
    PicPicsApp(
      user: user,
    ),
  );
}

class PicPicsApp extends StatefulWidget {
  const PicPicsApp({required this.user, super.key});
  final UserController user;

  @override
  PicPicsAppState createState() => PicPicsAppState();
}

class PicPicsAppState extends State<PicPicsApp> with WidgetsBindingObserver {
  @override
  void initState() {
    final tutorial = widget.user.tutorialCompleted.value;
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
      AppLogger.d('&&&& Here lifecycle!');
      WidgetManager.sendAndUpdate();
    }

    if (state == AppLifecycleState.resumed) {
      AppLogger.d('&&&&&&&&& App got back from background');
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
    AppLogger.d('Main Build!!!');
    AppLogger.d('lang: ${widget.user.appLocale.value}');
    return GetMaterialApp(
      localizationsDelegates: const [
        lang.S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale(widget.user.appLocale.value),
      supportedLocales: lang.S.delegate.supportedLocales,
      initialRoute: initialRoute,
      navigatorObservers: [Analytics.observer],
      routes: {
        AllTagsScreen.id: (context) => AllTagsScreen(),
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
        AccessCodeScreen.id: (context) => AccessCodeScreen(),
      },
    );
  }
}
