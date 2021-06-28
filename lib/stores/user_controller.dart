import 'dart:async';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:cryptography/cryptography.dart' as cryptography;
import 'package:date_utils/date_utils.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_device_locale/flutter_device_locale.dart';
import 'package:get/get.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:package_info/package_info.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/database/app_database.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/managers/database_manager.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/managers/push_notifications_manager.dart';
import 'package:picPics/stores/database_controller.dart';
import 'package:picPics/stores/private_photos_controller.dart';
import 'package:picPics/utils/helpers.dart';
import 'package:picPics/utils/languages.dart';
import 'package:local_auth/local_auth.dart';
import 'package:picPics/managers/crypto_manager_untouched.dart';

import 'tags_controller.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();
  String appVersion;
  String deviceLocale;
  String? initiatedWithProduct;
  final LocalAuthentication biometricAuth = LocalAuthentication();
  AppDatabase database = AppDatabase();

  final notifications = false.obs;
  final dailyChallenges = false.obs;
  final isPinRegistered = false.obs;
  final keepAskingToDelete = false.obs;
  final shouldDeleteOnPrivate = false.obs;
  final isPremium = false.obs;
  final tutorialCompleted = false.obs;
  final canTagToday = false.obs;
  final hasGalleryPermission = false.obs;
  final waitingAccessCode = false.obs;
  final isMenuExpanded = true.obs;
  final isBiometricActivated = false.obs;
  // observable integers
  final requireSecret = 0.obs;
  final hourOfDay = 20.obs;
  final minutesOfDay = 0.obs;
  final photoHeightInCardWidget = 500.0.obs;
  // observable strings
  final appLanguage = 'en'.obs;
  final currentLanguage = ''.obs;
  // observable lists
  final recentTags = <String>[].obs;
  final availableBiometrics = <BiometricType>[].obs;
  final appLocale = RxString('en');

  @override
  void onReady() {
    DeviceLocale.getCurrentLocale().then((Locale locale) {
      deviceLocale = locale.toString();
    });
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appVersion = packageInfo.version;
    });

    ever(appLanguage, _settingCurrentLanguage);
    initialize();
    _settingCurrentLanguage(null);
    super.onReady();
  }

  void _settingCurrentLanguage(_) {
    String lang = appLanguage.split('_')[0];
    appLocale.value = lang;

    var local = LanguageLocal();
    currentLanguage.value = '${local.getDisplayLanguage(lang)['nativeName']}';
  }

  Future initialize() async {
    MoorUser user =
        await DatabaseController.to.getUser(deviceLocale: deviceLocale);

    notifications.value = user.notification;
    dailyChallenges.value = user.dailyChallenges;
    hourOfDay.value = user.hourOfDay;
    minutesOfDay.value = user.minuteOfDay;
    isPremium.value = user.isPremium;
    tutorialCompleted.value = user.tutorialCompleted;
    appLanguage.value = user.appLanguage;
    hasGalleryPermission.value = user.hasGalleryPermission;
    canTagToday.value = user.canTagToday;
    loggedIn = user.loggedIn ?? false;
    tryBuyId = initiatedWithProduct;
    PrivatePhotosController.to.showPrivate.value = user.secretPhotos ?? false;
    isPinRegistered.value = user.isPinRegistered ?? false;
    keepAskingToDelete.value = user.keepAskingToDelete ?? true;
    shouldDeleteOnPrivate.value = user.shouldDeleteOnPrivate ?? false;
    email = user.email;
    tourCompleted = user.tourCompleted ?? false;
    isBiometricActivated.value = user.isBiometricActivated ?? false;
    starredPhotos = user.starredPhotos ?? [];

    // if (secretBox.length > 0) {
    //   Secret secret = secretBox.getAt(0);
    //   isPinRegistered = secret.pin == null ? false : true;
    // }
    //createDefaultTags(Get.context);

    //TagsController.to.loadAllTags();

    for (String tagKey in user.recentTags) {
      TagsController.to.addRecentTag(tagKey);
    }

    /* if (user.hasGalleryPermission != null || user.tutorialCompleted) {
      requestGalleryPermission();
    } */

    // Executa primeira vez para ver se ainda tem permissão
    checkNotificationPermission();

    DatabaseManager.instance.initPlatformState(user.id);
    DatabaseManager.instance.loadRemoteConfig();

    if (user.isPremium) {
      checkPremiumStatus();
    }

    checkAvailableBiometrics();
  }

  Future<void> setDefaultWidgetImage(AssetEntity entity) async {
    var bytes = await entity.thumbDataWithSize(300, 300);
    String encoded = base64.encode(bytes);

    MoorUser currentUser =
        await database.getSingleMoorUser(createIfNotExist: true);
    await database
        .updateMoorUser(currentUser.copyWith(defaultWidgetImage: encoded));
  }

  List<String> starredPhotos;
  Future<void> addToStarredPhotos(String photoId) async {
    if (starredPhotos.contains(photoId)) {
      return;
    }

    starredPhotos.add(photoId);

    MoorUser currentUser =
        await database.getSingleMoorUser(createIfNotExist: true);
    await database
        .updateMoorUser(currentUser.copyWith(starredPhotos: starredPhotos));
  }

  Future<void> removeFromStarredPhotos(String photoId) async {
    if (!starredPhotos.contains(photoId)) {
      return;
    }

    starredPhotos.remove(photoId);
    MoorUser currentUser =
        await database.getSingleMoorUser(createIfNotExist: true);
    await database
        .updateMoorUser(currentUser.copyWith(starredPhotos: starredPhotos));
  }

  //String initialRoute;
  String? tryBuyId;
  int dailyPicsForAds = 25;
  // int freePrivatePics = 20;
  bool tourCompleted;

  Future<int> get freePrivatePics async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    return remoteConfig.getInt('free_private_pics');
  }

  int get totalPrivatePics {
    var len = 0;
    Future.value([database.getAllPrivate()]).then((secretBox) {
      len = secretBox.length;
    });
    return len;
  }

  void setTryBuyId(String? value) => tryBuyId = value;

  Future<void> requestNotificationPermission() async {
    PushNotificationsManager push = PushNotificationsManager();
    await push.init();

    // if (Platform.isAndroid) {
    //   var userBox = Hive.box('user');
    //   User currentUser = userBox.getAt(0);
    //
    //   currentUser.notifications = true;
    //   currentUser.dailyChallenges = false;
    //   currentUser.save();
    // }
  }

  //@action
  Future<void> checkNotificationPermission(
      {bool firstPermissionCheck = false}) async {
    return NotificationPermissions.getNotificationPermissionStatus()
        .then((status) async {
      MoorUser currentUser = await database.getSingleMoorUser();

      if (status == PermissionStatus.denied) {
        await database.updateMoorUser(currentUser.copyWith(
          notification: false,
        ));
      } else {
        var tempDailyChallenges = currentUser.dailyChallenges;
        if (firstPermissionCheck) {
          tempDailyChallenges = false;
        }
        await database.updateMoorUser(currentUser.copyWith(
          notification: true,
          dailyChallenges: tempDailyChallenges,
        ));
      }

      notifications.value = currentUser.notification;
      dailyChallenges.value = currentUser.dailyChallenges;
    });
  }

  Future<void> switchDailyChallenges(
      {String notificationTitle, String notificationDescription}) async {
    dailyChallenges.value = !dailyChallenges.value;

    MoorUser currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(
        currentUser.copyWith(dailyChallenges: dailyChallenges.value));

    PushNotificationsManager push = PushNotificationsManager();
    if (dailyChallenges.value) {
      push.deregister();
    } else {
      push.register(
        hourOfDay: hourOfDay.value,
        minutesOfDay: minutesOfDay.value,
        title: notificationTitle,
        description: notificationDescription,
      );
    }

    Analytics.sendEvent(Event.notification_switch);
  }

  Future<void> setIsPinRegistered(bool value) async {
    isPinRegistered.value = value;

    MoorUser currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(currentUser.copyWith(isPinRegistered: value));
  }

  Future<void> setKeepAskingToDelete(bool value) async {
    keepAskingToDelete.value = value;

    MoorUser currentUser = await database.getSingleMoorUser();
    await database
        .updateMoorUser(currentUser.copyWith(keepAskingToDelete: value));
  }

  Future<void> setShouldDeleteOnPrivate(bool value) async {
    shouldDeleteOnPrivate.value = value;
    MoorUser currentUser = await database.getSingleMoorUser();
    await database
        .updateMoorUser(currentUser.copyWith(shouldDeleteOnPrivate: value));
  }

  //@action
  void setRequireSecret(int value) => requireSecret.value = value;

  //  int goal;

  Future<void> changeUserTimeOfDay(int hour, int minute) async {
    hourOfDay.value = hour;
    minutesOfDay.value = minute;

    MoorUser currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(currentUser.copyWith(
      hourOfDay: hour,
      minuteOfDay: minute,
    ));

    Analytics.sendEvent(Event.notification_time);

    if (dailyChallenges == true) {
      //      PushNotificationsManager push = PushNotificationsManager();
      //      push.scheduleNotification();
      //print('rescheduling notifications....');
    }
  }

  Future<void> setIsPremium(bool value) async {
    isPremium.value = value;

    MoorUser currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(currentUser.copyWith(isPremium: value));

    if (isPremium == true) {
      setCanTagToday(true);
    }
  }

  Future<void> checkPremiumStatus() async {
    bool premium = await DatabaseManager.instance.checkPremiumStatus();
    if (premium == false) {
      setIsPremium(false);
    }
  }

  //@action
  Future<void> setTutorialCompleted(bool value) async {
    tutorialCompleted.value = value;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.tutorialCompleted = value;
    currentUser.save(); */

    MoorUser currentUser = await database.getSingleMoorUser();
    await database
        .updateMoorUser(currentUser.copyWith(tutorialCompleted: value));
    await requestGalleryPermission();
    Analytics.sendTutorialComplete();
  }

  int picsTaggedToday;

  DateTime lastTaggedPicDate;

  bool loggedIn;

  //@action
  Future<void> setLoggedIn(bool value) async {
    loggedIn = true;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.loggedIn = true;
    currentUser.save(); */

    MoorUser currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(currentUser.copyWith(loggedIn: true));
  }

  //@action
  Future<void> setCanTagToday(bool value) async {
    if (isPremium.value) {
      canTagToday.value = true;
    } else {
      canTagToday.value = value;
    }

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.canTagToday = canTagToday;
    currentUser.save(); */

    MoorUser currentUser = await database.getSingleMoorUser();
    await database
        .updateMoorUser(currentUser.copyWith(canTagToday: canTagToday.value));
  }

  //@action
  Future<void> increaseTodayTaggedPics() async {
    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0); */
    MoorUser currentUser = await database.getSingleMoorUser();

    DateTime lastTaggedPicDate = currentUser.lastTaggedPicDate;
    DateTime dateNow = DateTime.now();
    var picsTaggedToday = currentUser.picsTaggedToday;
    var lastTaggedPicNewDate = dateNow;
    if (lastTaggedPicDate != null &&
        Utils.isSameDay(lastTaggedPicDate, dateNow)) {
      picsTaggedToday += 1;
      //print('same day... increasing number of tagged photos today, now it is: ${currentUser.picsTaggedToday}');

      final RemoteConfig remoteConfig = await RemoteConfig.instance;
      dailyPicsForAds = remoteConfig.getInt('daily_pics_for_ads');
      int mod = currentUser.picsTaggedToday % dailyPicsForAds;

      if (mod == 0) {
        //print('### CALL ADS!!!');

        await database.updateMoorUser(currentUser.copyWith(
          picsTaggedToday: picsTaggedToday,
          lastTaggedPicDate: lastTaggedPicNewDate,
        ));
        setCanTagToday(false);
        return;
      }
    } else {
      //print('(date might be null) or (not same day... resetting counter....)');
      picsTaggedToday = 1;
    }
    await database.updateMoorUser(currentUser.copyWith(
      picsTaggedToday: picsTaggedToday,
      lastTaggedPicDate: lastTaggedPicNewDate,
    ));
    setCanTagToday(true);
  }

  //@action
  Future<bool> requestGalleryPermission() async {
    var result = await PhotoManager.requestPermission();
    if (result) {
      hasGalleryPermission.value = true;
    }

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.hasGalleryPermission = hasGalleryPermission;
    currentUser.save(); */
    MoorUser currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(currentUser.copyWith(
      hasGalleryPermission: result,
    ));

    return result;
  }

  //@action
  Future<void> changeUserLanguage(String language) async {
    appLanguage.value = language;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.appLanguage = language;
    currentUser.save(); */

    MoorUser currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(currentUser.copyWith(
      appLanguage: language,
    ));

    Analytics.sendEvent(Event.changed_language);
  }

  //@action
  Future<void> createDefaultTags(BuildContext? context) async {
    var tagsBox = await database.getAllLabel();

    if (tagsBox.length > 1 || context == null) {
      // Criada a secret tag aqui por isso 1
      //print('Default tags already created');
      return;
    }

    //print('adding default tags...');
    Label tag1 = Label(
        counter: 1,
        lastUsedAt: DateTime.now(),
        key: Helpers.encryptTag(S.of(context).family_tag),
        title: S.of(context).family_tag,
        photoId: []);
    Label tag2 = Label(
        counter: 1,
        lastUsedAt: DateTime.now(),
        key: Helpers.encryptTag(S.of(context).travel_tag),
        title: S.of(context).travel_tag,
        photoId: []);
    Label tag3 = Label(
        counter: 1,
        lastUsedAt: DateTime.now(),
        key: Helpers.encryptTag(S.of(context).pets_tag),
        title: S.of(context).pets_tag,
        photoId: []);
    Label tag4 = Label(
        counter: 1,
        lastUsedAt: DateTime.now(),
        key: Helpers.encryptTag(S.of(context).work_tag),
        title: S.of(context).work_tag,
        photoId: []);
    Label tag5 = Label(
        counter: 1,
        lastUsedAt: DateTime.now(),
        key: Helpers.encryptTag(S.of(context).selfies_tag),
        title: S.of(context).selfies_tag,
        photoId: []);
    Label tag6 = Label(
        counter: 1,
        lastUsedAt: DateTime.now(),
        key: Helpers.encryptTag(S.of(context).parties_tag),
        title: S.of(context).parties_tag,
        photoId: []);
    Label tag7 = Label(
        counter: 1,
        lastUsedAt: DateTime.now(),
        key: Helpers.encryptTag(S.of(context).sports_tag),
        title: S.of(context).sports_tag,
        photoId: []);
    Label tag8 = Label(
        counter: 1,
        lastUsedAt: DateTime.now(),
        key: Helpers.encryptTag(S.of(context).home_tag),
        title: S.of(context).home_tag,
        photoId: []);
    Label tag9 = Label(
        counter: 1,
        lastUsedAt: DateTime.now(),
        key: Helpers.encryptTag(S.of(context).foods_tag),
        title: S.of(context).foods_tag,
        photoId: []);
    Label tag10 = Label(
        counter: 1,
        lastUsedAt: DateTime.now(),
        key: Helpers.encryptTag(S.of(context).screenshots_tag),
        title: S.of(context).screenshots_tag,
        photoId: []);

    List<Label> entries = [
      tag1,
      tag2,
      tag3,
      tag4,
      tag5,
      tag6,
      tag7,
      tag8,
      tag9,
      tag10,
    ];
    await Future.forEach(entries, (newLabel) => database.createLabel(newLabel))
        .then((_) => TagsController.to.loadAllTags());
  }

  //@action
  Future<void> addTagToRecent({String tagKey}) async {
    //print('adding tag to recent: $tagKey');

    /* var userBox = Hive.box('user');
    User getUser = userBox.getAt(0); */
    MoorUser getUser = await database.getSingleMoorUser();

    if (recentTags.contains(tagKey)) {
      recentTags.remove(tagKey);
      recentTags.insert(0, tagKey);
      getUser.recentTags.remove(tagKey);
      getUser.recentTags.insert(0, tagKey);
      await database.updateMoorUser(getUser);
      //print('final tags in recent: ${getUser.recentTags}');
      return;
    }

    while (recentTags.length >= kMaxNumOfRecentTags) {
      //print('removing last');
      recentTags.removeLast();
      getUser.recentTags.removeLast();
    }

    recentTags.insert(0, tagKey);
    getUser.recentTags.insert(0, tagKey);
    await database.updateMoorUser(getUser);
    //print('final tags in recent: ${getUser.recentTags}');
  }

  //@action
  Future<void> removeTagFromRecent({String tagKey}) async {
    /* var userBox = Hive.box('user');
    User getUser = userBox.getAt(0); */

    if (recentTags.contains(tagKey)) {
      MoorUser getUser = await database.getSingleMoorUser();
      recentTags.remove(tagKey);
      getUser.recentTags.remove(tagKey);
      await database.updateMoorUser(getUser);
      /* userBox.putAt(0, getUser); */
      //print('recent tags after removed: ${getUser.recentTags}');
    }
  }

  //@action
  void setWaitingAccessCode(bool value) => waitingAccessCode.value = value;

  bool hasObserver = false;

  PopPinScreenTo popPinScreen;

  cryptography.SecretKey? encryptionKey;
  void setEncryptionKey(cryptography.SecretKey value) => encryptionKey = value;

  String tempEncryptionKey;
  void setTempEncryptionKey(String value) => tempEncryptionKey = value;

  String? email;
  Future<void> setEmail(String value) async {
    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.email = value;
    currentUser.save(); */

    MoorUser currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(currentUser.copyWith(
      email: value,
    ));

    email = value;
  }

  //@action
  void setPhotoHeightInCardWidget(double value) =>
      photoHeightInCardWidget.value = value;

  bool wantsToActivateBiometric = false;

  //@action
  Future<void> setIsBiometricActivated(bool value) async {
    if (value == false) {
      await deactivateBiometric();
    }

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.isBiometricActivated = value;
    currentUser.save(); */
    MoorUser currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(currentUser.copyWith(
      isBiometricActivated: value,
    ));

    isBiometricActivated.value = value;
  }

  //@action
  Future<void> checkAvailableBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await biometricAuth.canCheckBiometrics;
      if (canCheckBiometrics) {
        try {
          biometricAuth.getAvailableBiometrics().then((val) {
            availableBiometrics.value = List<BiometricType>.from(val);
          });
        } catch (e) {
          //print(e);
        }
      }
    } catch (e) {
      //print(e);
    }
  }

  Future<void> saveSecretKey(String value) async {
    /* var userBox = Hive.box('userkey');
    UserKey userKey = UserKey(secretKey: value);
    userBox.put(0, userKey); */
    MoorUser currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(currentUser.copyWith(
      secretKey: value,
    ));
  }

  String getSecretKey() {
    String secret = '';
    Future.value(database.getSingleMoorUser())
        .then((user) => secret = user.secretKey);
    return secret;
  }

  //@action
  Future<void> deactivateBiometric() async {
    await Crypto.deleteEncryptedPin();

    /* var userBox = Hive.box('userkey');
    userBox.delete(0); */
    MoorUser user = await database.getSingleMoorUser();
    await database.updateMoorUser(user.copyWith(secretKey: ''));

    //print('Deleted encrypted info!');
  }

  //@action
  void switchIsMenuExpanded() => isMenuExpanded.value = !isMenuExpanded.value;
}

enum PopPinScreenTo {
  TabsScreen,
  SettingsScreen,
  PhotoScreen,
}
