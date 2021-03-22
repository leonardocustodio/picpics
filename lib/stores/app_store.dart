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
import 'package:picPics/managers/push_notifications_manager.dart';
import 'package:picPics/stores/tags_store.dart';
import 'package:picPics/utils/helpers.dart';
import 'package:picPics/utils/languages.dart';
import 'package:uuid/uuid.dart';
import 'package:local_auth/local_auth.dart';
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
  });

  Future initialize() async {
    MoorUser user = await database.getSingleMoorUser(createIfNotExist: false);

    if (user == null) {
//      Locale locale = await DeviceLocale.getCurrentLocale();
      user = getDefaultMoorUser(deviceLocale: deviceLocale);
      await database.createMoorUser(user);
      Analytics.setUserId(user.id);
      Analytics.sendEvent(Event.created_user);
    } else {
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

    /*    if (user.hasGalleryPermission != null || user.tutorialCompleted) {
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

    autorun((_) {
      //print('autorun');
    });
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
/* 
    var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.starredPhotos = starredPhotos;
    currentUser.save(); */

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

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.starredPhotos = starredPhotos;
    currentUser.save(); */
    MoorUser currentUser =
        await database.getSingleMoorUser(createIfNotExist: true);
    await database
        .updateMoorUser(currentUser.copyWith(starredPhotos: starredPhotos));
  }

  //String initialRoute;
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
      MoorUser currentUser = await database.getSingleMoorUser();

      if (status == PermissionStatus.denied) {
        //print('user has no notification permission');
/*         currentUser.notifications = false;
        //        if (firstPermissionCheck) {
        currentUser.dailyChallenges = false;
        //        }
        currentUser.save(); */

        await database.updateMoorUser(currentUser.copyWith(
          notification: false,
        ));
      } else {
        //print('user has notification permission');
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
  Future<void> switchDailyChallenges(
      {String notificationTitle, String notificationDescription}) async {
    dailyChallenges = !dailyChallenges;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.dailyChallenges = dailyChallenges;
    currentUser.save(); */
    MoorUser currentUser = await database.getSingleMoorUser();
    await database
        .updateMoorUser(currentUser.copyWith(dailyChallenges: dailyChallenges));

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
  Future<void> setIsPinRegistered(bool value) async {
    isPinRegistered = value;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.isPinRegistered = value;
    currentUser.save(); */

    MoorUser currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(currentUser.copyWith(isPinRegistered: value));
  }

  @observable
  bool keepAskingToDelete;

  @action
  Future<void> setKeepAskingToDelete(bool value) async {
    keepAskingToDelete = value;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.keepAskingToDelete = value;
    currentUser.save(); */
    MoorUser currentUser = await database.getSingleMoorUser();
    await database
        .updateMoorUser(currentUser.copyWith(keepAskingToDelete: value));
  }

  @observable
  bool shouldDeleteOnPrivate = false;

  @action
  Future<void> setShouldDeleteOnPrivate(bool value) async {
    shouldDeleteOnPrivate = value;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.shouldDeleteOnPrivate = value;
    currentUser.save(); */
    MoorUser currentUser = await database.getSingleMoorUser();
    await database
        .updateMoorUser(currentUser.copyWith(shouldDeleteOnPrivate: value));
  }

  @observable
  bool secretPhotos = false;

  @action
  Future<void> switchSecretPhotos() async {
    secretPhotos = !secretPhotos;

    if (secretPhotos == false) {
      //print('Cleared encryption key in memory!!!');
      setEncryptionKey(null);
    }

    //print('After Switch Secret: $secretPhotos');

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.secretPhotos = secretPhotos;
    currentUser.save(); */
    MoorUser currentUser = await database.getSingleMoorUser();
    await database
        .updateMoorUser(currentUser.copyWith(secretPhotos: secretPhotos));

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
  Future<void> changeUserTimeOfDay(int hour, int minute) async {
    hourOfDay = hour;
    minutesOfDay = minute;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.hourOfDay = hour;
    currentUser.minutesOfDay = minute;
    currentUser.save(); */

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

  @observable
  bool isPremium = false;

  @action
  Future<void> setIsPremium(bool value) async {
    isPremium = value;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.isPremium = value;
    currentUser.save(); */
    MoorUser currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(currentUser.copyWith(isPremium: value));

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

  @observable
  Map<String, TagsStore> tags = <String, TagsStore>{};

  @observable
  List<TagsStore> mostUsedTags = <TagsStore>[];

  @action
  void loadMostUsedTags({int maxTagsLength = 12}) {
    mostUsedTags.clear();
    var tempTags = List<TagsStore>.from(tags.values);
    tempTags.sort((a, b) {
      var count = b.count.compareTo(a.count);
      if (count == 0)
        return b.name.toLowerCase().compareTo(a.name.toLowerCase());

      return count;
    });
    mostUsedTags = List<TagsStore>.from(tempTags);
    if (mostUsedTags.length > maxTagsLength)
      mostUsedTags = mostUsedTags.sublist(0, maxTagsLength);
  }

  @observable
  List<TagsStore> lastWeekUsedTags = <TagsStore>[];

  @action
  void loadLastWeekUsedTags({int maxTagsLength = 12}) {
    lastWeekUsedTags.clear();
    var now = DateTime.now();
    var sevenDaysBack =
        DateTime(now.year, now.month, (now.day - now.weekday - 1));
    doSortingOfWeeksAndMonth(lastMonthUsedTags, sevenDaysBack, maxTagsLength);
  }

  @observable
  List<TagsStore> lastMonthUsedTags = <TagsStore>[];

  @action
  void loadLastMonthUsedTags({int maxTagsLength = 12}) {
    lastMonthUsedTags.clear();
    var now = DateTime.now();
    var monthBack = DateTime(now.year, now.month, 1);
    doSortingOfWeeksAndMonth(lastMonthUsedTags, monthBack, maxTagsLength);
  }

  void doSortingOfWeeksAndMonth(
      List<TagsStore> list, DateTime back, int maxTagsLength) {
    tags.values.forEach((element) {
      if (element.time.isBefore(back)) {
        list.add(element);
      }
    });
    if (list.isNotEmpty) {
      list.sort((TagsStore a, TagsStore b) => b.time.day.compareTo(a.time.day));
      if (list.length > maxTagsLength) list = list.sublist(0, maxTagsLength);
    }
  }

  @action
  Future<void> loadTags() async {
    var tagsBox = await database.getAllLabel();
    tags.clear();

    for (Label tag in tagsBox) {
      TagsStore tagsStore = TagsStore(
        id: tag.key,
        name: tag.title,
        count: tag.counter,
        time: tag.lastUsedAt,
      );
      addTag(tagsStore);
    }

    /* Label secretTag = tagsBox.firstWhere(
      (Label element) => element.key == kSecretTagKey,
      orElse: () => null,
    ); */
    if (tags[kSecretTagKey] == null) {
      //print('Creating secret tag in db!');
      Label createSecretLabel = Label(
        key: kSecretTagKey,
        title: 'Secret Pics',
        photoId: [],
        counter: 1,
        lastUsedAt: DateTime.now(),
      );
      await database.createLabel(createSecretLabel);
      //tagsBox.put(kSecretTagKey, createSecretTag);

      TagsStore tagsStore = TagsStore(
        id: kSecretTagKey,
        name: 'Secret Pics',
        count: 1,
        time: DateTime.now(),
      );
      addTag(tagsStore);
    }
    loadMostUsedTags();
    loadLastWeekUsedTags();
    loadLastMonthUsedTags();

    //print('******************* loaded tags **********');
  }

  @action
  void addTag(TagsStore tagsStore) {
    if (tags[tagsStore.id] != null) {
      return;
    }
    //print('Adding tag to AppStore: $tagsStore');
    tags[tagsStore.id] = tagsStore;
  }

  @action
  void editTag({String oldTagKey, String newTagKey, String newName}) {
    TagsStore tagsStore =
        tags[oldTagKey]; //.firstWhere((element) => element.id == oldTagKey);
    tagsStore.setTagInfo(
        tagId: newTagKey,
        tagName: newName,
        count: tagsStore.count,
        time: DateTime.now());
    tags[newTagKey] = tagsStore;
    tags.remove(oldTagKey);
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
  Future<void> editRecentTags(String oldTagKey, String newTagKey) async {
    if (recentTags.contains(oldTagKey)) {
      //print('updating tag name in recent tags');
      int indexOfTag = recentTags.indexOf(oldTagKey);
      recentTags[indexOfTag] = newTagKey;
      /* var userBox = Hive.box('user');
      User getUser = userBox.getAt(0); */
      MoorUser currentUser = await database.getSingleMoorUser();
      int indexOfRecentTag = currentUser.recentTags.indexOf(oldTagKey);
      var tempTags = List<String>.from(currentUser.recentTags);
      tempTags[indexOfRecentTag] = newTagKey;
      await database.updateMoorUser(currentUser.copyWith(recentTags: tempTags));

/* 
      getUser.recentTags[indexOfRecentTag] = newTagKey;
      userBox.putAt(0, getUser); */
    }
  }

  @observable
  bool tutorialCompleted = false;

  @action
  Future<void> setTutorialCompleted(bool value) async {
    tutorialCompleted = value;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.tutorialCompleted = value;
    currentUser.save(); */

    MoorUser currentUser = await database.getSingleMoorUser();
    await database
        .updateMoorUser(currentUser.copyWith(tutorialCompleted: value));
    //await requestGalleryPermission();
    Analytics.sendTutorialComplete();
  }

  int picsTaggedToday;

  DateTime lastTaggedPicDate;

  bool loggedIn;

  @action
  Future<void> setLoggedIn(bool value) async {
    loggedIn = true;

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.loggedIn = true;
    currentUser.save(); */

    MoorUser currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(currentUser.copyWith(loggedIn: true));
  }

  @observable
  bool canTagToday;

  @action
  Future<void> setCanTagToday(bool value) async {
    if (isPremium) {
      canTagToday = true;
    } else {
      canTagToday = value;
    }

    /* var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.canTagToday = canTagToday;
    currentUser.save(); */

    MoorUser currentUser = await database.getSingleMoorUser();
    await database
        .updateMoorUser(currentUser.copyWith(canTagToday: canTagToday));
  }

  @action
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

  @observable
  String appLanguage = 'en';

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
    MoorUser currentUser = await database.getSingleMoorUser();
    await database.updateMoorUser(currentUser.copyWith(
      hasGalleryPermission: hasGalleryPermission,
    ));

    return result;
  }

  @action
  Future<void> changeUserLanguage(String language) async {
    appLanguage = language;

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

  @computed
  String get currentLanguage {
    //print('App Language: $appLanguage');
    String lang = appLanguage.split('_')[0];
    var local = LanguageLocal();
    return '${local.getDisplayLanguage(lang)['nativeName']}';
  }

  @action
  Future<void> createDefaultTags(BuildContext context) async {
    var tagsBox = await database.getAllLabel();

    if (tagsBox.length > 1) {
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
    Future.forEach(entries, (newLabel) => database.createLabel(newLabel))
        .then((_) => loadTags());
  }

  @action
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

    if (recentTags.length >= kMaxNumOfRecentTags) {
      //print('removing last');
      recentTags.removeLast();
      getUser.recentTags.removeLast();
    }

    recentTags.insert(0, tagKey);
    getUser.recentTags.insert(0, tagKey);
    await database.updateMoorUser(getUser);
    //print('final tags in recent: ${getUser.recentTags}');
  }

  @action
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
    MoorUser currentUser = await database.getSingleMoorUser();
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

  @action
  Future<void> deactivateBiometric() async {
    await Crypto.deleteEncryptedPin();

    /* var userBox = Hive.box('userkey');
    userBox.delete(0); */
    MoorUser user = await database.getSingleMoorUser();
    await database.updateMoorUser(user.copyWith(secretKey: ''));

    //print('Deleted encrypted info!');
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
