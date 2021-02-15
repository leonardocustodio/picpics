import 'dart:async';
import 'dart:convert';
import 'package:cryptography_flutter/cryptography.dart';
import 'package:date_utils/date_utils.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/database/app_database.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/managers/database_manager.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/screens/login_screen.dart';
import 'package:picPics/model/tag.dart';
import 'package:picPics/model/user.dart';
import 'package:picPics/managers/push_notifications_manager.dart';
import 'package:picPics/stores/tags_store.dart';
import 'package:picPics/screens/tabs_screen.dart';
import 'package:picPics/screens/migration/migration_screen.dart';
import 'package:picPics/utils/helpers.dart';
import 'package:picPics/utils/languages.dart';
import 'package:uuid/uuid.dart';
import 'package:picPics/tutorial/tabs_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:picPics/model/user_key.dart';
import 'package:picPics/managers/crypto_manager.dart';

part 'app_store.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  final String appVersion;
  final String deviceLocale;
  final String initiatedWithProduct;
  final LocalAuthentication biometricAuth = LocalAuthentication();
  AppDatabase database = AppDatabase();

  _AppStore({
    this.appVersion,
    this.deviceLocale,
    this.initiatedWithProduct,
  }) {
    var userBox;
    Future.wait([database.getSingleMoorUser(createIfNotExist: false)])
        .then((value) => userBox = value);

    MoorUser user;

    if (userBox.length == 0) {
//      Locale locale = await DeviceLocale.getCurrentLocale();
      user = getDefaultMoorUser(deviceLocale: deviceLocale);
      database.createMoorUser(user);
      Analytics.setUserId(user.id);
      Analytics.sendEvent(Event.created_user);
    } else {
      user = userBox.getAt(0);
      Analytics.setUserId(user.id);
      Analytics.sendEvent(Event.user_returned);
    }

    notifications = user.notification;
    dailyChallenges = user.dailyChallenges;
    hourOfDay = user.hourOfDay;
    minutesOfDay = user.minuteOfDay;
    isPremium = user.isPremium;
    tutorialCompleted = user.tutorialCompleted;
    appLanguage = user.appLanguage;
    hasGalleryPermission = user.hasGalleryPermission;
    canTagToday = user.canTagToday;
    loggedIn = user.loggedIn ?? false;
    tryBuyId = initiatedWithProduct;
    secretPhotos = user.secretPhotos ?? false;
    isPinRegistered = user.isPinRegistered ?? false;
    keepAskingToDelete = user.keepAskingToDelete ?? true;
    shouldDeleteOnPrivate = user.shouldDeleteOnPrivate ?? false;
    email = user.email;
    tourCompleted = user.tourCompleted ?? false;
    isBiometricActivated = user.isBiometricActivated ?? false;
    starredPhotos = user.starredPhotos ?? [];

    // if (secretBox.length > 0) {
    //   Secret secret = secretBox.getAt(0);
    //   isPinRegistered = secret.pin == null ? false : true;
    // }

    loadTags();

    for (String tagKey in user.recentTags) {
      addRecentTags(tagKey);
    }

    var picsBox = Hive.box('pics');
    int picsInBox = picsBox.length;

    if (picsInBox > 0) {
      initialRoute = MigrationScreen.id;
    } else if (tutorialCompleted) {
      initialRoute = TabsScreen.id;
    } else {
      initialRoute = LoginScreen.id;
    }

    if (user.hasGalleryPermission != null || user.tutorialCompleted) {
      requestGalleryPermission();
    }

    // Executa primeira vez para ver se ainda tem permissão
    checkNotificationPermission();

    DatabaseManager.instance.initPlatformState(user.id);
    DatabaseManager.instance.loadRemoteConfig();

    if (user.isPremium) {
      checkPremiumStatus();
    }

    checkAvailableBiometrics();

    autorun((_) {
      print('autorun');
    });
  }

  Future<void> setDefaultWidgetImage(AssetEntity entity) async {
    var bytes = await entity.thumbDataWithSize(300, 300);
    String encoded = base64.encode(bytes);

    var userBox = await database.getSingleMoorUser(createIfNotExist: true);
    MoorUser currentUser = userBox[0];
    await database
        .updateMoorUser(currentUser.copyWith(defaultWidgetImage: encoded));
  }

  List<String> starredPhotos;
  void addToStarredPhotos(String photoId) {
    if (starredPhotos.contains(photoId)) {
      return;
    }

    starredPhotos.add(photoId);
/* 
    var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.starredPhotos = starredPhotos;
    currentUser.save(); */

    database.getSingleMoorUser(createIfNotExist: true).then((userBox) {
      MoorUser currentUser = userBox[0];
      database
          .updateMoorUser(currentUser.copyWith(starredPhotos: starredPhotos));
    });
  }

  void removeFromStarredPhotos(String photoId) async {
    if (!starredPhotos.contains(photoId)) {
      return;
    }

    starredPhotos.remove(photoId);

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.starredPhotos = starredPhotos;
    currentUser.save(); */
    database.getSingleMoorUser(createIfNotExist: true).then((userBox) {
      MoorUser currentUser = userBox[0];
      database
          .updateMoorUser(currentUser.copyWith(starredPhotos: starredPhotos));
    });
  }

  String initialRoute;
  String tryBuyId;
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
    /* var secretBox = Hive.box('secrets');
    return secretBox.length; */
  }

  @action
  void setTryBuyId(String value) => tryBuyId = value;

  @observable
  bool notifications = false;

  @action
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

  @action
  Future<void> checkNotificationPermission(
      {bool firstPermissionCheck = false}) async {
    return NotificationPermissions.getNotificationPermissionStatus()
        .then((status) async {
      /* var userBox = Hive.box('user');
      User currentUser = userBox.getAt(0); */
      var userBox = await database.getSingleMoorUser();
      MoorUser currentUser = userBox[0];

      if (status == PermissionStatus.denied) {
        print('user has no notification permission');
/*         currentUser.notifications = false;
        //        if (firstPermissionCheck) {
        currentUser.dailyChallenges = false;
        //        }
        currentUser.save(); */

        await database.updateMoorUser(currentUser.copyWith(
          notification: false,
        ));
      } else {
        print('user has notification permission');
/*         currentUser.notifications = true;
        if (firstPermissionCheck) {
          currentUser.dailyChallenges = false;
        }
        currentUser.save(); */
        var tempDailyChallenges = currentUser.dailyChallenges;
        if (firstPermissionCheck) {
          tempDailyChallenges = false;
        }
        await database.updateMoorUser(currentUser.copyWith(
          notification: true,
          dailyChallenges: tempDailyChallenges,
        ));
      }

      notifications = currentUser.notification;
      dailyChallenges = currentUser.dailyChallenges;
    });
  }

  @observable
  bool dailyChallenges = false;

  @action
  void switchDailyChallenges(
      {String notificationTitle, String notificationDescription}) {
    dailyChallenges = !dailyChallenges;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.dailyChallenges = dailyChallenges;
    currentUser.save(); */
    database.getSingleMoorUser().then((userBox) {
      MoorUser currentUser = userBox[0];
      database.updateMoorUser(
          currentUser.copyWith(dailyChallenges: dailyChallenges));
    });

    PushNotificationsManager push = PushNotificationsManager();
    if (dailyChallenges) {
      push.deregister();
    } else {
      push.register(
        hourOfDay: hourOfDay,
        minutesOfDay: minutesOfDay,
        title: notificationTitle,
        description: notificationDescription,
      );
    }

    Analytics.sendEvent(Event.notification_switch);
  }

  @observable
  bool isPinRegistered = false;

  @action
  void setIsPinRegistered(bool value) {
    isPinRegistered = value;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.isPinRegistered = value;
    currentUser.save(); */
    database.getSingleMoorUser().then((userBox) {
      MoorUser currentUser = userBox[0];
      database.updateMoorUser(currentUser.copyWith(isPinRegistered: value));
    });
  }

  @observable
  bool keepAskingToDelete;

  @action
  void setKeepAskingToDelete(bool value) {
    keepAskingToDelete = value;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.keepAskingToDelete = value;
    currentUser.save(); */
    database.getSingleMoorUser().then((userBox) {
      MoorUser currentUser = userBox[0];
      database.updateMoorUser(currentUser.copyWith(keepAskingToDelete: value));
    });
  }

  @observable
  bool shouldDeleteOnPrivate = false;

  @action
  void setShouldDeleteOnPrivate(bool value) {
    shouldDeleteOnPrivate = value;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.shouldDeleteOnPrivate = value;
    currentUser.save(); */
    database.getSingleMoorUser().then((userBox) {
      MoorUser currentUser = userBox[0];
      database
          .updateMoorUser(currentUser.copyWith(shouldDeleteOnPrivate: value));
    });
  }

  @observable
  bool secretPhotos = false;

  @action
  void switchSecretPhotos() {
    secretPhotos = !secretPhotos;

    if (secretPhotos == false) {
      print('Cleared encryption key in memory!!!');
      setEncryptionKey(null);
    }

    print('After Switch Secret: $secretPhotos');

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.secretPhotos = secretPhotos;
    currentUser.save(); */
    database.getSingleMoorUser().then((userBox) {
      MoorUser currentUser = userBox[0];
      database.updateMoorUser(currentUser.copyWith(secretPhotos: secretPhotos));
    });
    //    Analytics.sendEvent(Event.notification_switch);
  }

  @observable
  int requireSecret = 0;

  @action
  void setRequireSecret(int value) => requireSecret = value;

  //  int goal;

  @observable
  int hourOfDay = 20;

  @observable
  int minutesOfDay = 00;

  @action
  void changeUserTimeOfDay(int hour, int minute) {
    hourOfDay = hour;
    minutesOfDay = minute;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.hourOfDay = hour;
    currentUser.minutesOfDay = minute;
    currentUser.save(); */

    database.getSingleMoorUser().then((userBox) {
      MoorUser currentUser = userBox[0];
      database.updateMoorUser(currentUser.copyWith(
        hourOfDay: hour,
        minuteOfDay: minute,
      ));
    });

    Analytics.sendEvent(Event.notification_time);

    if (dailyChallenges == true) {
      //      PushNotificationsManager push = PushNotificationsManager();
      //      push.scheduleNotification();
      print('rescheduling notifications....');
    }
  }

  @observable
  bool isPremium = false;

  @action
  void setIsPremium(bool value) {
    isPremium = value;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.isPremium = value;
    currentUser.save(); */
    database.getSingleMoorUser().then((userBox) {
      MoorUser currentUser = userBox[0];
      database.updateMoorUser(currentUser.copyWith(isPremium: value));
    });

    if (isPremium == true) {
      setCanTagToday(true);
    }
  }

  @action
  Future<void> checkPremiumStatus() async {
    bool premium = await DatabaseManager.instance.checkPremiumStatus();
    if (premium == false) {
      setIsPremium(false);
    }
  }

  ObservableList<TagsStore> tags = ObservableList<TagsStore>();

  @action
  void loadTags() {
    var tagsBox = Hive.box('tags');
    tags.clear();

    for (Tag tag in tagsBox.values) {
      TagsStore tagsStore = TagsStore(id: tag.key, name: tag.name);
      addTag(tagsStore);
    }

    Tag secretTag = tagsBox.get(kSecretTagKey);
    if (secretTag == null) {
      print('Creating secret tag in db!');
      Tag createSecretTag = Tag('Secret Pics', []);
      tagsBox.put(kSecretTagKey, createSecretTag);

      TagsStore tagsStore = TagsStore(id: kSecretTagKey, name: 'Secret Pics');
      addTag(tagsStore);
    }

    print('******************* loaded tags **********');
  }

  @action
  void addTag(TagsStore tagsStore) {
    if (tags.contains(tagsStore)) {
      return;
    }
    print('Adding tag to AppStore: $tagsStore');
    tags.add(tagsStore);
  }

  @action
  void editTag({String oldTagKey, String newTagKey, String newName}) {
    TagsStore tagsStore = tags.firstWhere((element) => element.id == oldTagKey);
    tagsStore.setTagInfo(tagId: newTagKey, tagName: newName);
  }

  @action
  void removeTag({TagsStore tagsStore}) {
    tags.remove(tagsStore);
  }

  ObservableList<String> recentTags = ObservableList<String>();

  @action
  void addRecentTags(String tagKey) {
    recentTags.add(tagKey);
  }

  @action
  void editRecentTags(String oldTagKey, String newTagKey) {
    if (recentTags.contains(oldTagKey)) {
      print('updating tag name in recent tags');
      int indexOfTag = recentTags.indexOf(oldTagKey);
      recentTags[indexOfTag] = newTagKey;
      /* var userBox = Hive.box('user');
      User getUser = userBox.getAt(0); */
      database.getSingleMoorUser().then((userBox) {
        MoorUser currentUser = userBox[0];
        int indexOfRecentTag = currentUser.recentTags.indexOf(oldTagKey);
        var tempTags = List<String>.from(currentUser.recentTags);
        tempTags[indexOfRecentTag] = newTagKey;
        database.updateMoorUser(currentUser.copyWith(recentTags: tempTags));
      });
/* 
      getUser.recentTags[indexOfRecentTag] = newTagKey;
      userBox.putAt(0, getUser); */
    }
  }

  @observable
  bool tutorialCompleted;

  @action
  Future<void> setTutorialCompleted(bool value) async {
    tutorialCompleted = value;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.tutorialCompleted = value;
    currentUser.save(); */

    var userBox = await database.getSingleMoorUser();
    MoorUser currentUser = userBox[0];
    database.updateMoorUser(currentUser.copyWith(tutorialCompleted: value));

    await requestGalleryPermission();
    Analytics.sendTutorialComplete();
  }

  int picsTaggedToday;

  DateTime lastTaggedPicDate;

  bool loggedIn;

  @action
  void setLoggedIn(bool value) {
    loggedIn = true;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.loggedIn = true;
    currentUser.save(); */

    database.getSingleMoorUser().then((userBox) {
      MoorUser currentUser = userBox[0];
      database.updateMoorUser(currentUser.copyWith(loggedIn: true));
    });
  }

  @observable
  bool canTagToday;

  @action
  void setCanTagToday(bool value) {
    if (isPremium) {
      canTagToday = true;
    } else {
      canTagToday = value;
    }

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.canTagToday = canTagToday;
    currentUser.save(); */

    database.getSingleMoorUser().then((userBox) {
      MoorUser currentUser = userBox[0];
      database.updateMoorUser(currentUser.copyWith(canTagToday: canTagToday));
    });
  }

  @action
  Future<void> increaseTodayTaggedPics() async {
    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0); */
    var userBox = await database.getSingleMoorUser();
    MoorUser currentUser = userBox[0];

    DateTime lastTaggedPicDate = currentUser.lastTaggedPicDate;
    DateTime dateNow = DateTime.now();
    var picsTaggedToday = currentUser.picsTaggedToday;
    var lastTaggedPicNewDate = dateNow;
    if (lastTaggedPicDate != null &&
        Utils.isSameDay(lastTaggedPicDate, dateNow)) {
      picsTaggedToday += 1;
      print(
          'same day... increasing number of tagged photos today, now it is: ${currentUser.picsTaggedToday}');

      final RemoteConfig remoteConfig = await RemoteConfig.instance;
      dailyPicsForAds = remoteConfig.getInt('daily_pics_for_ads');
      int mod = currentUser.picsTaggedToday % dailyPicsForAds;

      if (mod == 0) {
        print('### CALL ADS!!!');

        await database.updateMoorUser(currentUser.copyWith(
          picsTaggedToday: picsTaggedToday,
          lastTaggedPicDate: lastTaggedPicNewDate,
        ));
        setCanTagToday(false);
        return;
      }
    } else {
      print('(date might be null) or (not same day... resetting counter....)');
      picsTaggedToday = 1;
    }
    await database.updateMoorUser(currentUser.copyWith(
      picsTaggedToday: picsTaggedToday,
      lastTaggedPicDate: lastTaggedPicNewDate,
    ));
    setCanTagToday(true);
  }

  @observable
  String appLanguage = 'pt_BR';

  @computed
  Locale get appLocale {
    return Locale(appLanguage.split('_')[0]);
  }

  @observable
  bool hasGalleryPermission = false;

  @action
  Future<bool> requestGalleryPermission() async {
    var result = await PhotoManager.requestPermission();
    if (result) {
      hasGalleryPermission = true;
    }

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.hasGalleryPermission = hasGalleryPermission;
    currentUser.save(); */
    var userBox = await database.getSingleMoorUser();
    MoorUser currentUser = userBox[0];
    database.updateMoorUser(currentUser.copyWith(
      hasGalleryPermission: hasGalleryPermission,
    ));

    return result;
  }

  @action
  void changeUserLanguage(String language) {
    appLanguage = language;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.appLanguage = language;
    currentUser.save(); */

    database.getSingleMoorUser().then((userBox) {
      MoorUser currentUser = userBox[0];
      database.updateMoorUser(currentUser.copyWith(
        hasGalleryPermission: hasGalleryPermission,
      ));
    });
    Analytics.sendEvent(Event.changed_language);
  }

  @computed
  String get currentLanguage {
    print('App Language: $appLanguage');
    String lang = appLanguage.split('_')[0];
    var local = LanguageLocal();
    return '${local.getDisplayLanguage(lang)['nativeName']}';
  }

  @action
  void createDefaultTags(BuildContext context) {
    var tagsBox = Hive.box('tags');

    if (tagsBox.length > 1) {
      // Criada a secret tag aqui por isso 1
      print('Default tags already created');
      return;
    }

    print('adding default tags...');
    Tag tag1 = Tag(S.of(context).family_tag, []);
    Tag tag2 = Tag(S.of(context).travel_tag, []);
    Tag tag3 = Tag(S.of(context).pets_tag, []);
    Tag tag4 = Tag(S.of(context).work_tag, []);
    Tag tag5 = Tag(S.of(context).selfies_tag, []);
    Tag tag6 = Tag(S.of(context).parties_tag, []);
    Tag tag7 = Tag(S.of(context).sports_tag, []);
    Tag tag8 = Tag(S.of(context).home_tag, []);
    Tag tag9 = Tag(S.of(context).foods_tag, []);
    Tag tag10 = Tag(S.of(context).screenshots_tag, []);

    Map<String, Tag> entries = {
      Helpers.encryptTag(S.of(context).family_tag): tag1,
      Helpers.encryptTag(S.of(context).travel_tag): tag2,
      Helpers.encryptTag(S.of(context).pets_tag): tag3,
      Helpers.encryptTag(S.of(context).work_tag): tag4,
      Helpers.encryptTag(S.of(context).selfies_tag): tag5,
      Helpers.encryptTag(S.of(context).parties_tag): tag6,
      Helpers.encryptTag(S.of(context).sports_tag): tag7,
      Helpers.encryptTag(S.of(context).home_tag): tag8,
      Helpers.encryptTag(S.of(context).foods_tag): tag9,
      Helpers.encryptTag(S.of(context).screenshots_tag): tag10,
    };
    tagsBox.putAll(entries);
    loadTags();
  }

  @action
  void addTagToRecent({String tagKey}) {
    print('adding tag to recent: $tagKey');

    /* var userBox = Hive.box('user');
    User getUser = userBox.getAt(0); */
    database.getSingleMoorUser().then((userBox) async {
      MoorUser getUser = userBox[0];

      if (recentTags.contains(tagKey)) {
        recentTags.remove(tagKey);
        recentTags.insert(0, tagKey);
        getUser.recentTags.remove(tagKey);
        getUser.recentTags.insert(0, tagKey);
        await database.updateMoorUser(getUser);
        print('final tags in recent: ${getUser.recentTags}');
        return;
      }

      if (recentTags.length >= kMaxNumOfRecentTags) {
        print('removing last');
        recentTags.removeLast();
        getUser.recentTags.removeLast();
      }

      recentTags.insert(0, tagKey);
      getUser.recentTags.insert(0, tagKey);
      await database.updateMoorUser(getUser);
      print('final tags in recent: ${getUser.recentTags}');
    });
  }

  @action
  void removeTagFromRecent({String tagKey}) {
    /* var userBox = Hive.box('user');
    User getUser = userBox.getAt(0); */

    if (recentTags.contains(tagKey)) {
      database.getSingleMoorUser().then((userBox) async {
        MoorUser getUser = userBox[0];
        recentTags.remove(tagKey);
        getUser.recentTags.remove(tagKey);
        await database.updateMoorUser(getUser);
        /* userBox.putAt(0, getUser); */
        print('recent tags after removed: ${getUser.recentTags}');
      });
    }
  }

  @observable
  bool waitingAccessCode = false;

  @action
  void setWaitingAccessCode(bool value) => waitingAccessCode = value;

  bool hasObserver = false;

  PopPinScreenTo popPinScreen;

  SecretKey encryptionKey;
  void setEncryptionKey(SecretKey value) => encryptionKey = value;

  String tempEncryptionKey;
  void setTempEncryptionKey(String value) => tempEncryptionKey = value;

  String email;
  void setEmail(String value) {
    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.email = value;
    currentUser.save(); */

    database.getSingleMoorUser().then((userBox) async {
      MoorUser currentUser = userBox[0];
      await database.updateMoorUser(currentUser.copyWith(
        email: value,
      ));
    });

    email = value;
  }

  @observable
  double photoHeightInCardWidget = 500;

  @action
  void setPhotoHeightInCardWidget(double value) =>
      photoHeightInCardWidget = value;

  bool wantsToActivateBiometric = false;

  @observable
  bool isBiometricActivated;

  @action
  Future<void> setIsBiometricActivated(bool value) async {
    if (value == false) {
      await deactivateBiometric();
    }

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.isBiometricActivated = value;
    currentUser.save(); */
    var userBox = await database.getSingleMoorUser();
    MoorUser currentUser = userBox[0];
    await database.updateMoorUser(currentUser.copyWith(
      isBiometricActivated: value,
    ));

    isBiometricActivated = value;
  }

  @observable
  List<BiometricType> availableBiometrics;

  @action
  Future<void> checkAvailableBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await biometricAuth.canCheckBiometrics;
      if (canCheckBiometrics) {
        try {
          availableBiometrics = await biometricAuth.getAvailableBiometrics();
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void saveSecretKey(String value) {
    /* var userBox = Hive.box('userkey');
    UserKey userKey = UserKey(secretKey: value);
    userBox.put(0, userKey); */
    database.getSingleMoorUser().then((userBox) async {
      MoorUser currentUser = userBox[0];
      await database.updateMoorUser(currentUser.copyWith(
        secretKey: value,
      ));
    });
  }

  String getSecretKey() {
    String secret = '';
    Future.value(database.getSingleMoorUser())
        .then((userBox) => secret = userBox[0].secretKey);
    return secret;
  }

  @action
  Future<void> deactivateBiometric() async {
    await Crypto.deleteEncryptedPin();

    /* var userBox = Hive.box('userkey');
    userBox.delete(0); */
    var userBox = await database.getSingleMoorUser();
    var user = userBox[0];
    await database.updateMoorUser(user.copyWith(secretKey: ''));

    print('Deleted encrypted info!');
  }

  @observable
  bool isMenuExpanded = true;

  @action
  void switchIsMenuExpanded() => isMenuExpanded = !isMenuExpanded;
}

MoorUser getDefaultMoorUser({String deviceLocale}) {
  return MoorUser(
    customPrimaryKey: 0,
    id: Uuid().v4(),
    email: null,
    password: null,
    notification: false,
    dailyChallenges: false,
    goal: 20,
    hourOfDay: 20,
    minuteOfDay: 00,
    isPremium: false,
    recentTags: [],
    tutorialCompleted: false,
    picsTaggedToday: 0,
    lastTaggedPicDate: DateTime.now(),
    canTagToday: true,
    appLanguage: deviceLocale ?? '',
    hasGalleryPermission: null,
    loggedIn: false,
    secretPhotos: false,
    isPinRegistered: false,
    keepAskingToDelete: true,
    tourCompleted: false,
    isBiometricActivated: false,
    shouldDeleteOnPrivate: false,
    starredPhotos: [],
    defaultWidgetImage: null,
  );
}

enum PopPinScreenTo {
  TabsScreen,
  SettingsScreen,
  PhotoScreen,
}
