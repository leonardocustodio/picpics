import 'dart:io';

import 'package:drift/drift.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:picpics/database/app_database.dart';
import 'package:picpics/managers/analytics_manager.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/languages.dart';
/* import 'package:purchases_flutter/purchases_flutter.dart'; */

class DatabaseManager extends ChangeNotifier {
  DatabaseManager._();

  static DatabaseManager? _instance;

  static DatabaseManager get instance {
    return _instance ??= DatabaseManager._();
  }

  /* List<String> slideThumbPhotoIds = []; */
  List<double> lastLocationRequest = [0.0, 0.0];

  String currentPhotoCity = '';
  String currentPhotoState = '';

  double scale = 1;

  //String selectedTagKey;
  late MoorUser userSettings;

  /* double adOffset = 48.0; */
  final database = AppDatabase();

  /* bool adsIsLoaded = false;
  bool showShowAdAfterReload = false; */

  Future<void> requestNotification() async {
    // TODO: commented below line
    //var userBox = Hive.box('user');

    userSettings = (await database.getSingleMoorUser())!;

    AppLogger.d('requesting notification...');
    AppLogger.d('dailyChallenges: $userSettings');

    if (Platform.isIOS) {
      final firebaseMessaging = FirebaseMessaging.instance;
      await firebaseMessaging.requestPermission(
          );

      // _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      // });
      /* _firebaseMessaging.getToken().then((String token) {
        assert(token != null);
AppLogger.d('got token this mean it did accept notification');
        //userSettings.notifications = true;
        //userSettings.dailyChallenges = true;
        //userBox.putAt(0, userSettings);


      await database.updateConfig(
        userSettings.copyWith(
          notification: true,
          dailyChallenges: true,
        ),
      );
      });

      _firebaseMessaging.onIosSettingsRegistered. */
    } else {
      AppLogger.d('its android!!!');
      await database.updateMoorUser(
        userSettings.copyWith(
          notification: true,
          dailyChallenges: true,
        ),
      );

      //userBox.notifications = true;
      //userBox.dailyChallenges = true;
      //userBox.putAt(0, userSettings);
    }
  }

  Future<String?> getTagName(String tagKey) async {
    /* 
    var tagsBox = Hive.box('tags'); */
    final getTag = await database.getLabelByLabelKey(tagKey);

    // Verificar isso aqui pois tem a ver com as sugestões!!!!
    AppLogger.d('TagKey: $tagKey');

    if (getTag != null) {
      AppLogger.d('Returning name');
      return getTag.title;
    } else {
      AppLogger.d('### ERROR ### Returning key');
      return null;
    }
  }

  /* Future<void> initPlatformState(String userId) async {
    if (/* kDebugMode */ true) {
      await Purchases.setDebugLogsEnabled(true);
    }
    await Purchases.setup(
      'FccxPqqfiDFQRbkTkvorJKTrokkeNUMu',
      appUserId: userId,
    );
  } */

  /* Future<bool?> checkPremiumStatus() async {
    try {
      final purchaserInfo = await Purchases.getPurchaserInfo();
      AppLogger.d('### ${purchaserInfo.entitlements}');
      AppLogger.d('### ${purchaserInfo.entitlements.all}');
      if (purchaserInfo.entitlements.all.isEmpty) {
        AppLogger.d('Could not fetch information from premium status!!!');
        return null;
      }

      if (purchaserInfo.entitlements.all['Premium']?.isActive ?? false) {
        // Grant user "pro" access
        AppLogger.d('you are still premium');
        return true;
      } else {
        AppLogger.d('not premium anymore');
        return false;
      }
      // access latest purchaserInfo
    } on PlatformException catch (_) {
      // Error fetching purchaser info
      return null;
    }
  } */

  /* void loadRemoteConfig() async {
    AppLogger.d('loading remote config....');
    final remoteConfig = RemoteConfig.instance;
    // Enable developer mode to relax fetch throttling
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(days: 5),
        minimumFetchInterval:
            const Duration(hours: 5))); //debugMode: kDebugMode));
    await remoteConfig.setDefaults(<String, dynamic>{
      'daily_pics_for_ads': 25,
      'free_private_pics': 20,
    });

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(/* expiration: const Duration(hours: 5) */);
      await remoteConfig.activate();
      AppLogger.d('daily_pics_for_ads: ${remoteConfig.getInt('daily_pics_for_ads')}');
      AppLogger.d('free_private_pics: ${remoteConfig.getInt('free_private_pics')}');
    } catch (exception) {
      AppLogger.d(
          'Unable to fetch remote config. Cached or default values will be used');
    }
  }
 */
  Future<void> changeUserLanguage(String appLanguage,
      {bool notify = true,}) async {
    await database.updateMoorUser(
      userSettings.copyWith(
        appLanguage: Value(appLanguage),
      ),
    );

    //var userBox = Hive.box('user');
    //userSettings.appLanguage = appLanguage;
    //userBox.putAt(0, userSettings);

    if (notify = true) {
      await Analytics.sendEvent(Event.changed_language);
      notifyListeners();
    }
  }

  String getUserLanguage() {
    final appLanguage = userSettings.appLanguage?.split('_')[0];
    final language = LanguageLocal();
    return '${language.getDisplayLanguage(appLanguage)['nativeName']}';
  }

  void gridScale(double multiplier) {
    scale = scale;
    AppLogger.d('new scale value: $scale');
  }

  Future<void> findLocation(double latitude, double longitude) async {
    AppLogger.d('Finding location...');
    final placemarks = await placemarkFromCoordinates(latitude, longitude);
    AppLogger.d('Placemark: ${placemarks.first.locality}');
    currentPhotoCity = placemarks.first.locality ?? '';
    currentPhotoState = placemarks.first.administrativeArea ?? '';
    lastLocationRequest = [latitude, longitude];
  }
}
