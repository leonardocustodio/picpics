import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoding_platform_interface/geocoding_platform_interface.dart';
import 'package:picPics/analytics_manager.dart';
import 'package:hive/hive.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/model/tag.dart';
import 'package:picPics/model/user.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:picPics/push_notifications_manager.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:picPics/utils/languages.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class DatabaseManager extends ChangeNotifier {
  DatabaseManager._();

  static DatabaseManager _instance;

  static DatabaseManager get instance {
    return _instance ??= DatabaseManager._();
  }

  List<String> slideThumbPhotoIds = [];
  List<double> lastLocationRequest = [0.0, 0.0];

  String currentPhotoCity;
  String currentPhotoState;

  double scale = 1.0;

  String selectedTagKey;
  User userSettings;

  double adOffset = 48.0;

  bool adsIsLoaded = false;
  bool showShowAdAfterReload = false;

  void requestNotification() {
    var userBox = Hive.box('user');
    print('requesting notification...');
    print('dailyChallenges: ${userSettings.dailyChallenges}');

    if (Platform.isIOS) {
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
      _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
      _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
//      _firebaseMessaging.getToken().then((String token) {
//        assert(token != null);
//        print('got token this mean it did accept notification');
//        userSettings.notifications = true;
//        userSettings.dailyChallenges = true;
//        userBox.putAt(0, userSettings);
//      });
//
//      _firebaseMessaging.onIosSettingsRegistered.
    } else {
      print('its android!!!');
      userSettings.notifications = true;
      userSettings.dailyChallenges = true;
      userBox.putAt(0, userSettings);
    }
  }

  String getTagName(String tagKey) {
    var tagsBox = Hive.box('tags');
    Tag getTag = tagsBox.get(tagKey);

    // Verificar isso aqui pois tem a ver com as sugestões!!!!
    print('TagKey: $tagKey');

    if (getTag != null) {
      print('Returning name');
      return getTag.name;
    } else {
      print('### ERROR ### Returning key');
      return null;
    }
  }

  Future<void> initPlatformState(String userId) async {
    if (kDebugMode) {
      Purchases.setDebugLogsEnabled(true);
    }
    await Purchases.setup(
      'FccxPqqfiDFQRbkTkvorJKTrokkeNUMu',
      appUserId: userId,
    );
  }

  Future<bool> checkPremiumStatus() async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
      if (purchaserInfo.entitlements.all["Premium"].isActive) {
        // Grant user "pro" access
        print('you are still premium');
        return true;
      } else {
        print('not premium anymore');
        return false;
      }
      // access latest purchaserInfo
    } on PlatformException catch (e) {
      // Error fetching purchaser info
      return null;
    }
  }

  void loadRemoteConfig() async {
    print('loading remote config....');
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    // Enable developer mode to relax fetch throttling
    remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
    remoteConfig.setDefaults(<String, dynamic>{
      'daily_pics_for_ads': 25,
    });

    await remoteConfig.fetch(expiration: const Duration(hours: 5));
    await remoteConfig.activateFetched();
    print('daily_pics_for_ads: ${remoteConfig.getInt('daily_pics_for_ads')}');
  }

  void changeUserLanguage(String appLanguage, {bool notify = true}) {
    var userBox = Hive.box('user');
    userSettings.appLanguage = appLanguage;
    userBox.putAt(0, userSettings);

    if (notify = true) {
      Analytics.sendEvent(Event.changed_language);
      notifyListeners();
    }
  }

  String getUserLanguage() {
    String appLanguage = userSettings.appLanguage.split('_')[0];
    var language = LanguageLocal();
    return '${language.getDisplayLanguage(appLanguage)['nativeName']}';
  }

  void gridScale(double multiplier) {
    scale = scale;
    print('new scale value: $scale');
  }

  Future findLocation(double latitude, double longitude) async {
    print('Finding location...');
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude, localeIdentifier: 'pt_BR');
    print('Placemark: ${placemarks.first.locality}');
    currentPhotoCity = placemarks.first.locality;
    currentPhotoState = placemarks.first.administrativeArea;
    lastLocationRequest = [latitude, longitude];
  }
}
