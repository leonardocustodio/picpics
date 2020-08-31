import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picPics/analytics_manager.dart';
import 'package:geolocator/geolocator.dart';
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
import 'package:encrypt/encrypt.dart' as E;
import 'package:diacritic/diacritic.dart';

class DatabaseManager extends ChangeNotifier {
  DatabaseManager._();

  static DatabaseManager _instance;

  static DatabaseManager get instance {
    return _instance ??= DatabaseManager._();
  }

  List<bool> picHasTag;
  List<int> sliderIndex;

  bool noTaggedPhoto = false;
  List<String> slideThumbPhotoIds = [];

  List<double> lastLocationRequest = [0.0, 0.0];

  String currentPhotoCity;
  String currentPhotoState;

//  List<String> suggestionTags = [];

  double scale = 1.0;

  String addingTagId = '';
  int addingTagIndex = 0;
  String selectedTagKey;

  User userSettings;

  double adOffset = 48.0;

  // For multipic work
//  bool multiPicBar = false;
//  Set<String> picsSelected = Set();

  bool adsIsLoaded = false;
  bool showShowAdAfterReload = false;

//  void setMultiPicTagKeys(List<String> pics) {
//    multiPicTagKeys = pics;
//    notifyListeners();
//  }

//  Pic selectedPic;
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

  void checkHasTaggedPhotos() {
    var picsBox = Hive.box('pics');

    noTaggedPhoto = true;
    for (Pic pic in picsBox.values) {
      if (pic.tags.length > 0) {
        noTaggedPhoto = false;
        break;
      }
    }
  }

  void saveLocationToPic({double lat, double long, String specifLocation, String generalLocation, String photoId, bool notify = true}) {
    var picsBox = Hive.box('pics');

    Pic getPic = picsBox.get(photoId);

    if (getPic != null) {
      print('found pic');

      getPic.latitude = lat;
      getPic.longitude = long;
      getPic.specificLocation = specifLocation;
      getPic.generalLocation = generalLocation;

      picsBox.put(photoId, getPic);
      print('updated pic with new values');
    }

    if (notify) {
      notifyListeners();
    }
  }

  void reorderSliderIndex(int removeIndex) {
    int indexOfValue = sliderIndex.indexOf(removeIndex);

    List<int> newSliderIndex = [];
    for (int x = 0; x < sliderIndex.length; x++) {
      if (x < indexOfValue) {
        newSliderIndex.add(sliderIndex[x]);
      } else if (x == indexOfValue) {
        print('Skipping value ${sliderIndex[x]}');
      } else {
        newSliderIndex.add(sliderIndex[x - 1]);
      }
    }

    sliderIndex = newSliderIndex;
  }

  void checkPicHasTags(String photoId) {
//    print('Checking photoId $photoId has tags...');
//    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
////    int itemCount = pathProvider.isLoaded ? pathProvider.orderedList.length : 0;
//
//    Pic getPic = getPicInfo(photoId);
//    int indexOfOrderedList = pathProvider.orderedList.indexWhere((element) => element.id == photoId);
//
//    if (indexOfOrderedList == null) {
//      print('### ERROR DID NOT FIND INDEX IN ORDERED LIST');
//      return;
//    }
//
//    if (getPic.tags.length > 0) {
//      print('pic has tags!!!');
//      picHasTag[indexOfOrderedList] = true;
//    } else {
//      print('pic has no tags!!!');
//      picHasTag[indexOfOrderedList] = false;
//    }
  }

  void resetSlider() {
//    swiperIndex = 0;
    sliderIndex = null;
    picHasTag = null;
    notifyListeners();
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

  void sliderHasPics() {
//    GalleryStore galleryStore = Provider.of<GalleryStore>(context, listen: false);
//
//    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
//    int itemCount = pathProvider.isLoaded ? pathProvider.orderedList.length : 0;
//
//    if (itemCount > 0) {
//      sliderIndex = [];
//      picHasTag = [];
//      for (int x = 0; x < pathProvider.orderedList.length; x++) {
//        var item = pathProvider.orderedList[x];
//        Pic pic = DatabaseManager.instance.getPicInfo(item.id);
//        if (pic != null) {
//          if (pic.tags.length > 0) {
//            picHasTag.add(true);
//            continue;
//          }
//        }
//        picHasTag.add(false);
//        sliderIndex.add(x);
//      }
//    }
//
//    print('## Total Item Count: $itemCount');
//    print('## Slider Count: ${sliderIndex.length}');
//    notifyListeners();
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
//    notifyListeners();
  }

  String stripTag(String tag) {
    return removeDiacritics(tag.toLowerCase());
  }

  String encryptTag(String tag) {
    final plainText = stripTag(tag);

    final key = E.Key.fromUtf8('picpics key for encrypting tags!');
    final iv = E.IV.fromLength(16);
    final encrypter = E.Encrypter(E.AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    print('Stripped tag: $tag');
//    print(encrypted.bytes);
    print('Encrypted tag: ${encrypted.base16}');
//    print(encrypted.base64);

    return encrypted.base16;
  }

  String decryptTag(String encrypted) {
    final key = E.Key.fromUtf8('picpics key for encrypting tags!');
    final iv = E.IV.fromLength(16);
    final encrypter = E.Encrypter(E.AES(key));
    var encrypt = E.Encrypted.fromBase16(encrypted);
    final decrypted = encrypter.decrypt(encrypt, iv: iv);

    print('Decrypted tag: $decrypted');
    return decrypted;
  }

  Future findLocation(double latitude, double longitude) async {
    print('Finding location...');
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(latitude, longitude, localeIdentifier: 'pt_BR');
    print('Placemark: ${placemark.first.locality}');
    currentPhotoCity = placemark.first.locality;
    currentPhotoState = placemark.first.administrativeArea;
    lastLocationRequest = [latitude, longitude];
//    notifyListeners();
  }
}
