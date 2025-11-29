import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:picpics/firebase_options.dart';
import 'package:picpics/generated/l10n.dart' as lang;
import 'package:picpics/managers/analytics_manager.dart';
import 'package:picpics/managers/widget_manager.dart';
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/tags_provider.dart';
import 'package:picpics/providers/user_provider.dart';
import 'package:picpics/screens/login_screen.dart';
import 'package:picpics/screens/screens_stubs.dart';
import 'package:picpics/screens/tabs_screen.dart';
import 'package:picpics/services/navigation_service.dart';
import 'package:picpics/utils/app_logger.dart';

Future<void> backgroundFetchHeadlessTask(String taskId) async {
  AppLogger.d('[BackgroundFetch] Headless event received.');
  await WidgetManager.sendAndUpdate();
  BackgroundFetch.finish(taskId);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  AppLogger.init();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Set up Home Widget
  final setAppGroup =
      await HomeWidget.setAppGroupId('group.br.com.inovatso.picPics.Widgets');
  AppLogger.d('Has setted app group: $setAppGroup');

  await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

  runApp(
    const ProviderScope(
      child: PicPicsApp(),
    ),
  );
}

class PicPicsApp extends ConsumerStatefulWidget {
  const PicPicsApp({super.key});

  @override
  ConsumerState<PicPicsApp> createState() => _PicPicsAppState();
}

class _PicPicsAppState extends ConsumerState<PicPicsApp>
    with WidgetsBindingObserver {
  String initialRoute = LoginScreen.id;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize providers
    await ref.read(userProvider.notifier).initialize();
    final userState = ref.read(userProvider);

    // Initialize language
    await ref.read(languageProvider.notifier).initialize(userState.appLanguage);

    // Initialize tags
    await ref.read(tagsProvider.notifier).initialize();

    // Set initial route based on tutorial completion
    if (userState.tutorialCompleted) {
      initialRoute = TabsScreen.id;
    }

    setState(() {
      _initialized = true;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      AppLogger.d('&&&& Here lifecycle!');
      WidgetManager.sendAndUpdate();
    }

    if (state == AppLifecycleState.resumed) {
      AppLogger.d('&&&&&&&&& App got back from background');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    final userState = ref.watch(userProvider);

    AppLogger.d('Main Build!!!');
    AppLogger.d('lang: ${userState.appLocale}');

    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      localizationsDelegates: const [
        lang.S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale(userState.appLocale),
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
