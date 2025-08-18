import 'dart:async';
import 'dart:convert';

import 'package:cryptography/cryptography.dart' as cryptography;
import 'package:devicelocale/devicelocale.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/database/app_database.dart';
import 'package:picpics/managers/analytics_manager.dart';
import 'package:picpics/managers/crypto_manager.dart';
import 'package:picpics/managers/push_notifications_manager.dart';
import 'package:picpics/stores/database_controller.dart';
import 'package:picpics/stores/language_controller.dart';
import 'package:picpics/stores/tags_controller.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/helpers.dart';
import 'package:picpics/utils/languages.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();
  final appVersion = ''.obs;
  final deviceLocale = ''.obs;
  final LocalAuthentication biometricAuth = LocalAuthentication();
  AppDatabase database = AppDatabase();

  final notifications = false.obs;
  final dailyChallenges = false.obs;
  final isPinRegistered = false.obs;
  final keepAskingToDelete = false.obs;
  final shouldDeleteOnPrivate = false.obs;
  final picsTaggedToday = 0.obs;
  final lastTaggedPicDate = Rxn<DateTime>();

  final loggedIn = false.obs;
  final tutorialCompleted = false.obs;
  final hasGalleryPermission = false.obs;
  final waitingAccessCode = false.obs;
  final isMenuExpanded = true.obs;
  final isBiometricActivated = false.obs;

  /* final starredPhotos = <String, String>{}.obs; */

  //String initialRoute;
  final tourCompleted = false.obs;
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
  Future<void> onReady() async {
    deviceLocale.value = (await Devicelocale.currentLocale) ?? 'en';
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appVersion.value = packageInfo.version;
    });

    ever(appLanguage, _settingCurrentLanguage);
    initialize();
    super.onReady();
  }

  void _settingCurrentLanguage(_) {
    var lang = appLanguage.value.split('_')[0];
    if (lang.trim().isEmpty) {
      lang = 'en';
    }
    appLocale.value = lang;
    LangControl.to.changeLanguageTo(lang);

    final local = LanguageLocal();
    currentLanguage.value = '${local.getDisplayLanguage(lang)['nativeName']}';
  }

  Future<void> initialize() async {
    AppLogger.i('[UserController] Starting initialization...');
    final user =
        await DatabaseController.to.getUser(deviceLocale: deviceLocale.value);

    AppLogger.i('[UserController] User loaded from database:');
    AppLogger.d('  - tutorialCompleted: ${user.tutorialCompleted}');
    AppLogger.d(
        '  - hasGalleryPermission (from DB): ${user.hasGalleryPermission}',);
    AppLogger.d('  - isPinRegistered: ${user.isPinRegistered}');
    AppLogger.d('  - appLanguage: ${user.appLanguage}');

    notifications.value = user.notification;
    dailyChallenges.value = user.dailyChallenges;
    hourOfDay.value = user.hourOfDay;
    minutesOfDay.value = user.minuteOfDay;
    tutorialCompleted.value = user.tutorialCompleted;
    appLanguage.value = user.appLanguage ?? 'en';
    hasGalleryPermission.value = user.hasGalleryPermission;
    loggedIn.value = user.loggedIn;
    isPinRegistered.value = user.isPinRegistered;
    keepAskingToDelete.value = user.keepAskingToDelete;
    shouldDeleteOnPrivate.value = user.shouldDeleteOnPrivate;
    email = user.email;
    tourCompleted.value = user.tourCompleted;
    isBiometricActivated.value = user.isBiometricActivated;
    /* starredPhotos.value = Map<String, String>.from(user.starredPhotos); */

    // if (secretBox.length > 0) {
    //   Secret secret = secretBox.getAt(0);
    //   isPinRegistered = secret.pin == null ? false : true;
    // }
    //createDefaultTags(Get.context);

    //TagsController.to.loadAllTags();
    for (final tagKey in user.recentTags) {
      TagsController.to.addRecentTag(tagKey);
    }

    // Check actual gallery permission status on startup
    AppLogger.i(
        '[UserController] Checking actual gallery permission status...',);
    AppLogger.d('  - Tutorial completed: ${user.tutorialCompleted}');

    if (user.tutorialCompleted) {
      AppLogger.i(
          '[UserController] Tutorial is completed, checking PhotoManager permission...',);
      final permissionStatus = await PhotoManager.requestPermissionExtend();
      AppLogger.i('[UserController] PhotoManager permission status:');
      AppLogger.d('  - isAuth: ${permissionStatus.isAuth}');
      AppLogger.d('  - hasAccess: ${permissionStatus.hasAccess}');

      // Check for either isAuth OR hasAccess - on Android 13+ hasAccess means limited permission
      if (permissionStatus.isAuth || permissionStatus.hasAccess) {
        AppLogger.i(
            '[UserController] Permission granted (isAuth: ${permissionStatus.isAuth}, hasAccess: ${permissionStatus.hasAccess})! Setting hasGalleryPermission to true',);
        hasGalleryPermission.value = true;
        // Update database if permission status changed
        if (!user.hasGalleryPermission) {
          AppLogger.i(
              '[UserController] Updating database with new permission status...',);
          await database.updateMoorUser(user.copyWith(
            hasGalleryPermission: true,
          ),);
        }
      } else {
        AppLogger.i('[UserController] Permission NOT authorized.');
      }
    } else {
      AppLogger.i(
          '[UserController] Tutorial not completed, skipping permission check',);
    }

    AppLogger.i(
        '[UserController] Final hasGalleryPermission value: ${hasGalleryPermission.value}',);

    // Executa primeira vez para ver se ainda tem permissão
    await checkNotificationPermission();

    /* await DatabaseManager.instance.initPlatformState(user.id); */
    /* DatabaseManager.instance.loadRemoteConfig(); */

    await checkAvailableBiometrics();

    _settingCurrentLanguage(null);
  }

  Future<void> setDefaultWidgetImage(AssetEntity entity) async {
    final bytes =
        await entity.thumbnailDataWithSize(const ThumbnailSize.square(300));

    /// TODO: I wants to know what to do in this case scenario
    if (bytes == null) {
      return;
    }
    final encoded = base64.encode(bytes);

    final currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(
        currentUser!.copyWith(defaultWidgetImage: drift.Value(encoded)),);
  }

  /* Future<void> addToStarredPhotos(String photoId) async {
    if (starredPhotos[photoId] != null) {
      return;
    }

    starredPhotos[photoId] = '';

    final currentUser = await database.getSingleMoorUser();
    await database
        .updateMoorUser(currentUser!.copyWith(starredPhotos: starredPhotos));
  }

  Future<void> removeFromStarredPhotos(String photoId) async {
    if (starredPhotos[photoId] == null) {
      return;
    }

    starredPhotos.remove(photoId);
    final currentUser = await database.getSingleMoorUser();
    await database
        .updateMoorUser(currentUser!.copyWith(starredPhotos: starredPhotos));
  }
 */
  /* int get freePrivatePics {
    final remoteConfig = RemoteConfig.instance;
    return remoteConfig.getInt('free_private_pics');
  } */

  /* int get totalPrivatePics {
    var len = 0;
    database.getAllPrivate().then((secretBox) {
      len = secretBox.length;
    });
    return len;
  } */

  Future<void> requestNotificationPermission() async {
    final push = PushNotificationsManager();
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
      {bool firstPermissionCheck = false,}) async {
    final flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final granted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    final hasPermission = granted ?? false;

    final currentUser = await database.getSingleMoorUser();

    if (!hasPermission) {
      await database.updateMoorUser(currentUser!.copyWith(
        notification: false,
      ),);
    } else {
      var tempDailyChallenges = currentUser!.dailyChallenges;
      if (firstPermissionCheck) {
        tempDailyChallenges = false;
      }
      await database.updateMoorUser(currentUser.copyWith(
        notification: true,
        dailyChallenges: tempDailyChallenges,
      ),);
    }

    notifications.value = currentUser.notification;
    dailyChallenges.value = currentUser.dailyChallenges;
  }

  Future<void> switchDailyChallenges(
      {String? notificationTitle, String? notificationDescription,}) async {
    dailyChallenges.value = !dailyChallenges.value;

    final currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(
        currentUser!.copyWith(dailyChallenges: dailyChallenges.value),);

    final push = PushNotificationsManager();
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

    await Analytics.sendEvent(Event.notification_switch);
  }

  Future<void> setIsPinRegistered(bool value) async {
    isPinRegistered.value = value;

    final currentUser = await database.getSingleMoorUser();
    await database
        .updateMoorUser(currentUser!.copyWith(isPinRegistered: value));
  }

  Future<void> setKeepAskingToDelete(bool value) async {
    keepAskingToDelete.value = value;

    final currentUser = await database.getSingleMoorUser();
    await database
        .updateMoorUser(currentUser!.copyWith(keepAskingToDelete: value));
  }

  Future<void> setShouldDeleteOnPrivate(bool value) async {
    shouldDeleteOnPrivate.value = value;
    final currentUser = await database.getSingleMoorUser();
    await database
        .updateMoorUser(currentUser!.copyWith(shouldDeleteOnPrivate: value));
  }

  //@action
  void setRequireSecret(int value) => requireSecret.value = value;

  //  int goal;

  Future<void> changeUserTimeOfDay(int hour, int minute) async {
    hourOfDay.value = hour;
    minutesOfDay.value = minute;

    final currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(currentUser!.copyWith(
      hourOfDay: hour,
      minuteOfDay: minute,
    ),);

    await Analytics.sendEvent(Event.notification_time);

    if (dailyChallenges.value == true) {
      //      PushNotificationsManager push = PushNotificationsManager();
      //      push.scheduleNotification();
      AppLogger.d('rescheduling notifications....');
    }
  }

  //@action
  Future<void> setTutorialCompleted(bool value) async {
    tutorialCompleted.value = value;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.tutorialCompleted = value;
    currentUser.save(); */

    final currentUser = await database.getSingleMoorUser();
    await database
        .updateMoorUser(currentUser!.copyWith(tutorialCompleted: value));
    await requestGalleryPermission();
    await Analytics.sendTutorialComplete();
  }

  //@action
  Future<void> setLoggedIn(bool value) async {
    loggedIn.value = true;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.loggedIn = true;
    currentUser.save(); */

    final currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(currentUser!.copyWith(loggedIn: true));
  }

  //@action
  Future<void> increaseTodayTaggedPics() async {
    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0); */
    final currentUser = await database.getSingleMoorUser();

    // Unused variable commented out to fix warning
    // final lastTaggedPicDate = currentUser!.lastTaggedPicDate;
    final dateNow = DateTime.now();
    final picsTaggedToday = currentUser?.picsTaggedToday ?? 0;
    final lastTaggedPicNewDate = dateNow;

    // TODO: Check this comment as this lib was removed for compatibility
    // if (DateUtils.isSameDay(lastTaggedPicDate, dateNow)) {
    //   picsTaggedToday += 1;
    //   AppLogger.d(
    //       'same day... increasing number of tagged photos today, now it is: ${currentUser.picsTaggedToday}');
    // } else {
    //   AppLogger.d('(date might be null) or (not same day... resetting counter....)');
    //   picsTaggedToday = 1;
    // }
    await database.updateMoorUser(currentUser!.copyWith(
      picsTaggedToday: picsTaggedToday,
      lastTaggedPicDate: lastTaggedPicNewDate,
    ),);
  }

  //@action
  Future<bool> requestGalleryPermission() async {
    AppLogger.d(
        '[UserController.requestGalleryPermission] Requesting permission...',);
    final result = await PhotoManager.requestPermissionExtend();
    AppLogger.d('[UserController.requestGalleryPermission] Permission result:');
    AppLogger.d('  - isAuth: ${result.isAuth}');
    AppLogger.d('  - hasAccess: ${result.hasAccess}');

    // Check for either isAuth OR hasAccess - on Android 13+ hasAccess means limited permission
    final hasPermission = result.isAuth || result.hasAccess;

    if (hasPermission) {
      AppLogger.d(
          '[UserController.requestGalleryPermission] Permission granted (isAuth: ${result.isAuth}, hasAccess: ${result.hasAccess}), updating state',);
      hasGalleryPermission.value = true;
    } else {
      AppLogger.d(
          '[UserController.requestGalleryPermission] Permission denied',);
      hasGalleryPermission.value = false;
    }

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.hasGalleryPermission = hasGalleryPermission;
    currentUser.save(); */
    final currentUser = await database.getSingleMoorUser();
    AppLogger.d(
        '[UserController.requestGalleryPermission] Updating database with permission: $hasPermission',);
    await database.updateMoorUser(currentUser!.copyWith(
      hasGalleryPermission: hasPermission,
    ),);

    return hasPermission;
  }

  //@action
  Future<void> changeUserLanguage(String language) async {
    appLanguage.value = language;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.appLanguage = language;
    currentUser.save(); */

    final currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(currentUser!.copyWith(
      appLanguage: drift.Value(language),
    ),);

    await Analytics.sendEvent(Event.changed_language);
  }

  //@action
  Future<void> createDefaultTags(BuildContext? context) async {
    final tagsBox = await database.getAllLabel();

    if (tagsBox.length > 1 || context == null) {
      // Criada a secret tag aqui por isso 1
      AppLogger.d('Default tags already created');
      return;
    }

    AppLogger.d('adding default tags...');
    final tag1 = Label(
        counter: 1,
        lastUsedAt: DateTime.now(),
        key: Helpers.encryptTag(LangControl.to.S.value.family_tag),
        title: LangControl.to.S.value.family_tag,
        photoId: <String, String>{},);
    final tag2 = Label(
        counter: 1,
        lastUsedAt: DateTime.now(),
        key: Helpers.encryptTag(LangControl.to.S.value.travel_tag),
        title: LangControl.to.S.value.travel_tag,
        photoId: <String, String>{},);
    final tag3 = Label(
        counter: 1,
        lastUsedAt: DateTime.now(),
        key: Helpers.encryptTag(LangControl.to.S.value.pets_tag),
        title: LangControl.to.S.value.pets_tag,
        photoId: <String, String>{},);
    final tag4 = Label(
        counter: 1,
        lastUsedAt: DateTime.now(),
        key: Helpers.encryptTag(LangControl.to.S.value.work_tag),
        title: LangControl.to.S.value.work_tag,
        photoId: <String, String>{},);
    final tag5 = Label(
        counter: 1,
        lastUsedAt: DateTime.now(),
        key: Helpers.encryptTag(LangControl.to.S.value.selfies_tag),
        title: LangControl.to.S.value.selfies_tag,
        photoId: <String, String>{},);
    final tag6 = Label(
        counter: 1,
        lastUsedAt: DateTime.now(),
        key: Helpers.encryptTag(LangControl.to.S.value.parties_tag),
        title: LangControl.to.S.value.parties_tag,
        photoId: <String, String>{},);
    final tag7 = Label(
        counter: 1,
        lastUsedAt: DateTime.now(),
        key: Helpers.encryptTag(LangControl.to.S.value.sports_tag),
        title: LangControl.to.S.value.sports_tag,
        photoId: <String, String>{},);
    final tag8 = Label(
        counter: 1,
        lastUsedAt: DateTime.now(),
        key: Helpers.encryptTag(LangControl.to.S.value.home_tag),
        title: LangControl.to.S.value.home_tag,
        photoId: <String, String>{},);
    final tag9 = Label(
        counter: 1,
        lastUsedAt: DateTime.now(),
        key: Helpers.encryptTag(LangControl.to.S.value.foods_tag),
        title: LangControl.to.S.value.foods_tag,
        photoId: <String, String>{},);
    final tag10 = Label(
        counter: 1,
        lastUsedAt: DateTime.now(),
        key: Helpers.encryptTag(LangControl.to.S.value.screenshots_tag),
        title: LangControl.to.S.value.screenshots_tag,
        photoId: <String, String>{},);

    final entries = <Label>[
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
    await Future.forEach(
            entries, (Label newLabel) => database.createLabel(newLabel),)
        .then((_) => TagsController.to.loadAllTags());
  }

  //@action
  Future<void> addTagToRecent({required String tagKey}) async {
    AppLogger.d('adding tag to recent: $tagKey');

    /* var userBox = Hive.box('user');
    User getUser = userBox.getAt(0); */
    final getUser = await database.getSingleMoorUser();

    if (recentTags.contains(tagKey)) {
      recentTags.remove(tagKey);
      recentTags.insert(0, tagKey);
      getUser!.recentTags.remove(tagKey);
      getUser.recentTags.insert(0, tagKey);
      await database.updateMoorUser(getUser);
      AppLogger.d('final tags in recent: ${getUser.recentTags}');
      return;
    }

    while (recentTags.length >= kMaxNumOfRecentTags) {
      AppLogger.d('removing last');
      recentTags.removeLast();
      getUser!.recentTags.removeLast();
    }

    recentTags.insert(0, tagKey);
    getUser!.recentTags.insert(0, tagKey);
    await database.updateMoorUser(getUser);
    AppLogger.d('final tags in recent: ${getUser.recentTags}');
  }

  //@action
  Future<void> removeTagFromRecent({required String tagKey}) async {
    /* var userBox = Hive.box('user');
    User getUser = userBox.getAt(0); */

    if (recentTags.contains(tagKey)) {
      final getUser = await database.getSingleMoorUser();
      recentTags.remove(tagKey);
      getUser!.recentTags.remove(tagKey);
      await database.updateMoorUser(getUser);
      /* userBox.putAt(0, getUser); */
      AppLogger.d('recent tags after removed: ${getUser.recentTags}');
    }
  }

  //@action
  void setWaitingAccessCode(bool value) => waitingAccessCode.value = value;

  bool hasObserver = false;

  String? popPinScreenToId;

  cryptography.SecretKey? encryptionKey;
  void setEncryptionKey(cryptography.SecretKey? value) => encryptionKey = value;

  String? tempEncryptionKey;
  void setTempEncryptionKey(String? value) => tempEncryptionKey = value;

  String? email;
  Future<void> setEmail(String value) async {
    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.email = value;
    currentUser.save(); */

    AppLogger.d('setting email: $value');

    final currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(currentUser!.copyWith(
      email: drift.Value(value),
    ),);

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
    final currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(currentUser!.copyWith(
      isBiometricActivated: value,
    ),);

    isBiometricActivated.value = value;
  }

  //@action
  Future<void> checkAvailableBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await biometricAuth.canCheckBiometrics;
      if (canCheckBiometrics) {
        try {
          await biometricAuth.getAvailableBiometrics().then((val) {
            availableBiometrics.value = List<BiometricType>.from(val);
          });
        } catch (e) {
          AppLogger.d(e);
        }
      }
    } catch (e) {
      AppLogger.d(e);
    }
  }

  Future<void> saveSecretKey(String value) async {
    /* var userBox = Hive.box('userkey');
    UserKey userKey = UserKey(secretKey: value);
    userBox.put(0, userKey); */
    final currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(currentUser!.copyWith(
      secretKey: drift.Value(value),
    ),);
  }

  Future<String?> getSecretKey() async {
    return (await database.getSingleMoorUser())!.secretKey;
  }

  //@action
  Future<void> deactivateBiometric() async {
    await Crypto.deleteEncryptedPin();

    /* var userBox = Hive.box('userkey');
    userBox.delete(0); */
    final user = await database.getSingleMoorUser();
    await database
        .updateMoorUser(user!.copyWith(secretKey: const drift.Value('')));

    AppLogger.d('Deleted encrypted info!');
  }

  //@action
  void switchIsMenuExpanded() => isMenuExpanded.value = !isMenuExpanded.value;
}

enum PopPinScreenTo {
  tabsScreen,
  settingsScreen,
  photoScreen,
}
