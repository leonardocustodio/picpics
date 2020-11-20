import 'dart:io';
import 'package:cryptography_flutter/cryptography.dart';
import 'package:date_utils/date_utils.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/managers/database_manager.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/screens/login_screen.dart';
import 'package:picPics/model/tag.dart';
import 'package:picPics/model/user.dart';
import 'package:picPics/managers/push_notifications_manager.dart';
import 'package:picPics/stores/tags_store.dart';
import 'package:picPics/screens/tabs_screen.dart';
import 'package:picPics/utils/helpers.dart';
import 'package:picPics/utils/languages.dart';
import 'package:uuid/uuid.dart';
import 'package:picPics/tutorial/tabs_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:picPics/model/user_key.dart';
import 'package:picPics/managers/crypto_manager.dart';
import 'package:home_widget/home_widget.dart';

part 'app_store.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  final String appVersion;
  final String deviceLocale;
  final String initiatedWithProduct;
  final LocalAuthentication biometricAuth = LocalAuthentication();

  _AppStore({
    this.appVersion,
    this.deviceLocale,
    this.initiatedWithProduct,
  }) {
    var userBox = Hive.box('user');
    User user;

    if (userBox.length == 0) {
//      Locale locale = await DeviceLocale.getCurrentLocale();
      User createUser = User(
        id: Uuid().v4(),
        email: null,
        password: null,
        notifications: false,
        dailyChallenges: false,
        goal: 20,
        hourOfDay: 20,
        minutesOfDay: 00,
        isPremium: false,
        recentTags: [],
        tutorialCompleted: false,
        picsTaggedToday: 0,
        lastTaggedPicDate: DateTime.now(),
        canTagToday: true,
        appLanguage: deviceLocale,
        hasGalleryPermission: null,
        loggedIn: false,
        secretPhotos: false,
        isPinRegistered: false,
        keepAskingToDelete: true,
        tourCompleted: false,
        isBiometricActivated: false,
      );

      user = createUser;
      userBox.put(0, createUser);

      Analytics.setUserId(user.id);
      Analytics.sendEvent(Event.created_user);
    } else {
      user = userBox.getAt(0);
      Analytics.setUserId(user.id);
      Analytics.sendEvent(Event.user_returned);
    }

    notifications = user.notifications;
    dailyChallenges = user.dailyChallenges;
    hourOfDay = user.hourOfDay;
    minutesOfDay = user.minutesOfDay;
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

    // if (secretBox.length > 0) {
    //   Secret secret = secretBox.getAt(0);
    //   isPinRegistered = secret.pin == null ? false : true;
    // }

    loadTags();

    for (String tagKey in user.recentTags) {
      addRecentTags(tagKey);
    }

    if (loggedIn) {
      initialRoute = TabsScreen.id;
      // if (tourCompleted != null) {
      //   initialRoute = TutsTabsScreen.id;
      // } else {
      //
      // }
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
    var secretBox = Hive.box('secrets');
    return secretBox.length;
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
        .then((status) {
      var userBox = Hive.box('user');
      User currentUser = userBox.getAt(0);

      if (status == PermissionStatus.denied) {
        print('user has no notification permission');
        currentUser.notifications = false;
//        if (firstPermissionCheck) {
        currentUser.dailyChallenges = false;
//        }
        currentUser.save();
      } else {
        print('user has notification permission');
        currentUser.notifications = true;
        if (firstPermissionCheck) {
          currentUser.dailyChallenges = false;
        }
        currentUser.save();
      }

      notifications = currentUser.notifications;
      dailyChallenges = currentUser.dailyChallenges;
    });
  }

  @observable
  bool dailyChallenges = false;

  @action
  void switchDailyChallenges(
      {String notificationTitle, String notificationDescription}) {
    dailyChallenges = !dailyChallenges;

    var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.dailyChallenges = dailyChallenges;
    currentUser.save();

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

    var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.isPinRegistered = value;
    currentUser.save();
  }

  @observable
  bool keepAskingToDelete;

  @action
  void setKeepAskingToDelete(bool value) {
    keepAskingToDelete = value;

    var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.keepAskingToDelete = value;
    currentUser.save();
  }

  @observable
  bool shouldDeleteOnPrivate = false;

  @action
  void setShouldDeleteOnPrivate(bool value) {
    shouldDeleteOnPrivate = value;

    var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.shouldDeleteOnPrivate = value;
    currentUser.save();
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

    var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.secretPhotos = secretPhotos;
    currentUser.save();

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

    var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.hourOfDay = hour;
    currentUser.minutesOfDay = minute;
    currentUser.save();

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

    var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.isPremium = value;
    currentUser.save();

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
    var userBox = Hive.box('user');
    User getUser = userBox.getAt(0);

    if (recentTags.contains(oldTagKey)) {
      print('updating tag name in recent tags');
      int indexOfTag = recentTags.indexOf(oldTagKey);
      recentTags[indexOfTag] = newTagKey;

      int indexOfRecentTag = getUser.recentTags.indexOf(oldTagKey);
      getUser.recentTags[indexOfRecentTag] = newTagKey;
      userBox.putAt(0, getUser);
    }
  }

  @observable
  bool tutorialCompleted;

  @action
  Future<void> setTutorialCompleted(bool value) async {
    tutorialCompleted = value;

    var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.tutorialCompleted = value;
    currentUser.save();

    await requestGalleryPermission();
    Analytics.sendTutorialComplete();
  }

  int picsTaggedToday;

  DateTime lastTaggedPicDate;

  bool loggedIn;

  @action
  void setLoggedIn(bool value) {
    loggedIn = true;

    var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.loggedIn = true;
    currentUser.save();
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

    var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.canTagToday = canTagToday;
    currentUser.save();
  }

  @action
  Future<void> increaseTodayTaggedPics() async {
    var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);

    DateTime lastTaggedPicDate = currentUser.lastTaggedPicDate;
    DateTime dateNow = DateTime.now();

    if (lastTaggedPicDate == null) {
      print('date is null....');
      currentUser.picsTaggedToday = 1;
      currentUser.lastTaggedPicDate = dateNow;
    } else if (Utils.isSameDay(lastTaggedPicDate, dateNow)) {
      currentUser.picsTaggedToday += 1;
      currentUser.lastTaggedPicDate = dateNow;
      print(
          'same day... increasing number of tagged photos today, now it is: ${currentUser.picsTaggedToday}');

      final RemoteConfig remoteConfig = await RemoteConfig.instance;
      dailyPicsForAds = remoteConfig.getInt('daily_pics_for_ads');
      int mod = currentUser.picsTaggedToday % dailyPicsForAds;

      if (mod == 0) {
        print('### CALL ADS!!!');
        currentUser.save();
        setCanTagToday(false);
        return;
      }
    } else {
      print('not same day... resetting counter....');
      currentUser.picsTaggedToday = 1;
      currentUser.lastTaggedPicDate = dateNow;
    }
    currentUser.save();
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
  Future<void> requestGalleryPermission() async {
    var result = await PhotoManager.requestPermission();
    if (result) {
      hasGalleryPermission = true;
    }

    var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.hasGalleryPermission = hasGalleryPermission;
    currentUser.save();
  }

  @action
  void changeUserLanguage(String language) {
    appLanguage = language;

    var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.appLanguage = language;
    currentUser.save();

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

    var userBox = Hive.box('user');
    User getUser = userBox.getAt(0);

    if (recentTags.contains(tagKey)) {
      recentTags.remove(tagKey);
      recentTags.insert(0, tagKey);
      getUser.recentTags.remove(tagKey);
      getUser.recentTags.insert(0, tagKey);
      userBox.putAt(0, getUser);
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
    userBox.putAt(0, getUser);
    print('final tags in recent: ${getUser.recentTags}');
  }

  @action
  void removeTagFromRecent({String tagKey}) {
    var userBox = Hive.box('user');
    User getUser = userBox.getAt(0);

    if (recentTags.contains(tagKey)) {
      recentTags.remove(tagKey);
      getUser.recentTags.remove(tagKey);
      userBox.putAt(0, getUser);
      print('recent tags after removed: ${getUser.recentTags}');
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
    var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.email = value;
    currentUser.save();

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

    var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.isBiometricActivated = value;
    currentUser.save();

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
    var userBox = Hive.box('userkey');
    UserKey userKey = UserKey(secretKey: value);
    userBox.put(0, userKey);
  }

  String getSecretKey() {
    var userBox = Hive.box('userkey');
    UserKey userKey = userBox.get(0);
    return userKey.secretKey;
  }

  @action
  Future<void> deactivateBiometric() async {
    await Crypto.deleteEncryptedPin();

    var userBox = Hive.box('userkey');
    userBox.delete(0);

    print('Deleted encrypted info!');
  }

  Future<void> _sendData() async {
    try {
      print('Future send data');
      return Future.wait([
        HomeWidget.saveWidgetData<String>('imageEncoded',
            '/9j/4AAQSkZJRgABAgAAAQABAAD/7QCcUGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAIAcAmcAFDdTaURsWERwRDBoTnBLdGRUV3VqHAIoAGJGQk1EMDEwMDBhYmUwMzAwMDAyYTE4MDAwMDc4MmQwMDAwYTAyZjAwMDBmNDMxMDAwMGIyM2MwMDAwMTM2YjAwMDBmODZmMDAwMDQ1NzQwMDAwYmI3ODAwMDBjNWRiMDAwMP/iAhxJQ0NfUFJPRklMRQABAQAAAgxsY21zAhAAAG1udHJSR0IgWFlaIAfcAAEAGQADACkAOWFjc3BBUFBMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD21gABAAAAANMtbGNtcwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACmRlc2MAAAD8AAAAXmNwcnQAAAFcAAAAC3d0cHQAAAFoAAAAFGJrcHQAAAF8AAAAFHJYWVoAAAGQAAAAFGdYWVoAAAGkAAAAFGJYWVoAAAG4AAAAFHJUUkMAAAHMAAAAQGdUUkMAAAHMAAAAQGJUUkMAAAHMAAAAQGRlc2MAAAAAAAAAA2MyAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHRleHQAAAAARkIAAFhZWiAAAAAAAAD21gABAAAAANMtWFlaIAAAAAAAAAMWAAADMwAAAqRYWVogAAAAAAAAb6IAADj1AAADkFhZWiAAAAAAAABimQAAt4UAABjaWFlaIAAAAAAAACSgAAAPhAAAts9jdXJ2AAAAAAAAABoAAADLAckDYwWSCGsL9hA/FVEbNCHxKZAyGDuSRgVRd13ta3B6BYmxmnysab9908PpMP///9sAQwAJBgcIBwYJCAgICgoJCw4XDw4NDQ4cFBURFyIeIyMhHiAgJSo1LSUnMiggIC4/LzI3OTw8PCQtQkZBOkY1Ozw5/9sAQwEKCgoODA4bDw8bOSYgJjk5OTk5OTk5OTk5OTk5OTk5OTk5OTk5OTk5OTk5OTk5OTk5OTk5OTk5OTk5OTk5OTk5/8IAEQgCgAKAAwAiAAERAQIRAf/EABsAAAIDAQEBAAAAAAAAAAAAAAECAAMEBQYH/8QAGAEBAQEBAQAAAAAAAAAAAAAAAAECAwT/xAAYAQEBAQEBAAAAAAAAAAAAAAAAAQIDBP/aAAwDAAABEQIRAAAB73nvR+cyMk3l9OXTLs5nUyZvA9JxPQZ3tIZLbarZYrKQDLZrHEx6no6vLYbOvg5N2p068jXHoU4TzPptHncc69vy+jLRkOkgiMVYjAgV1KAQyJJU15dkoSytWkJAYCGABBDIEEWdWM2M4OtizKKu1ydaqcSOj6XyPaxvqDmjN6M5y0vP04dY34N/O1n2PnPTeb5bkjdMm+m6XdRoz41tNd+NFleyy2m1Rny+T1n0/F89T0zszI9HRmNSIhYEYvrKgatS+3JaXCuEFjUWqkXNXYkVgZw62AGIdmPdKldqBMiyQghAsMAQ1QGJ3Saueufr6PBubtddLNKdTO6X+h5eznq9suOXqP43unR8b6fzO89LBVn3j6F5n03nOe2BmpLqrjo5NeTGugxONK9Vly9b5dXzuTscTeeShXcZlcqDoSRhYwA0IkZBwAM9Lllma4dVI19Nw4MSgEWKZEO3FulFbqphgIYCGCxgCEgDLZ6TTmu5bzcH0+GytTHLNvpyzp7U/Pqc7+heS5Vq92jB0OXVOZo5/Xnns2ZtZ+kec9H57MUxtwW12x0M2vJnXQalc0t5HmdM+l81lG46g0CYLFBZEYksUUqQkqVkGmDGKxZWFlg7VlbwrpbCSqMrKwyyb8O6VIYskIJCohKIGChpEKWLZo3cc516heXvzckS2RWdYzJl6uOmQ2YM76a8q6NtPO6VZV7KHqPPei8/04gxtQWV2nRwa/Ir2fOZU1FAGjKYEo0QgU6mC3UEurECGUZTCONE1neyorGykoltdgMg9lVxoNckWMtyIRZOhg3y1lgsBhJDKsJRQwWGGyK62VxpNaduWzKbeX1s08/p8dcuxKDs2cT0Pk9DMlnLefg+j8d259mnLk7c/pnn+/wtYQw6yEr89XR4IGhVkoxXCGMVm6ioIAvXYCFSQxQwIwLROni7OOuTP2LM741Pd5bOSdO486vY528V31vrBZFS0BrhI0qb8O+VAwWQxZJIgMAGgCGIGWwBxLsmfbHN6+TRm6OZt87L13mysnUz6fJ6LHVuPRPI+vzdMeQGiz2ef6DxO5xZKZE1nlcnpcvSkMNChCywPEqdBq2lIZAujwa7VFcOqu7ypobp46ZeyNXLpSNC51UbQtNWhUz4Orn1nzyd/h9uFaMd8RbRZTQxB0ed0VUOqwMJSCRYQQGAYMRHFmjPoplr6uAxtrOOKK9ujOtTrpCKc/Dt1Dz3561jLSa8mMdefs+N2eR055c2zNvPK5Vi7UqSIQbWkEWVBqIZ5ahciKxuKrJfNUatWnn1z2a78bo2TTmre+1nBT1ucuYOJtA6oiWoUc7p19MeWl2fv5LIrWWFLEHR5+9SrCaEMBJAQxYGWSMDTV2ppp523DmWdHnb83fwbKF19bl9zFq1poE6HO6M05BiAgo4XoOdc9Pk9blLmy7ON0zwUavUcSVGVoWMolim0W12QpJATYo6FduN9K+q7j3tdbM0XVsa3yPrOrKiChhnQDAWuxSmq+vc5vF9Jx+3l5912bfM3VFLehi2ylbK2iDAQmVYSih0CQ1FHWzqcP0nms3QKu5z3xM961v9F5n0iW3Hly5O/wAvtwxBlEIK+d0cNz0OV1eYufl9XHvPjgy9I4ICwErowQR61LpYSQytYthb0sWnHTdYj8e1ltDy3lGHKtZI7JSLq5a4yyhXWymu1NM+DpcTrwsqxdbfDn16ksXoYd6tXbXNENBYYCGKEcJDCFWGnf43cXlrnN0eNw605Hnflf67kQ1Z6PSZqMrSsQSAgrpuy2beX0+aZ82inefFo6bFoLJBcqgPEDEqLANtVkr35da26sWvG99lVvLszRs12WwlitZbA1yiMsqhxKqsClblso53Vybx5e9be/mdd2vOeRt7vLWlLEuhCFhEJJAKwGEIVYanpqr246p4nsPLzXOTXu3iyrpc3j20dfitrN/Tx7LGIMQSCZdNVl/O6XOMtN67nhVdd5kVqjgwDGoNJK9ZilxZAlgV9fP2430dOXXx7F1eVra7EsavJrO5eZTrPWr4mavTjzGzN7sxas6ANNg5tfK6YsbNr6cPU6fO68Y6/K6vPa59d9G7IwUQgEMArRYQyFWWz1F1Onlu/i9rinJ7PH6dnQ856bg8uhqsv3js2I8rEEgIEya8tmvn9HAZDF3PE068m4sjWMCkWRYtwWDmt1l9FkGNVNatM6HLtbfG56WNWWVZsOs687dDU47ekU8+vfoXiToVDdHBuzTj18azHcnU1K8/QsvLj99tt4iu15rztOijaAhqSQkMArqkaSirqem159XLVnG7PGXj9TH1rOjz+hkzc2jU5U0ISCQEC5dWazTh3YTIytueMydnj6iwiwo0WEqS2q4SRlhMjWp63PrfrSzj1jAk52/HZg16TZbZlrXQLcthy5ufXSuy9XOn3JqjL5b2PJqqzPVrKbvP+g15+rZn0OYsR2uTzexyNWQyhDAQwVXBDJRVwnqdWbTy2eT1eWsvtJaGEPDCswhkhAYJRfRZowb8UYzJucbzXufE7lZkqAgaSKWAIQwzpbGrtcTr8e2x0t59AZCAqlNGjPbRXtFc3oX2aicfsZFnZ5fX50OCjUXyzlU6+VrTdHn9vfkZ1ZzltVjTea9X5trLJNwQgkaKqsEMkGVhXefK3PT6ON6OUh4SEQ5BKyCGSEhAlN1VW5NmOMck1meU9ZydTyxk2XqZ+rz7Lg3X56efnX5++WckawbKmNfRxdPj23XVW8ujQFI0ekWyFCaUMtGwXXLt6l8R2LKRxQZGQcbs0ryurnu3wtZX1wFldrV/nfReebxQzcBgIZEAIIwNpV1T0PK7/m+evUN5r0krQwAIhpCJJAkEgMK6rqqtx68kY4G1mI7V4JO3wtzfXrPP05G7vQxvzOjTTZz06RuOQ91esbujztnPpusofG7mpeS4o1OVI712UFuUqJWV6xls0PVbDGSithswhqk2Mj78ktqttu4Hf4LeGCbkIgYpIpiGGDKwr1XO6A5b896fHuhoRQEQtIMJJAkQkkBVZVVuTVmjAVO8syvFPhPpHmNMPovG+w5+nOzXc+nmrPSczWV2JZJysmzN15Pv5uzOtzo3PpZZW0XNW1lhrJZZQ5eKhTouOWR9NZb8PL1PQp5RdZ9e/lOnl0kwXy9O/Po35JZXZV/B73Db5xE3IVYkkSKVVirIZJXqLK7OWuR21sWSQrquQuIMJISSEEIFSysbNqzHOgO8l0sNNF8l+catnF3fYbvI9nj6exRn2YvK01WWcihquvFteW86lmazl1uspeLHreCVg0qZbZVVY1OfqGikYt4HPTHvOmZl1JRbTc3dfi9PN9FqqtzxllVtt/C7nDb50k3IRAkSCjKMVNMJLPUXZX570WV2RIQLn0UGqAwhkIQSSAFdlY2bRQcxkbeWetzUQc3L4H6V56vK9/z+rWvS7serh6Tg34k4ND0d/PfbQ0btHNvzvo386/HTc9UyuWLEgFpyX4tTZRzl3z205muRS9Gljrsmjz+vzoz9HmbdcvW25tWeQsqtW/i9riunMkm5IJBIhAVGIIyMup37Mk577NldkQiQtF9FmkgypJAyEgIUV2VoabqU5TI+8llK62RpWh25vzXn/SPnPXPT7fkdeO3qODmSKhJ15O9Yi6/NZNbL80x06luK7G9a1SRzW8uPlbuV25FlmpofRv575dneujk6+hacrzXsvM6nH24t/Tn6vTj2Y4yyuxb+N2OQ6coFdwmCDJCAqNARlZdTuVbbeetFiPKQQLn0UJpIMqSQJBICAI6EpupTkMrby8DW6nrszW24tmbl8B9B5Op4XRU+5bJdN4YU1hmrYeyqNa78ujGr9nPtxvStCGvTz9Gbk53V528b+i2zHSkaYY8nZl1wZ2aZrFqei3zWqDr4/QdTndLPIWV2Rfx+vyL05Qk3IQSQEilRirQykaeksqv560sjwRILRdSmlgZa4QEgkBAFZRa7Kk5BWbzYytbqsqtzTtw783OyseJ430f570jaM+mawV6c+8iSWNFkW252XccdmdaKlRdkzHLrczXVNd3Rxujz3fAqms4q0pyW1Olmz03Jszad8PR6c+jPOOjtXcjr8lvkQjUhWVDIRSAkGDINPR6M+jndDK+bJILRdQmogqkkCQSAgCsotdlZxQydM2W0k3W0aM0b+fvzaGVg+S9byNPG30X3VeTdTZlDpvAkAxWDvWYtNcV7c9suk0Pm39fidbHTqK9mNY+T6DiVypdR15RqjrNj1WzPq9OHdnnHrsW7k9blN8gQaSQkBlAEBIMESaei05tPO6HrszZJBKL6E1EFUkgYCQwAV0FrdI4yPX1xYVddenJpzRv5/QzaGVg4Ohn1Pn91Vt2a9CZuGnfm6YzR11kGQjKQxSMUhaa3jT0uPsxvu6+A2N9zDkQry3V7zQXTWYy2M+j6XH7Gecsqtlu5XV5bpxoJuSSRJJUBEGA0ZBXotWTXzt9ldmbJIJRfSmkgqkgCQSSQCsolbpHHpur64Z67DXpzas6q6HN6WbVKfGanpfGYZ0nQtqsx10CW43my9TNrHNW1OnJFcUIQgDCmAYjIIsuzMup8jxpGcLqWhTWigNlLp6ro83pY5i2q2W7m9Lmzpw4RuSA1ICRWEGA0RBZ6Dbg389XulmbIQJTdQaiCIDCEEkkApUrUzM41dlfbMsrY2bMWrNryec4+2nHbXvKkPL0Hjcu1t1N2NsLVjlU9fn9eeRbBvCB1QCSgZLJFMQrCxqyOsCsVg7VsFkvqdzjoz7mzxvquTfzejgm+DJNQQipJAQiCVaoJLOz1ON1Od12V2TRhEJRfnNkBEEgSIEGCq6FJEjj121dMBko01+Yy1ahkmhQiVdtPS59IWnPqbaLovtoulbLtROJX0aemMCaqt4oFguUDClhIsaUJJIzK6ozgEJKdG7DVzVWCkqeo1eL25aYpgyQMhgKy0ZCAEWau35rfl6W2m3G2BEJnvoNZBKwYEiBEhEZCmSScnPp5vXM8ya+khBoidOWnsasHHtQ1459aluSq7Ee5utpszdFlVsIumHP5PoMG88uvoZ+mMkvms5zaCuaBGZrILZCqV3UWOyWp6+yjt5vz+n2njdQlH1EV5U3c+R6q7zPY53emGRporroV9HUcVenzNSa8WmT1t1N3PZBEV59GY2MrFYIgkGpJCVuhQvM4+s9fxT5+2YQaInVlT0lufj2yteOPoor0VpQlyXNRM1HsreLr818tzI8THtqs5+bpU6mBtlGphXUms1JZVYCIhIiyi+jWZvydC563ouD3MWc/omXwVfr+VrPFhGyCxBSDZZK5BqvRVAJp1cwp15yNse70cfrcdEpJRm0ZzYQRAVhjJUkgEdD5OQPRzMhIRYbfXLfnVNdw4eihdNXLvnS+uzOt9dxQLF1kkMG7NYbLKLs1o0Kq76bEqfPZRnso3K63XeFMKSRCK1+8R0m89r0PmPU8t2gHNnN6Spy+J3bbx8afWec1vFGXWgIRHAHWFKpZXbCtkg6fOkvrt/g78X31Xkd2XrZXZmoCIYgkklBHQ+TST0cyRKPofP8At863owiqyuzG0S6vzeqmq5FpW5dZzV313KlmKDZXZfox6pb2reBXZWU1aBZnydmV56n03K1nmK69edbWNvEBXUNrdLN1dyrRz0rSRGVijJ0zMcnU2Vzx+e9bbq+GHpeJrWSGa0AYArLElplrYQMENfd8t6HD1712crUCJSQxJJSq9Z8nkno5mSHR9lxOzna6KlZtDlZWTjeZdlPLtQl9eN56tCUjFkrrvRKb6rK0vVdAR1Ec22LZbbZlOxt8+VxfWTefFD2TanlOp2zll1tIhBUgQJBCyCNNVpzOfm7FTHPmirXPlee9g1eGHs8O9+aHW59tTI1qFgCEE73B7OHtbK35brBWGKsGAgrdK+TyT0c5fV3pfQMjSvFgtyE0jPYWqTKIZLRVsGdYhuEuKrpE47dVTDfeyU2tbYpJsVoaBJAUAyO0CSBIkQEVDAPFYgMGvy6cDJJRXbEyUdFLjlp0KLzzuFuZk0qnMzd9q88npEa83s6/MdPWPXZjpWrLDMIESArsrr5RIfRy1+p5+zHPcwW9iUYjhlkMEtjLa2ZI2HNYWEGFENAPCkaEGatIubIxpFLkFjCtGlEBJBASQYiBBgCYGKQW1rGyA4skkQEAVoUV6qrKK9IucY2FOfXvypVj61s3bq5fRaCkI8BJCCI618l7HK9R282PvcH1uJSltO/QWrI5VQsGCVkrgELRhIZAWwCh7ChNRMdukFdgKgghKmGkWmitAggYINASSQjABBIquC+3Dt50wGICAAgiklS2IKjKKUlA1WRRu59NdsUXI7I5IZQR0PnuvRzunh63psXR5ermU6au2q2ZaIDoYrqGBlAsiC1CGQKwIglSEgkIgxBVDIExRwrEkASIMsIVMiSEkkCJCSATVQMtsExSVIAQKQAq0K0tQrVlXPHyj0vls7N2LajsrBMBEZa8W2T198e8WU8/Xhqtp9MUwkgYVoBowlJBCykDAkBBHraLAGUGEkIAZBopJIwAQEqSQgkhGikBACGESCBraRqfJqxYRIgMEBRXNbpFZJQhliZtedc9Vj2Pu5HWR3R4MkArLXnPS03Yw1F2PW8qWJ3ysE0ZYYZgB5W4wMGIMqyAZ1ASjhMMQiKwWIzIVsCgZYBoGFIKEqVMBCBBoBBEAYpqAqHVls53SpGRikFbpKroUYRFCqKNJpqvRl2Sc7uea9HqWsj5NAQKyUXrPOvi24tzOllXoyojVChHAaA4I8UhgIGDyrHAGBI1bDCSUElAywcoo0WDwFYCELIVaCEIIRIBWUhDgUwR0aNT5dPOrIsSuysRkW2+ihdS3M6aVJNhToRubger8f6+5tsrfNaAgR0P/8QALhAAAQMDAgYCAgIDAQEBAAAAAQACAwQQERIgEyEwMTIzBUEUIkBCFSM0JENQ/9oACAEAAAEFApvVsg9jvW9VJ5v9TE5R+G/K1hVc4mcGalJSRKJ7qd6/u/vEvlPHpnvsFj36f3b9qd/+usY9joz3vC/JZOzh/kRr8mNfksX5DV8k/iQUxyxVak8Dsj83+tjNZqqd/EnbhrE9ReFyVI/S38+Nql+S1l072qWoLkEJXKOYsU7+Ixpl4Lat2qWraF+c9ikqpJ9mVnefLd/fp/a0mxa6Itcyrje0scuyxhCpnx+TUL8iqXHrFxa5VH5ckVKeaqu7/A7I/J/hB5jzqvBicovBFGVoU9XHGp68ODjgJuFwv1zhF2VqK7pr3tB52BXJDls5hN7bT33f26sv6Q045Ix8w5lUJInRFUsTi/jSLjSLiyriyZzMncdzIf0lVUj2+7s8neEPm7kqr1sTlF4qrq46cT1r3p8j33FtR2Balm2bZWq5tlA7HeV/tfY6n2AqrJjka2MNkJmUjSVFK2oaYTG+mZKVw6lcKpVQJYI3CciKCSWMUcimZwJjUOT5daPbYzyd4w+YblVPrZ2Ki8ZZQwRQuqJKpo1XKz1M2G1ubu8tw6oUQ51xwtJANpGKmm44iYGRlzQnysayWV00p1cKPLQKyWCarmdUS6U06XHt93Z5O8YfNvep9bEUzxqnAxcRtIyrnY8GwWVjoHfnO9/luHbqfUT8M5OrDGNGci0oa1GWQ2cC0R50MmkTIv14KcMFrY5FNG6Pczue0XmFUephT3ta2b5AwiSeSQkl18bcbjfCNxcIHB3/AEew6QvziZRygnlqkH7Y030Bwc3SomMKquJNHAxobE6KNPfFnXC5pZEp4uCp5Q+nR73b3+ovPKrJmMjqK55RqJXDPRCPJG+EdgT9472O36Pbq/ap53cV5PHYdQwsKV4jZqeFpGoU85WjSdDdWhq0fu+JjizTw2Mawp3ndvdM86qr0qpndO47webhzRQxjZm+LBYysY3NQ3js7x6Q2wd43fvF5ALCqzl6hk5CUcMRsKDQFyU+GxfkjVDmRSTYened29y5rVUVZKLsrPRznZmw2BBPaBbhu0Z1IjYELnaOx7dYql82nCe7TUILnPO9jQi0rUXofu1jdKxlPGqJrg1PqnFurFnedy9rVW1IKK7/AMHN2qNqkiKdGmOLQWBx0qWPCxi2L5Tu+weLu3SFyvqh93jJI3nE4vjcSyOCWOKJ5aU4Ew0sIUfj9oKeMxSI2f52e/Snu19H62BEY3YQGTjBibhpWnlLAHxiNwQBRiypKdFuNudrfE9MbYXaJapumUjUoWOhfWO0Uy4WKaDyp26VH2/sgpomytfE9sohl4ik9tqnuj32BHeETuwSmMwY49T9NsWwFpCxzwpGNKewtNis7Ch49MWKlb+iPeT96aheS6rmE5qJi9MaqX9oGjn9sX2hZzGmQ8Zs6l9qJwqo/s9HYLd942AZWkrCYEyFRtGA3CwsbSnNyns1B/6G7dg5tPTFipe6ONHE0x4mp2HmqVnEfpD30YLVhVGpqH5TkIasr8WqX4lUnQVbU6aeNfmPFpvaVJlVEjdJ3ZX1cLC+gLFpwGpsJTI9I0ZUMWk6UwctOUWYR3FFVMepm9vi7t1CqhwwFkKjdTh9dMyVsqhe6OOnOss5SuCZueA5SU0bJVP7VJ+rXHLuWN/Zck1Hu4oXYg0JrQtCaEGpos1oTgn7zaoZw5Lg3Z4HrFpCaMrQ1Rtg4POMOdqTH5iY3Qi39vppA3FT2n9qqHARnb33fWNgbygwS0DAAQAuCsoORendAqqjDmuY5qyhYc7M8D1SiM0rbFOJLcqmw2UjnhAZEr+IoQ8M2FT2n9qrOx5372CF8XzbumhNUHJ6CFx0zZ41NILU6NrkQ6OwyLR+HTFiox/51Hl8jsRt5yFgygqcHg4VTI9pgp3B+0qUWqPaq4f6dv27aLhNCAymYIFgh1jbOHaWlHLUWrS5NymeB6pUXhJT84IuA2Z44dVGIWxoD9g3DamZ0Ke2WTeVnFqj2qqA4O/sjcXHZR8mRbB1DcqsbpdzQkaVJi7PH66QsVH6uz5miSOGIMUspme0fvRwZMtVJmFjp39huKe0utUe1VA1RXO0I7D4tR7hMQ3hDoGxCqm5iHMM5m2klM8emLFRelzcv/Hlw6Rzk5uU3VrlfLHI/LjTHEkrtIhc6STaU/Nqn2qYf67fVjfCO3sWEFDk+PuhvHQN5MYc3S6Hympy2SOkTImtUrdMnVd2g9P/ANVUw8J+FPGQpG8g9q5BSz8VU4xHuzhyqPNS+v73YWUe7sXajzTchOOpR9299gvqWpErUsrO0qeUIuymhQESR2qPZ0xYqn9R818gij+7HckYRx2OL1EMu3FS9lUeacMtPe42OHLvswmJ/ZqjUYQ2BEp0ikfoXGT6hfkSIVMoTaopr7k8ppE+0KiqHQplY971Ut6gse1P6T3K+QtSnLJIuIakOZJTqkb/ALN8nZVHnablLvZ22MwhyUndg5MHJjcAXyny6U6Qp0qIkevx5SvxXr8YhGBBiYgbTOwHfsYodZ/HaE8aZHKlg4TVM3VTfQ6QsVT+q3yHZUrS0hVrQYqaECGOHh9CTsqjytP7+jlZ5Jvchf2YOTI8bCU+UAA5TWOeWQNCHJFHCdhPWE3u1O7TH9hzUecO4gFMAUKdvFsBmMjB6Qs5Q+pFfIdoWa3ju1VXqHieg+1R5WqhpmRQ3f12f1haXPjZjbM9aSUyPm0BqynShYlcjCnxaVqcgo2INT28pP2migDWvqI406tyqeTUxt2eNS3E3UPaH1G1f4wtxEo+zrHoPtUd7fJtxJ0P6or6X1TR6WbH9uHz0AIBOeGoB0iAaxSVbWqSWfAke5RAuTI+YCCcpGiN/wDskNRTDhsaVEzDYs3Z41nl1CofSs5VaMoNwMJnZyKPQdaov8mz/VvHb6u3zaNb2dtpRTnrLWp1Ug2WVRRMY1+HxNpsKnYGIWFnhONiMuZFoTbt8SwPa5ul3RFiop3CJ1SWiOoY9P8A2dZiKKPQdaovMzixYwbG30vqzewTUx2l0T03aUWlcNcBqdEAR4gDBCcoI9SxtnZy4ig/2SoXb2aqkf8Ap6ZUdUWRmrJbAAJNPOzUUUegbVHa/wAgzTNeKkLl+EwqamdFsFmcyoGJu3FsLCIRTnhF6jie8tGNxHKWnyYYzDIm3Z2Yqr/o6ZUMDHQgZmaxrBcI2PQNqjtf5GPVDambl7pwxCrRmjcuG1St0uuMpjeUQ5DoYRZlcAFfjsTY2jovFgU27ezFWf8AR0RYqn9MvKWGSZ0rbjuekbVHa8g1MewseqZHyFoHc5G6kYyscsFNTFHjp42koOWdjl2X227ezFW/9HTKp/RJDiKl1OdGMMt9npG1R47Pk4tL1RJ8LuJAxoGhrlVRMjX00ByMIxjC+2dwVlZ6pKzqIQWLAhOIw5FNu3sxVv8A0dEWKp/RUf8APSRcOEX7IODj0Tao8Nk8XFgLSD8ef9mFF5SyFofqc6IqNqwpR+3YtcE3mBYWG7KzYlPdqWrShIFxAuM0LjNKytSc9ZUXazExV3/R0yqb0P8ADgSuTBhtvsECTom1R4bGL5en0Ojfw3xPEjI/Zw9RfDGWy0fDZAP9QU3kV2UKFxuysrKJUj1FHywFNTc3xTIwyLQ4KJ8rDxSmHUS5Q+NmJirv+jplU3of64/Xf7I/c9E2qPXcKNVkQmjc3S6ln4L2vbxk0tT8vULtEsnJ0x/fNoTyHbcCsrKysqR2Gwt1FPcnvOgzEjU5cROkwi8uUL9K1ZUHjZiaq/39Mqm9D/XH67/ZzxeibT+vZGpF8lDoeoZDiKcFZBQVRG7iTHlOebLRFakCh0XHAH+1+dI4gRlDi5/L71I8kcY0pg5x+bLsTF8h7+me1O9rafVlsfrv9n29Of17I1KpYuNA9pY5rtLo2xyNibgBO7T8lKVnCBTCgf1Y5MObDtY3yiDI4uDE+XKL9Ke5Ou1mU+m/VzdKHePzYbsTV8h7emVGwPpuC1qj8L/Z9vTm9WyJSqPx+XpshU8uh0buQtUdpsZC5WCDuUbsJrlnYUO0h/TXw2mQla8rKcUbYTOzn/q9Z5xFQnItGm9/kPd03duK6KnZUPcY+bL/AGfb05fXsjUqi8eGXispnU0qp59KZIMOkAbNNrce+LZsCo++f2Byh5ILufqoPJ78kklBDOGNL0+FwTafUKemUtKvxf1qGFjlDyUPjaNNXyPs6ZTI+LSxMcxR+F/t3s6JtL69kal7ReAVfG2SLHMIEhFxNxsHNN8QmkJuU5Rnk05tVk4C+lE3LKZg1SgNZHpc2NzS5xAHHixW6pHKJQnlaNNXyHmemVSeqoTPC/2729E2l9eyNS9ovEKoGVWRcGZNthHYEELRrVhahklRutVcyOap4dQFMzIhaF+OAX0rpF+DI1Gkc0/jSOTaRjUQMOZh7e8HO8fdq+Q9nTKo/TUpvhf7d7enL4bI1L4xeLVN3r6YSsIwWWbybsCymlZQWbHKacLUh3/tTtwy2VrK4hRetS1JxTx+470wwLR92r5Dz6lH6ajszwv9u9nRNpPDZGpfGLxCmQ7fJU3ClFv6HcCg5ArUtSLyh2jdzk7YwYiNOzUiVkWc5OUA/wBkd2eTe/yHl1KP01HZnhf7d7OibSeGyNS+EXgFMmqpiEsTm8N4s5Hfm2eQQTfOR+R/86d3JjhcqZ3IyELiFF+U4rKp/Nt4/Jvf5Dy6lH6Z+zPC/wDZ3tPRNn+OyJS+uHxCnTUV8tFgixR77c2ys3BRK7iJ2DEu4TuQnyjlZRNiMKN2DH2szu3v8j5dSi9NR2Z4X/s72dN/hshUnqh8W9p+zUV8k0Oo23cOnlBakMJoQH6xnKwnDlP3e3KNuyP7KLk6m9do+7e/yXVovTUdo/C/9n+3omz/ABOyFSeqLxCn8WoqrbqpG9hbCLUelm47QuTZEyXUnSYUuHo9z3CN6YaRaPyHf5Lo/V6H0z9o/C/9nezpv8T2vEn+qHsFP4NRUhaKcIWwiE4dYOUTwxcb9pZtbWP/AFJwcr6Nmqi1YtH5Dv8AJdupQemo7R+F/wCz/Z03dj2QtEn+uFN7T+DVV/IRQKaqlnKFy1Oselm2cIErUtRWpZtlZXe1KP8AXaPyHf5Lw3nb8f6qjtH67/b/AGdN3bZD3d64E3tWSNjhqvkpJbDuEELFObgEcz0cbs7TYHBppY5BaPyHf5L17zt+O8KjtH67/b/b03djsg7nwhVV8iynU88tQbDuEEELObyxzKPUys5vmwRsAuYNPX8+REfkO/yPr6lAeU/jH67/AG/2fwIPKRzWMmrnG7rMGXXF3MJTm4OP4re1oKh8BpZmTL7+R9XTKoSpe0frv9v9vUPe/HZAqqqdUvubQtuEELyNBLm8y3qDZhBFBN2Nc5hpK5sh+R9W87aZ+iR7tQj9d/uT2dR3laacQNkkdKdsbNRxsCCCCczKc1Fqe1EfwB3/ABS8YLXIbG1EmnIcOpTOJMXrv/aTz6j/ACU8whD3F52U9M+dYhgaG7QghfTlaAnt/VYRCwsWwsLCwtKDRZ1wMupB+tTRsqBLE6CTaHFqZIHJlCXD/HlfgFfgOX4UqdSzBFrm7abzj9d/7S+a+ulJ5zTCEPe6R2ykpTMZZMNDdwQQTdj2nEzMLSnDB0rThYtjcbx5LqF2bVtP+RGQ5jt0NTPCR8o7H+UeF/lXL/KvX+WlTPlYnL/yVCfSOajkWpziSL13+5fJfW821BVTmxtlkMj9lNTOlL8Rs0rFjuFhskby06U9qbyT0QsbzeFqg5OHZVlKKhoZh7gWO3ZXdYIRdzWkJk88S/MD1gPEXnD6vq33N36UtXDGpPk1NPJMdlFS8Ytw1eRWLGx3BC7xkaStBWkYe1FqwjuNoxks5HSE3taspRM0xfkRvY6J2/KIBWMbBkJkxBpqiN0Y8bfc3ex61HTmeTAa3vHi56AQQ3FZT8IlHcUBm2VC7KYeV6huhzmMmZPRviselnZT100Cj+SjemVMD0CCZu/0j1WNL3U0XAg2kdEFZQ2GxTkdxQGdlNkuA2ObqHNijdynpI51NTywnoHnfkhdpDk1ro1x6h6Zq0I9X4qHMj+awbEbztCHJAoXKctK0J7MoxEbMrTsYqNm6RuUWLUQg/KnoWPUsUkXQ7rSQhsyo5f2pEPH6PUHM0zOFAw5Rt3RGLHYb4RFgghc2wtK0osBU8OEVpKDcLF2tCip3OMUYY3dpDk+NaCEHrIcJaBj1NBLCdwWM7vjvAePQO2ii4kyPJAgoi2URtNhc2ahtwgsLSuDlPpWYkY5p5rGVHSyyJnx4TadgQAHQabFiexFhbbOVNRRvEkT4zsC+9vxvg3x+up8czTFbxQOrZhaFpwisbSLBDaG5QYg1t8ItBX48a4MQPT7bCxFiwRd8MEif8a0p9BM1PikYbHb8cm+KO87Ima5GtDG7A62Fi+lqMTVwVwHLhuWhy0FaHIMcg1yDHIRoRNC0tFsbsrv1WHaWosWlHNtRWtFkLk+jgcn/HBH4+XP+PlTqCUNLC9lDG4JngjvNx3+PgzJhdr5Xdc2oOWoWxsKzbOFqN+fRLlzK09bs7cQixELS1aSuazzc5oA8cuRyVloVJIeOzwR3m9OwOdT+Fs5tlZWURlYK1FNcFm3K5CxtG3K1FAFD+AezDkdAsC0BaEWIwgrh6UMFfoDoa5U9I5ssXII9EDJ4bY4qRqPJYWlaVpWFy2EBYQcVrWoLU1ZF+S/VZaFxGrWuIVl5WkoM/iM5O6uU5qdAHKCNjAStZyw5aejQRKUkupmYYj1MLSFpC02wtK0rhlcMrhoN/juTDkdbKB5o9qfwPQY0veRwo4Rrla3/W63PoCw6INs/wAHPQZ+p6Jubnk7KcuM+FNeXDfQM5znnQxZTh+rr46ItjZn+c5MPLrS+IdkI41iUOfuKawMhPN1FHpY/seSxldkb56GpZ62f4kfVNnJvJoVX+raZumHfKcCiiMj2DDX9ieWUd+ejlZWc3GzCwsLl/DPIg9bCwmhVYzBSv10+8lz3UkPCjUi+li2ULhfYv36Of5kZ658v7SjVF8d6N9DDyFpfH6yjvx08beW/P8AAzb7bvztysonn/Y+HxjuhG3S20xwFp3drc//AMplj0CVmznNanEL+ypnaPkdxQvP25oko/zsfwua+27TYLstQWpOLpFwmBYcgOaf+tf9jadkvMu6GEAuW/Cx1s7sdPFhlNO02c/SP3chGAXc0f1awFxPb6Vf+k7TqG7/xAAjEQACAgIBBQEBAQEAAAAAAAAAARARAiAwAxIhMUATUEFg/9oACAECEQE/AcoR/pWtlw/IsfJfCuG5UsQ97+BcLQnClw5XyLho/wBMYR7Gih638DhcXaVQvJR5jtHz0UVo4XEoXgx8xmdw+WhYnadh2DxrVcajD1GasaofJ2ixEtGjPGtELiqMcqO87xtD4khYlQ3QnemStDUrlU5D4sRS0Ja5yuFIfgUKclYx8KFw9RSuBRkxbMfCharTL0OFwsoSHq+Ja2WXLdmSLFx3qx8CEhKXFFFQyjqQvgfFgtaLE70o6kY/C+BGGinFD06nuMR/J08R4oeBUYrjR1cYXy4LwUMeJRjyPyP2L5em4qGY8F0WWWWZexD+ROjHK4Yxb3DcWWMQ/kowdQxsTExaN0XFCxMkOF83oxzHlcoWmQkUWdzPLHC+Zi1QmWIfsXiEIZlC+VShzYmWXr3jzscIfzoa2ssxZYxw4Q/nQ0NbJiZZY4cLjfEhuFDQ97LLhwuFclwhChrkaFwrmxxhS0VNFRRUVN8Ch8SVmOJQ1pQ0NFFFFFaVpZeqh7XKRgih70VDl6MTitlDFw9KGPgejcKGehZcFjFuowyoTsfE0PwNwlo1ZVCyL3Yt/SlZ0LMtQ9nkPIZRW1WPApoWVHcJ6rZbLJo72fofod5+h3l8tDwHgymi2d7O8xd7rK39tI7UdiPzMca26mVHTX8dvuyMMa/hPXpY6V/Ewxr/AJD/xAAgEQACAgMAAwEBAQAAAAAAAAAAARARAiAwEiFAMQMT/9oACAEBEQE/AcYcNw4R4niVFHiJV8Vw4oUYQ9UhL5UOFFjnGMYeq+lOfUfhixZGMOEhYlfTRQz9MvRZSPwWZjKQlXKyy/hcP2jNUM/l7FiYxRXNs8jyPIWXdz/T9j+eVMWSZj0seQ2XKZi773GeJ/mf5mOLQhcWPIbLKGtMRdHo4oQhcch6PRGL6PIXscN6IXF8UY82xGKHshcWPjjFid8GYobGxarkxzQkeI8SijFQxbsYhle9lyycpFllljEWJ8XCL2QuOTHCLhIocIQlK2cLgoW+W1ljlaLZ8lCjJibFlOWtll6pytnyUobPKPIsy6KVs+SlMzUXCMh8EjxPEoULZ8lp+mWNShj3oSKEjJStnyWiZkrGhCGhoa0QsSoeRixyvgWq9jxFjLGhzgixs9lGPofxrVOVDGNFFCfobiyxc3xWycKaKKGoc+IlyY+K2QxPWhooyUIXR8VshiE92iihdHxWqxsqhwnworq+K0WEOGWJl82hquD4qF7EpyeiYmJ8bl47tckrluh5F62JiZZZZeqc0PFnizxcIfFYCVQ2ZsvVwiyy9EUOE96Gh8/0/rzWiUObE92PErg4zxsaqVvYshCQhsc3CYnvkubxTHhXCjxFiL0eReriyxM8i9Mt3tSPBHgeB4HgeJXNymXNll739D2sssvZl9L6vqov39L7ZOhC+hj4IejdmIvpa2oqHrj+iX0salIWIlDHp//EADUQAAEDAgQFAwMEAQQDAQAAAAEAAhEQIRIgMDEDIkBBUTJhcRNQgTNCkaFiBCNSwWCCsdH/2gAIAQAABj8Cd8ZQnUav9PqxihjVzH6bFZx+V9PiHkOxo35Ro3oxr4melSLPChwpdSN1ibZ/cf8AJAmQt13/AIWzv4Xof/CaQxwg7lfFGJ3xlCcoKYIkey4ftoTKusHCH5UYpciHb0g/2oi3hWWNrzCGP+Va/wD0uV11zfx9i8hY+GVhNnhYXVlD/Zuv0f6X6P8AS/T/AKXo/pOD2W72RFAjlCdQJvzmurogCfdTFOZYgcm6gGyv0x1nOG6NMXDMP8LC7l4gUO/Bo0gYmhfolfolfpocgv7r0tThDbjyv6o3ME6gPuh85Y3d4U7LnM1v1x1BQNHlBoFmqexpib6gvp8SzlDrjyieFYL1r9VY3cc+wX1HF3L5TXt/1Juv1ynN/wCJpdHKE6glD5ycxhHiH+0WlsFvfqL9RKdG6a47GuNtnL6XE38oNCu4BF+IQFjeJ8NQOGT4X1OCcB7hGX/VHdF8RNB4RyhOr+alFn7nWQY50z/Swi/v9vlN74nJ4PZqf/iZGTGLOXNxXfyrlXBUuNisIuiMXwp4joUNMhR6D/8AVzD853IZJJhQ0CSpc66lxk/cIxzP7UOG/t6UXNF09qisOC/SELE0cw/amuwxhK5jfwi2QCu8+QuYyV2bPdDvKa391DlKFIJv4UM5QoLralvtIxbFOjuFc1nupxFNe39w7Ih3EsvUfdbmF3XsoJwnshw+JzEeU6G0PzlPxTC0f+yueunqb+Ew/hOFWjxTC7YbLEsRbJPlWAXZOfhEhYncNfVP4CDWnbvQ/OUyoYpJ6jE386M9OfhfBRI81fG3lQ0yr903hikTajgfCu2fZYWNwD2q75yXssLHT0d8kRSFhIXhX2U6g6H8JzSvcIJxPYKCblNcxHvhKL5vkhFpyO+alEnqpXurq+1JGmOha7wp8ra5WHiWLtkfe1GuG/dR2eE8ZYO/Yr6ZHMi36ZJFHfNSOmgK50r6Q1+H5O9PlB/dqn6eKNkLFrmprHft/tYk5vhA+CjmD/3BF3DEyKOqCFI6XZYnb6eEot0Brt+Ke4Tm+UDOEORd3TnETCf2gbJwPdFB7T+FYGn6n9r9T+1vPwocrWoaSgB0Wyms0205A20BrtA8K63WLiuEjYJuAzCAXL+UXYYmozczQflYhcePFDQmETp3VqTmt0BHbtnGufimyILBj91PZSgzD33TR7KaCTnFDQyp6CdG2mCd/Kncecw1y7/FCkqIUJk7ZPpgXlDE7FmFDQT0MdIW0tyq4yDXLfLaAT8qZsi47ra9BiMzTCDATXOFut+Okwlcu6grl/io12fC4h/hYn+p3ZFn7nWhMaO9AEB4QwwmksjQ2mn4ocs/YQ4KZuoXLtkOsyhafwsT23Hlew2QR4juyIbyq5/KA0ID8HvkI6GOlNstgvfXZ8KAvWFhdEIRsE2PKDOHYFTZXhSrm2ewk+KfihR+ywiFc791hF5XMtk7XZ8JtJ7ONqNj1BSd4upWKEIsAvnPNPxR0eNKc0hNU9Jur0a7omfCbTh0YVDineP2pwUahCOgDoBeymc8Nut5cr0sV2XNl3jJhDZWEcOgf+NdnwhTh0jwV6oWEmU5OPjSFXfOhCjMANG74VlJCvTfShBYj6z/AFQ67PhCjKX7oou7hSdyj76Qq/XClDPspI0ophY1XCLzuvqf1UhEeNZnxVi9hUpttMVPQDLAW1IFLXXhXcVZxlQd8lkQAubdbrlC2jL863D+KsQ1xVrh3157nNOS9gv+1DblYgLL1L3y48Mkq/K1Ymm6gq2T8ph1uH8V4YQGuKh3jVCjRhcy5WoklbSiFc5713ywU5vg6rR9Fx91J4LoVjhK4XzU6raliI8asqNCTSwUIVnNy70v2ymjtVrcOyjCvRiQjt0AyYvOSX29lYwpmR0m9OawVs9rKe2U0dqtkXhYPeFYdCMmLu2snsv+ldqjPdDS3VyVsrDXNDqs+E/zKaMZ6EZC3ynNPahRrhzR1pofjVZ8Li8Rwudly7gIeegGUcQUMI+FsogLEDClXy26a2Y67E/4V9yoqZVtQZXNRacllLlE2WIbZZ14FN6br1aB12oqQbICsLAB0JQ4je+6DlITlzLCGrE110OjhSaTw3wUZXddwvVy0kmgqafjVaihlB1PzmwlFp3Cv6VbIeH0eI7UiFIrFY/nKaD41WooZfbo/qDY0EbhQ6o4gQOSNX2XtSFG6vTfIMho341WYnAIwZQ6E5gnNKLXbhSp0jpQFhFAKe9ZUyooMho341WSuWyHQnMKDjt3703zxq+6980VtQFCpoz41WQJXozDUOYUe1/oKwn09jSHGkyvbQtnGWyspVwuXentUVNGaoHdHEIKGUahzCsOGTfQ3pY1nRxIObsUQCJpOMLEBy0aFFTRmq1BDKNQ/GYVaE5unGW16wF7q9LKWugrm4hXK8wpY4yud5IUqER2QTTU0ZqhNQyjUOYVasUXCNTrmRqFRkNGaoQQyjUOYVbQubsdWyvWFZSo6Fuq1BDKNR2i2haUWnt0cKMkajNUIIZRqHKcjat4o+D0E1hSp8qK3p71kIHKzVCCGUah0R81J8dFupQOlLtkPGVmqEEMo1Doj5q/pBKsvBpPehyiNsvD1QghlGoc5p+auxGB79JHZQNqxnvlZrBDKOiKNPzSBzP8Bc7reOusm5W/OqUEMo6Eoo0lxWHh8jfsIDTHtlb86pQQyjUOUpyKwt5nKeI78fYpaYKw8b+VIuKt+dUoIZR0Ti4wERw7e/2a12+FLT+KD51SKDKNU5MT14b4zT9ixcN0FBvEs5D51boIZW6prP7vCl2W2l708dHiZv4RDrHNgecTeykapaUMo1TT/JYnZdob5WFoxO1PfogKTs/ysD/5zWQDrKfqL1L1r1U9Ku0jKUMo1Sp79lidlxO9K+nwrD21rIEdDhJvSB6hsUWOEEZ+R9vBV2iVfhr9NfpK/DC/3OGQrOAKlrpCg2NRlGnvQ8Rx/CxHLiPoWBtugvSdee9ZFnhFjxBUHQtl5eIY90BxGD5U8N00GUad3KOGz8qXnLLvSrCwWLo4U6d0EHA2yYmjnCvbiNWF4/OtymFzBAB18reh/wAe6wt2R+xRlxjvusLxIRcyXN8KNayj1NV2kL9T+VYpvQYQo79/sgykFX7KVPpd5VxLfOj4V80EIEcQtd4QG8LmMnX+qdh9ln+9KeHyuXO0/K31uZO14QbF+6urdVIr75Lrl2UDR5VdXuFPDOErnFvOsUNYUkZIVumurCPdQ5tdoXM5balwrGkG4U8Plcoc06jkNYv81kZN+o2XpU4VA6KyuJXMy65eIrXXMw6DghqhqDRtk5VfNsrFWNdlsvSV6VtksPsNwrsCiIXK9epbqZC9N0eVDVxnYdHtXf7FcUstqepTipuoT2l1ihqXUa22vZX63em1IUEwt0ZUHTgLD37oydTfVtTfpY15G6utrhTqHiHshCnpN+snoTqBoQa1e33KOj5RiBXMwtOgXntSaW+4A9DNGqBf30ICgKfuceOgIoCCUPJvoe1I+5g9AaG9kw6Aah91joXcuJEeHaGMjf7tPQkHwuKy/nQA/wDBLnIW4pxff51OQrcleymjDhi+nH3zakzell/+q9WPCDvIz//EACgQAQACAgEEAgMBAAMBAQAAAAEAESExQRBRYXGBoSCRscHR4fAw8f/aAAgBAAABPyHI63SO52mZX6YqT4md2xu5ocQAub1MM/BNO/Tq/Ji4uJ8RJtSn4ncwKeWJVtMFf7MMCpZsMPKfiI6c35ILZ4Rc3MWLzUsl9x35Jze41XU/BnM394cR57TJiczUj/8AOEYae4/5MNiCOxgmds5JVkCfr/qX/HZ4YgKYKNftCxEoNicRBQKGg9uxNM7Da8RzVeL3fc5KJQ4oEoiKcLEdTf0mRd42viaxOYczZ1MD7sBkQC8Zma3cEYN2Kris10aPwoPMtEAItBe64l7T4vEBCiwXUyb9Y1u7bzVywop27Iq5HyYOJrMIKJsOJi8QdIx3DFsGSj+xChZRsRee8NxiBy17lQxn1BzL/Bm7r81DcDB3nNR5diZ6PXvPPU304e4ltH1BcB9wpsTuHEvcoy1xFVOh77kXEid+ZQlOoZU/DCsLTse0rV0YtNzwH9Io3SvOsssx9ys8blPE2RwJ7EDLxL28Ev8ADB/Zu5WYE2vM0uNT+DCKJdXUP6MeCaXP6Rir3Gaw94ihZzxpgMklQVkN7SWmTBEmk3wy2yl02Un1KNpTwkuC8+YWkFmYfOzvEpVl5l1idguWjODiWU7OotGI5M5ZSXVTLapmHV3M3CfPTkOmLrmGYH4+OhOIdOT3NZ75j0CkYZunXmUn/EYLgzTmanfD5lV96NMocOobFlxBTLqZP9JZquOWIghbFx2g+Y04qAwkBw5UH5m3ow2q7SxVd4FkDMOgvR9Tseo7eLdM+pmoTwmz3GX1n0I2Cl2CZtPaL2gtVeO0qe0ul5gWTmLe2WnMUjCI9sSmA9dFcQe8B3smRLszCkGaFwcVBjSYhNf7DxKjx4m6cR3K+4VSVQBCRld/zq+nEOn9IF0UX2gEVsLRAOAWhzLUw1U8ETjZFDHns2zVx0+YUGxx3S4nGvdnz/LFuR8xRbas2xlfZWsnkjIFLrtBNvvJcrfJ3lrCHoiLNXib3iBV++lQmUP3CeDYwmKNN5J9TNU1xEC9xE6GF5jwiXg0qVIYFNMvm76GyFOJ21Ff+JnfEMpK6GZfgjCBZEpxD4MuiolaOY6DfvibL7QLfMTR57xabdObgyuH/iJnc/sMoQ0Q2nbmaXwwlSpz0qMOhuVOR8wVWM0Zga7rvEe5FSpkBnt4mTIx3iMtcwXqxoUVHBm+8+75qJxQ4b+J86iwRXgTe9kqba4WxjUy6uK9doAgSFd6lnEewCHkhsPErbjp9dMUnI7QYw2eOZ/FNT9R8JUz7VxDg4IwLMcjDBF13deZtGVu7Y2xVEbZiS/iGITmNfMKSmAC89M8NRvcIJg57T5lx6g9yLBWnu/qFOum/M2zjdTnp57ztNChfiYkd/m66MDHTkvvBKhsTZmXeqOfEMYJo7zM8fpO0wl54voNMMz8CTFp8Q5yi+5einFwDKYx7MNufdnDXOG2Nxs7zeYeN7dxCvhYODAtA5jpqJSnF9TU0EN9LbYm/wBkoDt3jWm79o5UylvEsvbXGLGi1h2qodu0LEcNME7xusfubf8AZa6jvpiptuBRmK24BcQurjZxmCoM4ntLnEwnmBitWm5X6iI8wl5x0IZD4m/vBg/NOujGOoDsrQceYpAAuzzLGXXOMwAxipiFjxMJKNkvrBsNZhXBBz4mzuX24gWO4V3/AOoYLs72K7woiXfjxELKOoJB4iuYxAq5GM1dNHUVSpbZw8S/qZVysQM/5Hh7j9FxbNxojrPMqSHkgDP9kYsYUtqrHVwuEsuZdbi2ZnqDXRoOO8BV9RC7TXmE2TyvEQtzzCEuDDtODcK7/ErU3ZU/vQMnaBhM327w/FmPwOjuJaXf8gNiYSVergzKVteVxGRyXzCms3KbT9xA67B3NS2c53EmqwJDrQ7DO+2JyiTB0+pcm3hiFaL7XuFlvLHeBcGDC7hABwf8Sqht5LfU57wZOjYQhhcSeC/LAvkeUCqUFEtvmD3i/MWFstuO5+5A7iG8SkupHJ3JVOOnMYTMriDC2eZSm4MRQyVEr1DHU+pjtlmRHBfMTvuEdz/25ydpp9QPjbD+deYzjr6nHRxE7x5jsrUIugtpY12Km9/U5r1C0LsLMSsGmVWTuoLJfGcRitkrGgHomDr9KjGKHaY5FCjMvvLjsRqj3Rz46D9qcypWZSnjtDHhjmLajvzGalXvMlvEZmVcS9QWEYTAXvzExZj10L/UKeo7xFeIzHJ8wD5jbxUImYhjmVxEBYvCUyQuKGNd5WelsCuNd5vq5ac57zbymdQ08Rz0rIzX+p/aV+NfiEqcxMzIHVQX4FKTW7KYmgNoGb+mG0jY6OGcRgsWGBFGjW4gDzeOZcNima4gXKRoeInJIGmLjFkYowgMAnzDdT7CaIRjpf8AaoMCCZrvFqG09xcQzENj8R6cQYwY6lfEKPMaqz5hBqFmKJWqhtxmElBa4uUKrzRHQA35nGv3jlHP5gigWpaA7zFZp++h7QxkjfMDqYVnqO99C77T6k4PMK3OPwqV0CozI6O4O0TL9zYPLlGkWkQQrdSxqq0xv9QytmYBypUDVxbU7VK0FW+iPb1NE0Xh1DbtOJRFc4mNQHD3Il1AdBR9BAsuqMsez3oe0vLDMMXHUqBLZXiCcPnpfUdIXDU9yisfqUdp2RqIcLx6jC0U6leDNw2C/cIcHJKcNMNQNueJY7HBGvYVm5dTR5nNmP8AYL0Wkv4mWYajMQLTOegP9njoefz/AJ0d6juOhgS7NLMSngN2d5U0prHeL8UsXhjk5eHiVwGfEDd1OUwszVxEu8NTRxxAy6qcVTyQdsKI4ezgXU+Z/pR7xwduYmpzDNjCiIDFO243Agt8QURXULqlj1Gd7+om6n16lfcrUDOIBeviFD6INOR7REawfcNayGgidwiax+rlYizaRNuiLw0RZ6vMJwpmntOmU1YXD7gtu/8AqGjxcCjGpqrmJp58cT6kTrWd/H5ea6bTUOWEYKB9oQ0Xjsjz/CxBcc/BlbNaq4WLOS3tA2fFVDaN2umU6RgiIzp1LBnvO+p8MwHnMRo/sUJgo9QK8ENTmY4OY6lLL8QW4s3Nu5Gu7GXwRaOlDHMKMy0Rhcf14mPmO+lR3ucJrzET/KgMuf8AENxmpwxTEvCzBAp8GNx27JUCOGJWajKiQXxcKtgpzCyiPMC7v/J6mGJXqLKLcfqfybq853NRmiavfqanno+vwqcv70ySO2yFas3HTeJYLqAqGye6W0Q2sR5V5hk5GPcCwPoMzQCnaDEJ5qMuApji70VBjNe2D4QQ8JnLC91zFNOqSAmgnknaX6cYbBxNCL3FRUc9NkJWJkVqFYcTzDUcwLx8RRxCn/US7gZqcRGQFHaUMqvjtFyF+SFA/cVVm9EpWpWKpCwOO89xh+InWpUH/iGyoy5GVzOL3Oe8cmNwUaOIKkziODHEV1fuYN5hqVOel/hzKqG59dPYJa6xFnL5Z4EYc8EDM9bRH/SVi13eEZULBrmW3YtIh5v6gtucwWX56sDoHwishcjh6JusMSpYNEJTGYuK8x3HWoQxHplnYylzT4lL0jKPylm8eJiW5lFDeJtK3FeGOfH8lqhQc7gL2X3M9p4iDqjmZNQCwdQgIQUgzHon4CIXTk5uJzjIGX/3BvN4iVVb/sDz5lUw7zAO00enMqMrp7PwOjhGVJFu9+IWxeJeRioBp5dqlJ2przMRFYrEp+mlOZRDRtAwRP8A8TDwtxbAqH4j8ulwuKjtuWqDGMxK4Y6veYKnJ10czmKVH9wr/tO8GUgK/vpVabjPg2SpXONVBUrFxYYP+ZSoKgT19yvNSm8eIhjI8xq4jPk5I9Kx0YkSCYFA0Ca14WoDxFZ5nOPuYqtx35jnpKUzZ29THE5/Hic0dCE2ls4RGOkeSNDl6Jfn7RTgeO0oGVuZ9jjq3P7BzMxyu1fk0XnoPkJ5hLlUfAo7QgNT+I+JgIxG2pziKOnMylSkLq/Et2+I0l89pVL5mbde4ysag3G+/MDLm+I+84w9Sp2/yBUuta7Rcx79GPRj/Z2d4krhq5Qj7zqcEffhi2rzwzCNGNVNBwkKzWIP8I6YfjU9RnOOnLpxgqDd8kqi8lMBlVteIm6BjG4DsFLeJaunky+oJEWRfBMjUCrU4xDuc6fxel0KFp1O8wT4lYg2Xh6mq7TNsNywK58QqWE71EqoRLidDiViuINlVkl3IXKDMd24OUhxymFcNxxdBzuXLvpTEr8GJGtzXx2jtO8CiD4itVhseITpseHkhqoof0marM+YAW/B29x/9kyGiGiZqc0Tn8Gc9Dd9Dx9Q1dCUOGzwzjfAQvBKPBPGdWqWoaxyy7kLUq/QqIZF7HNdo+jlh6H4OpqzLdvEn9n8k4jzde46iy8VNQwYRbPLCwriNxdtrRxCbmnnxDV/c1ubjzgmT5lrHbtmDZp1CeYMUG+oQDVTUcxJUepzEhw1L+peMMxc53XAmw41FfgjXaY+I6nJGz1Quh6VmV0ric9EhBMVLYh/RGD+Z5HDAVx8AgBXNj2jIBbeieqYHvFFgMZ3FJlNr+RKxaCuh7/BnCE5Ls301V2h/ZcrV8xKU+4wyfMXEWjmU1fE4EjmKioM4JmHuvU53iZ25juhMn8gsjgurmWOINBxPt2gwIQgQ89R6P4JBKhJvMxyyZ1FR6hs3j+xHHfzHzUMG70wpV5NzQw0TzOOn8/GszaMtDfchNAtBEE10dpb2HhCWgQ5CG2EXCO5TFx+5YBK7ZmkDv3gWIhUrmofgzSfQyj3gsPEDiXH4yxyrzGGveVxDiZla8TxxDIcMyrVHMOaNT+yqz9xw94Nm7g5uSEXtiWvkwxVXntLC829oHoQhqBArqej+APcqNZvUzUYYlLjYeJSpQIGClgG6+o1Dk8nE0R9HEpwYWyJhhqPW49XfQ/vQZcQXg4RMnmPMtBVynaOheblgsUIneYSlclbjrtQ4L5iVUNN4muOwXuOC7dwh1YygLBeYzTAYJfvIcIlXPFR6LdRKgLriAuDDhELqk7ztAxcFLb8QAyeklASowRslkoo7Q3vdQqEIZhgYmDmUOYn1PJmUtr9wviUq4NxjqXjxF98QpVKezB92FhCrgOYhC0w++jqZUe0eYa6V0evFzntOPc25h4mrXRRk8xnB5WYZOG5hDS1mYy1irrcJsA2HmCcAa7Sm73UCgDRD8gy56aPUNRPHTW8wcZqOXz4i8x8/EsyajvzNEJNiHd+45DxAsxuGavcpWCIpE+ZUdbmR29oqw+jzFS2DomkNQnEcAJmNjmKKLExbREXGKYo2BXBL0MuW4toHjMNT7INkXecQjPnFRmwd+0yVW176jVBz2qWDOXvAURc5lWK7q59PMp20xV3DR0xfT0zuSuujopO8PCfQQZ+zOUGF2WJe5l+7v3MlanaXgAyMopmZBcn/iH4sOV9PrQ1NGccYgo77iYqeeIdM3iGEixClk7TA/1DnBKaKzBrxFZzxFZ7mK4ivITDKLHMVFZvjtGAU1BiN/8AUJSssDAyy0tjtBDveR1GlC94eJfqX7T4jnuPfmDlv9bJXTee0KFaL0QqP8i/uC1tJzA2VjtME082nMGbU4GDQMVdy90L7EChwZvh26F3o2e4fCaeYw1O/SuniO5x2nLpygmdrzGfbZqd5o3/AKlbCFTKe78TMO1fQ/BjNnT6UNS26Cfei4hiG5dzTuPQca1zcXHmFNfqeg7yyY17ypXNHMzYEw2NOMSknPY7wDsQiQBd+4q1fhjJeZeFKcJECAGh9Sl/7EN/9S7X1BWcniGV7loONZ5gqFVbHaC1OIgLYczMCnNZlJxTQJr1FnYORzHd9CY0qT4LQ1rM4m5T+Ob18ysV0fM0hqJNTSfbZv8AOdqBCx2LBd3clVihRR2nHofizV/AhnE3/LmN3BgeZodNuJXecxeLlXfbAXEcYhByEaR3lSMnL2hZMho6VUIky5WuY4WBfuFj4/UIP2SpvFTQNuKgTOPl/wAhcy+zAy95C50tzNonM5mLxLlTPaBshUKh7faniFUj0QrA1XMELo4FixXX+sumqDdkNda6eOjqVnx0JXSEgxHU+4zFtuXqEUEsvmPEFZjD8GOpo+un1WEdQdaOSOio1xGbhvM7yoCwdHBrEDIN4mapA+cJkOMVkYf7hALh0ILpolm4LO8NAqAOAIbnfiVX/bhd4F5RqFepOLUUVVeIZdncsuFmuamvidkOMRiVBjn8EOlJzjfxKQVW4SV/GtQgy6K67YLU1W4YuZnxPmHSs9Hc3Az6nfpzq4hcVUBoxqG1Z4EOg0ibHvo0/JjNem8k4iPe6ucTP/UrJK//ACYv3HVsdStnGJexmO3MLvEOIdHExlqVqHHaBKlVvro8xBmNpiuZeF2vHeNWbwssSA5dTNgr2lxWOlMXxEKGejMe3dYzMzUrqTf3HsPb3GzJ/wDsphoHtEwGm8zE67vcdAPuWN8k7Svw94nFfc56qZpRCwMKppiAscxO/COIcysLMZU0jc9zh+Zj1c3UU+SLV5VmPRaSLBOUMnmdlTxNG7lMrzNi5vT+53A8jCcHLmJfHjpXWy/7Gf8AMN7K7kOQv29KBBnFm4LJfmEXTiYOc+WIxtHHmFOh0C95jiYW25dUTDwrJJtfw/e6dSbZ5/PF9Cp8zSAC1KtjanO/UCCCuk1KAijQlSpynH3/APAYz4xn24a6XiVwwZ/MZWxxDg+oRcjsiLKu7BYANzxr1z0wYKe5oXAQLuopm98Slh2h1DoojaLCtxOTEYDdX3hKPpGXFrrENUQzAICjpXS+l3dAyFeIaTbwnbpp1+1OXTcZh04erGEOnnziVEK25lO8EhAZXMN9d2bR/wDgZrGfah0Jj56O0KToDVV3zSGYe6HykF8sZIhqweNzH0g6lYuJVXqU7gSVzHrt2mSFw6HoHqQ6VMv+4/YPEVWhmXn7mlSBxAJRMRhuHTmDMSzOTiXFOz8H3pygrupGeOlfizaVK1b0RqDAfMdC257VP267JxjH83q+3Doagu8NeZuaXQOpn/Jnk/cF1RfeI1pvvUyFpxAFMAKGpn3d580OabisDs32qcG6/sGv+ZcGDB6EIZlRiq6EWYbl2eJk0S4PQYiWriXVtfg++Tl+Sdzrm9Yn+w2eeml9IA4bnwmD5i4pFumXqbTaMfyY9X3YdCFmtykuHDU1Sagt2JxLQC2y1K82e6RFZviDljtIZOxsjqcJeOf+YoN0d4NW7R3hTiZB2gqP7DKDqDCEGDBhKibj0IFWgmd2hD1BCxNQG4/uQ8+Ysdo7L6/yTZlb+iX+HEenPTbpoz6kFhABTlY+TfWxJUBtmQLLq4x1+b1bnmGuhDMJszWJiQTvCFbsjcR3/ZsO0qG3iNSLmUqqeUITJp6nC/3M+qth7PZPQIwA/M0qX0D0XBgwYMIQ+YsoJaEagSP7Y/WHiGLNRuWbN5jXAX4YNvPvMFWcPZhFd3ZHDP6nPz10+M2YPoR/X5Edwh36lfrlc2pdsFrLcQOeCuqClkcMAAA7Rjr83q0eGEumuhUAnKEexo894gHENVZOIDF+oG/IlHOeSFkA4l9Tk7x2viVxG3mEaeJXdQzKi78dNQxMswYMuDLhhXUwbxyys7pqNrwxqzziC2DZp1C5MHZlTPpbFubu9wzSVsWKF3R3YJhazfEwOeJn6uukbM1XHM4enMOruEITVn159SfRhrrz6E0jr/4t8ztdRNpoxB27GNsBUepKuO0ZkwkuoK7SGwNPeMhgXHuYOKvmBaOHeDgG7OYmF1XMeD/Jg8wYcEHEJbErVR0pzPLMI8cy0xb2mLL4XzCgiiizU5WTvxLi3XDzMZz3z/64lLWji9QNaSYBWzzMNae7UogdvBLlXfX/ABm/TM8TW5/vXmujvpnjppmO/VMvR0Br8NhF8CMfyY/kiGOi+O9SgLjXzHVanFmmG2UnEG0VTzHOwyoDUzNjFvMV3f3KrmYnubqArOKhPj1FmhuFPQ1LzLlyzvMMO4cwtjgbSATARYb8xxfWmZBaLpdTJROfuWrFhe4hZtcKz9XDClsnJXssNk6WaGPw9noGe3U8zi+rC4XcvibIkAOrdwIRL2ddIa/DpjH8no9P0uhCE5TSRzLt4gnItUxDD7gu6epz1+WYm8QDRIK3xXMu8PaFD/IlW8ykaY1Ff3LGnHaC2pc0S6hNJcH48zRvE7SOfEqVB2kYlOO3eKAxf8lrgpNrHywZxsjp1+ouK0uKgfBidw7kyt5wRttbxLA9fhb9McQ7fh3hGYhx01YACweYWGy7S9TuGuvKaoziP5vTch0IM0ZgRjh3hCMMCVi+8QhVOvcuFaiufEYC/mIMu/EefcUQOqjdzNCbG1mSst95qcRbrvLr3LvLHR56RizTwneWVyLnmZRqF6fLLcq/MoBvmMTG4iuMZ3LplMcqq9S/lWgmTekGUK9xksyO+8Zz2j029Zsmp7TxPmeYb/BhonasT3NkKnhxbxFhVDdRUKVfEOvKfcjOI/i9Hpn6oVRDoTVGYz/WAaHAF3FgqmXJKhid2NGfURUHlmaGv7mbf7Dujv8A2H/7iXWWrzUqx2N1Gt0xzcM6rDvDXaaHtxLuITGYsF4ZxFBwN3HTtgqcAZ7Ro94KFMcM7o7wXBpeXUcLPiWrol5arsImo5a4xHY/L/qLW/1FQO7fqGuLGDx129Juz6UatmyZ/FnGYdCI8xD2hkuKFPJzPpQ0dTbomcfm9BD+uGodDZN3ydLqrvNCUKOGvEaIu6j+YZQ2e5slUxz+4u6/c0i48QVYNOZ8BKmFG9cxJlNuWIO9MlfuNqj99oAlxzNjl1F/4limQne5fMBbagII0VuHdd/5BMEfUaIAO5L0CF3HjhsGM1QCKfq7zNHRpgXhceocqZ3MZO9dGbek2n1pScTmG+rfaXDUJwTRjtvcXzn1Ia68ukZxH/5GNQ30Nz/HTf3mhAsabi1GFs9Q7xWRg20Lqd0tIN7Yd5kYivFR2nKNpdY7xAMSuzMwXL3hhaLaNR21t7BFmPmTMNA8odmN6IaytTCVA0VqDLO5Cs07EyAK4GBg/DcsfJHmMWVxzLdVVVUakoMLddk+Fhrp9Kbs+pOOhPXTF9HfQelqan9MtlxdT6kNHXn0TOI/mzvOH2hquhc5m7Lw/pLVP75U9j0RAPGMxcV8dBaefEWrv9R3wxxLichqDHxCg6w4lTJknH/YpS3MW8DrtApWexBlq3fJmbt1mLzABh34g0bSB8EGDPPaFWJViioFq4m0sFHaAe5cqpbZUzItTiMS4vVcyun0pvPmVHrnfXvPMIbzMxyPE/vmVnefQho68uiej+T0cT6MMQc9Ccpveam/3NZv7sN5ZjCqy1OEuJpvGoK9+o9NQcXLKlRrMzA+7h0v7mlqXu8DxEOMHNMwCXLfO94Qrg6izvZfPHeUg1Vl8wfmXfxFcVOOfUaeuCCt2R7kUGhz2mei3nO4bzB2/faYB13eulu/2OZXEOnrqmYQ/wDPR1Od3Z9ifVhrrz6Z6P5PV9aPEGEJzml8zd7mpNfaaf5A3sSPy5zLRqqhuibdOZmbg47MFPmCOWiDjwSzhMr7xPz3jQOLOItGLO8UU1kYrzBq5tcPiXWIpdR4eJZY57doFu/HaGJXnUp0uF7xMl/M5Jdd477tJ4l8df4dPW8R389d/guYfcNxcRqniffSfcn0Ia/JHEf/AIsvXHRCD4hHt4mFvM2zWae00msLGrwd5vM1RD+4W3D2jvoMxPM4EIKcaIOfEGmyJhFep6GpenDzMU5z7jyrAQChrK4mabm0+ohRt7y5wz2hSA2X6QRCv1KgrYtUR95xM71qZ67/AF1Y76fXQI9HcL6cRqmfbZ9qfVhr8WZx/wDB6fVjqGzoOSbOIc/c2e+o2k1jk53OL3hExNUqMrodo7Og1FxncvIw+EXDKBXncsLp/swCcxwC27LiAENbO8c5km4TLXiIsBjbc3v91PEpQuokCuuJTANMm5wG+Gbj02+ujt0Z79ONdeYwnPR1HfvZ9qfSh+D+CM4j/wDFf4pp0IT/ABMn7m73NekaTSVPxc0eJoRMxva8/UqEMkHU0T2ZhupdZi2HeHHmO/M83MvDiHjEdYrLC2gO+pVva7gYJ4IGbvtDYwRzKI9QqXHeontmPFuprzC8OvXJDtG3HZ67PXT2XuO56/Djowz5dXU+8z7nRGvxZ1OI/kx6fQmdp2gzmc+Jsn8U1mr0ms0lQijnCc61fSd/iLlbjMxWMTET4nM5rrxiOM3BvLLhdahhxBBpcQaE3AClxgEXDZcbDKQ+1Z7S5Me5294muszXVjNGZSrcLxCPovru9dPY8x308znpn10d4g2XxO01HTHfiM+1Ppw0dXToGcR/N6b/AF0viLpXPqD4JidF/BNbxUJWkWNLujiGipeiHuPiMIXnnxAajQzZ/kpZmVHBc4naVDDUulxcB6gnELqvEEKu9eJm0/sinGsXDDaeFiaKSOrEz24jYq4mq5mcts2Js8d5kz767vXSGWr7Iz1PfQ6G5tDWYxi474mp5n2p9CGjq69AziP4vRhNvqOowhxDg8TMfGYsdA2MU2eYBl7htit2qryzIe4sEUGoBuv3AJnLx3hIhncqzhB9w6+5XP10q+Y6xiFssr9QiHEFW9wa/Uw7wb8sX37g0hBwVF4yQ3M9QlwiSOWInTf6mqDkjiVnc4j046banHTiOFiwT7U+hDR+HYjpnEfyYsJ9Kf1HZD9wZwuZ9Sb07S6p56dSwxOLajfTVBc2mP6mWYFhxCWf+ZuXBCQY8sd9HzPUvxU34gMLl1qDz2l/EsUkOT/9iYq6ZrUMDEu8sdNGT+Sl1d+5jmI7/RAEwtIxql4P+cECCck/nNPTF/IjX4PMr8nMd0d59CGjq69Gw1H8mMuOSJV+GOod4b6QkgOcRpaXYnNuffTboxBA8ykcQxLFTiORO8Mpo89o7nPZj5XKIkTjowFxVe5q7nzMVNwYTnUvu1M8Nzvj4l5h455nzUsK+5/zQ/cTh+Jljv248RxoNbbhp7hu+P3OZxHcfEro4nHS4pwfmazzPow0dXX1N2M4j+THr9jp9S+JQUDsRoqjq88HTtNejAyHxGOf1NC4aqdpqZcodaGrgfMTGCI9PU5x1BvE8V03rU8JSkACtsSYsFN8QLq3xFfO49d9wdX2nqaP5CNDdkxJeO1s3zMcFfU56fcDErqKrr8wbtHEJQ3Pow0dXpDHUfyY9cD8z1P/AGJdCK0GXEXsdvx3jKLY6mNVqBrvEhLd8S1Zj56SDUPVPf5htFYRBwPuVQN3hiZZ4iV0M/8AMYHzEroNQ3XaOC/qD9zvUuU2PEakqmR/sBVXhGHA7iKiCYPUql9SrBbvhjwQM2hsHx2n31301E/BJii+eYlFgY6A0dXoLqcR6nVj1GbzxNMvblaCL0tfwYtYu41Co6mV5hVYU9pSSokJ6dPZeIfqETs5iAiX5TKQHkiZRxUWHciLqNvEsVjETMFct2jW+fRNdSvmADFwoNQFBzL+bnPQCsm/LMAVFBI2P0uZqDlO093mPj9TGq+Gbg2d+Y0kbtgA4PIQ5J4obMSlyL7j1l67T7LpZdfU5jLxL5t10hrq/wAdK699D+TGcTnvMPZxGifFHCK9vx1EPNbh1FHP8RcqROaifM1E+fH4G/QQ1Euozm9waDPJLpRfvxFoM+SCViwWb7xWjMN/8wAZMRPNysu4a6fEODUMQgFWYZcByzUPAGZCKiwcznEsSVHHmN3cagAdPqifum44GQ7Ed5t5zPelDodiYb4iyCIsM7pJjB90sIocPT5nojUej/PTuuh6H5FDdI2aX1AAHBbfaJlu/wATA0OXmVWe7phU6Uog7cRO8dXx3lENw1mcINdZHOIFS2GKHc7nEC18zNrHEq08zNjFQs1EpqO+lTipi4CvLOame0ccVcsYwHPiZFi0wLTotQUS2sumOSRl+blZxUSeeZriW294Kg47RDYC95cxdd5d48Q1BGyx8MrLmgZE3XaoRMINpzLn0jH1w06/56PicR/JjFUuQ0RdE8tzO3XH4pXIfuAsRoCKuvj1KvE+0SHbmORg9xhuEMQcYj79B0FCsygW4Vaw9olsK7QDDJwdpYWVcK7MzhHMrErfX/yo4xMpgH3H4W1eIKNW8zT24lQK1KIDQ9/ExHGW95dkZxTDDOv3Ev13I68xMeYGJx/zBz2g7yw3syzpuu8uL8wz6ZcuyZxiY0PkgdgcLFg4cbJcuf56R1OOo/BjMrnMwdDqBGwZXiFE0OIG1XuDSJ+4niDcYlNRKiHHQ6Ko8xFQ6VEz4iVdynYv1EZoJk/2XX556WXMdNRWf2c3BD9EKJKobHFF4lhHCbhqczzAAqMAEQA4H/YZ4LGSDaopOHEA8VA7nzKyhoj2cw/R6juWnaWxO2zhizBg448y781ArZGZUvaYIDjsG/8A9mlA/CYmJWxl+gvFdR+DH8gA2vEG2Gf/AJcor/ZWE14laiRzPJEjEdRGVUrEaS9MPE7jUAGSZVCMfc3PMWxrcvWN9oMWZ8TBxE5lPaVW5jnoqies14lvzDG/3MD43CA4lsOgCsMaUGcMQ21oeGFV9AjsfiGZhcZ8XO8+J/JTWqJniN/9wYK1sZvvAeUoqjiD2ZgM3iNX2hXG4RQHve4VsgBhZnmELgAoo4lY/AdWP5XQ/wDPA0S6OJUWN9zvDD3lT4iHeURiOYkqHiVmAyseoma3FTHSq1LvcXRlIO2Hoq2Aj4irWeUhd7OfECy4lEXFz7QytvzKxRjp2gFL0wxrBRLL6kMilxgwV4g0c0MAcI4h6nNRpjtU7h5w6NzifyZcmp4lAbuogstIqi5m9ze5bHiFTuxbE4Di8JNHr/4j+JoHLGWos+UDBV4Jbsi1xmFCnTHXceY/U9M9olxInELeZWfEJ5THgjuOZ5ilxnKJf6hnvfeHkM8g/U3BkzHa+HglNH6l/c9ztPaNPfR2LXmOrK+AmdPJgIKJ7lExz0GOogJ3SyOSrriFbyjREQ5hzyKuJQVezqY7/EZmcxxL4WLNRDvmpX7m+rrJFdnDPqTiPU/+KgOjMaFAx/YbGRhNm+QlmazMjqWrLEelyiPz6iRidCZm3qcxIbbhiKg46CP3HMDGodxBPS5Z1Hngeo9FhjNxWkidkHbFdvMYCw7sBTY8wmm/xUNwV0JfUhOKJZCckF+iJDYHDBF5HmNCJ+6Pk5Q4nLaw7Jkw4SYdStx3Nr1BrLUTKb8z+fgijslz6XQ9CH4P4EtgziXBl4yQvtOWGLHLHJTvvES8fuFkJS3byRdNfqWWf5BUYSBAuJOC8s1/xO2cf70Z7ge4ioIjlxCbywM+JUsuJhkfMXyiFQN6jQAY8QKzBZcvwS5no9OZdhg46IMPj9TxfM4NN9434MtDEObmNA7jDLLE+SbEF5uJAfsmTFJGsZuDMqMrOZTz9x7NM+lOPwHV/ExXLMEYLJi7l4pi1b9R3hTMHCsQrF8xs7zLmd+pqYu4vtHqOdB2i1wMw8ep49dpgzL3XwRu2eiWdrnKUXxLdv6m4bYBr9sr4ZhtgTmBcCjoiZVwx0OlSvnpqcQYrKsZgp/CsQHWJXFENMhNO53HHclWi32Q3+WDUfmMoVX7ICgXzKuB8xlaDdMW8BWI87BWb4n0Jx01D8H8AukZRobPMTolU3bLNVFGrgMHF9ohlWYcGSDdN3DuEGzJEA0SntK7nMquYk4gu8WXE+RLzLYjcYf2BcCfrpTDzmVcuiBxKTGIA56XCXLJZwS+nMIJ0zBQvTD8WG8Zi8Mc2p4imRpmPMfDEGX9JXBs8ywIIsBY3cQMt96lRwTt3lagD2hrpZXvoDU5fi/iuGoXWrjDJLvG5YFsqmuJYZvMNuZX5hbBB7B8QCqb4gBSfqbV14lXTcGm9+Iq7JR2gHp7wLKYRWJR6jR8QX3BXH66g1MVuVJa4MW2mCpcs66jMsOlYlHbob6XmG8NmYQN/wDwSJ4I8SkUam3ZfqIH3uFLRiKwDLfY9lxUXUC0xTOQexYnRVguGvzsejHkWBlTOlzcYBg2VBpuu0upxLcVUH3gjmiByrcwKCG4GTFy11FXef8AII4SydoDkZ3mpa0/2Z+8sZhhCbS358RDV1E8S5oXBGaPcsMxRvMBMT7hUxOY++mpfiHQ99LgxlkuXFZ3ZIN/i9WO4sv5ly2pdwd1QpyXjuS0UW2sXIx5ilUDz3IBJNvzelzpYllzXS/vt8SuPxENxZ38QPiXK1MD/rEL7wYfuHmFd8RMwI3ljPBABKzjEyNxeyLpudhg2z3mA9yjtNExc9dKmpcu44i+Jjv1OmZz0xGZOemADZBCvxY9XMejW4/qXncBqYbXM4SJdIrp5nZ0PwYzeAtQMWQx75mAzlcqFYIO7RLpjZc4g6lze2HrEvtMviJivuCjc/s8osuXbLieNwLgPbHTwSyU4xL7n4ZhcZzDoz3meuly2djMRh0K6dziOzhB/B/EXEYk8pTeIEdL3xH/AMJkYNy/fKCHFNw/89D8WG3IDDVx3F5xm5d5Xn1KqXxiNdLeYibg3fMEluKhR57ErmpRU4he4X8R4lN6zxL4vDMPuX3KrEqOJ4YgvfEqa89CamJRC5af8S3sdOfwKIo9Kx0CUQmNXMTUuyWWzBHjdcy0P53CMrokTxGqhuxshGP1HeP7KCceeIyGgZ4X0IQ/Ab3hm+/JLFsuqmYlcXBmd4gC/uXeyYhXBxD3PKFMutEysDDiGHpdRwywC95ZWumeID2xM9pnobhUs4iw6JMag304leZRK6V0+Omeld5rpk1Hc2Vwxor3A2Rh+DLejuIMei8zIeJnnDgmcbageP8A2pZNZXmGNQh+CYjYy+DLTWDMpuw3NnDA2VXiLrdRa59TLv8AU4riVWIazC3RKKphTjMu5cHme4heS5z2nEV4MQ8IPgqWy6U94O8sl/EOgTK3now9NTnrnoNuoReqy2X89cV1zCS/3+LfTUvp/IixJXclMxzAeYA1mOoIMvnxM0W1TD+Qh+DKM847QQVTW+fno8eYiWGjvHNwpxHHMUlGIis7jnMzwMN7jiBi7nNQKNfEVjW5mV+4+4a6DLluh5zMeOlynzK9wPMDvHEcy7l/gMsl9bjfVlWI6i7ccsMk1+D+4+IdVi9NxJa8wbqalSq0wPeXH7bEIZhOOqy0ZA918d4aPHHRU2uICm3HeAtqbQrnMarE3qBONwv1NsxMFUVL+ZWMwaxU0zNy4BWZYahnoDiNdMVNijcIVyS5cWXGEly+m9RISyVcBi+Ol9LDiPhLfRHBEVnTnp7mYvxAPGYMzGLEx1r9y4rqonH4qEUELXXaBjpTQcsHMOhLjGAQBRonOOIZjd2XYeZRysT9wxC2NV5gNblnlL5uCvBMcuYJeCW1CODZmG93C4+44IJLriW1iXMO5jiA/EqU6hcZ8RhNTnUzeCF9MRrrb3lsuX1TfTLhiopbnHQPRYmSXB4llTJFOsRGpghvzMROYN+MGj/241YrRrhmB+oJxD8FFjxLl+JZReLiAs/kod77S2KyTNN4lngg1z0TEvGILphT7l1PmBvNTDAxiffQTTuNd4VuD4lxFmYIYuXDVwa8x1/kfM2QgxxM2xuH3KlVG76XOOlxu57ly/iL5g92JaAc8RCRjiKRWpZipgnKNBjcF2uiNfHhjVUHLUzVZ7gW7pxKFpBtzV+e0ScCgK5mVTuh+Cx0tjgmDbO4s92N3fftDA5zEbtn30XEMgR8GIGU+YlJfaB36kY35lDj5lJKu6meYjz1xzLNQfiLczct5g9sQWnMvgOqPiA957QO7K8zmHSo1A6JcBHDUsiGHDBuPiMWKyJ/5mpSsTbgZeye7tLFPFQ1DDmyXkHzBGgydoGB45hvbvZAEEVulvU7bEkIde8Z/9oADAMAAAERAhEAABDZ0zt7jRRUQTJzVwpDF2FW+hrDYTUWYZMcA/iLxCTolW5EZ4OmrxCBBSgwVqtvRhNmMAClhsiw/BWTskd1bAQJ9jJwjZmjk/y3mtzlzR4h3X2FC9tEETf/AMVObKSgfylUgcslPFZahFscsK0GF5Yh8tXwcssUsqBdv6Fdh9U+YRl91VMC+VMcO0AgwZK76hV8494Iq7mVM5T79NrBE51k4bMc7W+qGgwQ10Oe4OuSFiEZtCnQw0HFIyaYs6TiPVPzic1GbA2ctWRnAqr0B11a4L2Vb/xLMicqbrxZBY71gVCY5sBl68x4X+UFTVNDUBACKk2djHorVIJogg4N1McQ1cpn0Y6b3pbkfy/RvAge6D1ROjGba/8AepJISYpjTJaq7mg+5mwzMIN544iAryG2seEqgVjKkMENGXwXMcwHf4BiAGFmGbGkFAKCiJlD6X+c9DyBnqPLMcnz5aHA2tdJDGCJ6vUVNaggjsZEuR2lRIraNHSNPUKGW3pdNlXrrn5FsxqNsMKBl7aMn0ovWBgY7DR2NUqQGGX49lcc4+zUcbmttsBuh03AbsqMBCeNTNYD6RXoM6W37vyrcm30njuLgSH5mNnpQFzZXvEcj8OEyHR0I2iuewogIQ4ECwtDnTLEPHGoJ5N8Clt9B1BKOZle2NG0+MhqCsc8AitIPeBeTDuM1e0lmAZpVsHOJajgvmxA3ODKBRC6dwPKPWfdZsHGJGhEQerUvY4zhW6H1v04yHONJljKaANEHYaRVnqugl4xJbexcGW2cIPYNLieWeADqzokVCLif/OVNgS5rLQWhhW9T5MfwRUk9B1MRXRIpBzhDQFEf/KHK1+kAPFp3IQRLVwUw0NcP7f6K0GICCSmCCHDY4CHS77/AB1p7zeUAPHXh8aOBz0tkkQTYzBy6SFro/6gDWrrST2Vxj/GBSycn6vkTKMzbV1UbtAApqkqP/ylyWB4HgxSrVzNz7qogo0cGqpWFklSjby/3R0qvnwS3yoZjnxwoLwjQlC/WBuyl21k06kfBh3tw0hLaylDmgrO3nN5cbteeUDZ6gresbz0CXJnrI3cjmvzSx1wRiADOjd146ho226ptzoD8bBeEpCjzXuXr3uxQrDgR03maDwHveRk1UehggjWqRQHhqhjyYs1JAqRFajbz1yuhxwmGB6n8rx14Alw25wu3L4xL09JRDyuhTjKDH05L+HuA6UlukbTAWzzFJNXTDqFTRqYJCxYZlTYKzjoSwS98oxi6v65xdndmgyhgKzEzDmBKTbxiwkbonRJahvY6UMhT7pu62RkhA83gZZKWtncieGMU+yZYo0KJkbQFYgIZG68nEAiDKKoRLrrP7ln4J+toRRYZrUcA8vT3wgUegzDf0Fkoor5RJJpQKptLV0lw6RRTZl/BLYRh7lG/wC7H/s8mAKKGQ2uKUCrkpbaKEL6j+w8fKPc5IODhVZxhBM8Qw04YaSGyictpoRhZqKzsemIPTMDJMuq8xovAwgUYYIk04okyWfdhIUNGKsBCKCyncPwX0JRIuh9TgvYcYI5s4MGSwcOd5OnCmGHt2KETSuacDQFZy1ZZij/ABWePfFOGNIDIPPBxEPIoY76Kv/EACARAAICAwEBAQEBAQAAAAAAAAABEBEgITFBMFFhQHH/2gAIAQIRAT8Q6joSg9EMboZsX6IxUFQ9vJv4HDTFTThIshOy2lZvuC7GI6xvVR4Og28aWNS44yYij2Rsor1CaNodrwuxKu4ejwY3SL19WPQ8Dlih2GqDDbEd7NeR6HrckLRei3g/lrFNjzOE6L1bKN2KwcWTui6aE21tG2Bv5pWNlJRUNuVYsWD/AIM2tD0K0O00OqpCRfwqVCZbFh4Y2OSmocLkLQ3p6LCkMg9yqyioqxMLEIooYh9gN/EcoafDRH4VKYkGHEcYvBFwsVSvRG2GcBUxyWLPCnYrWxW3Y2yiwzY9KD+GjXAh9KOFy+C07GvS4KHi96LVsSRJYmvgKEj9nOFieF6sX4NnQs02PSEPSE0JX3B75mIQofdYG8i2FSdDWxKdiwqFosZtH6E1bNWKa/YdzR+C7EqGNljgQsb0M0GrbKeiZOFwfBIpVHXi4PfgsF1ZZaGZWtiSStCaFQRVR/2PBxWCHwSzPg8UUJbNg9Tqz9MaLiGMIexKxsujVqOh9mpQhlY0M4hqEr4U8RxQiHQ9ifClykmtD8R0JlpZKVrh5D4IRVsYVIq4WQkVYoSRaXBy1FrsXDsfIUOF0YnebHwce0MaFEbFqNNDWoeCcJWOouhUglMdj5kux58Hya9FtUMoPQm2PuHilbGmg0ZQSejRrUHZxixfJ8we9oUo0aHZ2J40Oiov9PwLGyL0dHZwXmoYsHwc+Dsi9TE72Pqzc5FrnwQg7seyz4P6xNCUtD/TsfB4MQnLFg+FanwXBq1mqnCfSxh/BOXbdD3s12zRaRsGuhrwZ2Mc3PgpXMXCPBCWMIfSxOhvYWG0JY0UWxhPaNlTNWxu9nYx4o8FDycrkPShBN0cLEyhYTF7Er2IujUchvHRxhyF3BzeXgnoY9HJ7DlFiC2PCGyERY9qhcOziFFT4KGLHyfBHsXGFRUJjLk6xaxoSOx8lQ48FJY+T5CgTt7NyriSXyUaFixdwfTsfMXHkmJYsZwvRbyOhag1eisoeGpsRZbtGjHzF6hckxZNWy61KVj+sqpNXC2Q1iKCjQs9LcnZsaLLwFjTG6Z/Y4EUiRagSioIlrAmMQ/SKcbEhSy0afBrBwLmLD24sLxKhBrFodh0Q0dFlwsUaCGh4LTHZY0cHGaRzQ6GhIPFooQfYbguSWi21ss6f2PD0ZQv4JhjjNfS7LVC0uDQ1KhxWsEOwJYZsGIStC5DFLHHwErEmhwW1sTFoasQqEobS6IS0NfDbsEmTTos4PoGMJRLWxO+SzjJLdDdssss/wCQCK3o/wCI2Gw3Yn8lDR9ENaEIFAgsOCXkuObOKV7CKhRX9Kl/RYtg3Fw1/StDwqUustZVUMXxr6qEPJ47BFCx9mosX+JfHjFrKpVDGgv8jE/i+Y02ef4ufBZOb1hVIesff8aELDhcvp68P//EACARAAMAAwEBAQEBAQEAAAAAAAABERAhMSBBMFFxQGH/2gAIAQERAT8QfWOBcEah3CCNicR0UQk+PCmjkOk9P0ujx3/RfDGLeCSIOYjdy4PjEt0o+j30Ssryv3Po12U/hjpsUNfGOtpeHAuMW2JaEqyr/wCC9z9kPg6iGsNp6ZP6NTRv7E/Cjg+S+lGfViRcwvdeaPwy+UfB0OGNBr4F4ErUTNm2OcMh1bzbKCfBemEjwTp8H4ZfKy+iCi2xVuPhG30WNm1tnbwqFGvxo2TUEEv01FNFFl+ll9waqhIoM6QzpcEB3hc93LVYqsoomx6ZxeGPyss1aQ2N7Y1ts/0f6HH9NWbZfisY0Q0aNmKskw0Y19rCxcHEoiQoiZEQQmdnWF4ZR7H0NMIo2Vhqy/S7i9E3QwQR8FlM7OvTwxx9zcTCGHuh6Lr2ujJJlNwclsasbS4LMOzoXfDyxfBYfhoxvVHqN09IfDZsSnWQ0PbiN0Mniu/hR9QYYhBrNyI4FWdGd+l04Ojo/oXQ5peEdiF6cKsLdEro+pCL+FsrCejZaQ4botMW83CG0N7Ohj76d4T0vDzBG2NNjrIjpo70aaNnCDy2vKOMde0dlGq9PFixRPBhtiwws9eVg0P8j7KMsQi9iGVMY4/CDYbEZMXxdeUNoW6NfkTg1VEJsbUT+ia4djXhEJjYsNnryjg+m/a8N0GW/BvYqRdjaSE++FEyiFsoQxtTR7OMdeUcD7+PWVpkSbGscF0TSF0ITwkfYIaBaUR9EfM9CHlHA+/j3n6TcZBUOou0JrwI0TCNkOjgT0Q0MbOM9C54XRjTv4I7z9HpjxsW3SbOEEGCExoGiZ/EjbLfRa2cDwunzEwujH38EdZ+n0k4NeCCFHixAMbxUKGbdG9DwtsXPH0fDr8iGPo+4ooMfLEZCWhI8LYrJjWsrvldODr8iGPo+nwfZ1iTIQeGg4wNNDjYY8LuLlD4deH56EUfR9LrDoaMoW+Wig3FOzQuGMXfKGdfj0Ig+j0xwlNYM3CfmEIwgkNMa2MXRYeEPh1+C2dFOkr0ItZxQ0Q3hoX9oTEEJY0LovLOvx6NQRhCw2hfCjGQEwQylKXDKaIfMdE2og3MLCPsP2iocgklhCVlx0JjGMQ+flFFYtmlwenoodeGjyJINrqGuzgf4O+kGIdP6jdsTEy+DCKKoW/Q4fQTpRih/pGNDQLC/i9DdGgsITw94mE8V4po7whMuFTu/NET6J+DgeWLL1RCUICoQmMXD8JkW6bCCEJGruWyKmNQliafmEFR+Fl7eKsY5tEa6LRS+KYmZHo2Fu8XKDFAkYxCX6JWJplKcj8LDRCUWWh76Nw8ihAlIJ6XkyjFhUKrjEy+ljZpjw8Ieh06dxS5eLmDRDn4poeLhMorBvxF8If4hw0iEf4UuDJr8Fhmn4MXknW2OrF+7/Bi/iuw4PCYtIbs5H7Yl+3RBIx+E89CR4oiis6xaIT/AK6CocnGJujwhC0QJh/9IhTBAf8A7hwnlH//xAAnEAEAAgICAgIBBQEBAQAAAAABABEhMUFRYXGBkaEQscHR8OHxIP/aAAgBAAABPxDK0ZD15gKBzmo4IMswQD4PuWMWcPEDjKATqpSowC6XvRKjUFp+GMDZRqXiiYgejf8AtQiHGZZ8Nk6ibmo9N56jhtv0xYzXplFlNu7xDbQ22r+0FeQHB8Sgxnkxw/8AkoaQjkeRQuGAU+AR6i0uuiHB2RGAHsv5lLYrITbinROIAUBG1ljHeXURYt7OoJRLCVnXUFSsL33L4ul8TTlgnmDhs+ZVOc2Taga7YjlujULWh5XFbhbqnUwoOG3zDgC8ZgWKLxpeZYJM1gCXffKTUFw67uUF1u9+IHPJP6hmbK57lZjkhuYMfmBtuyuOGZZ/BPL0uyVcIaALFDDAC8eTj3EqrAZo6Yn4Gq/AOV3xHLwch9DMaOxlELcUOTiNYgJUrhIKK6V35OiYM9lPIS/AFHDuupRwW6FZ/cqgZpaIukaav+Eo0TqBTZ7uotUKa8MVK6+YrJuxZ7vUFteTnqZODYwtOIbbKcDEuV4vE31hW6jUqdCai8AWFL4xzFCUayKLy1x/MoE0HxRiAlKjmaN/ibXluf64/OYtOe+ofN4BHL0uxy/8gg1Wi7fLyeYog3Zs+IkaYAPJ/qPWQMKr1glOqK3J18xaVAO86HXuEz3wPT3+8NqUcnGOqh2ewXh+8KZUU6TzK272Cij/AD4jwBN0mDwQgDaKvyy29TkQXyzimBKKB6WUQKcaRGPacIqP2Je7o9HMMjVtZR4hfx2xVyvwwN2a5YS3eoFemOfVxC8+yogDVLu41CabvUbydcRKsk0QLVfmV1Uyo6nolQPw4Y5P2Tkz8TNcfMIKt6my28ZRlODpiUoItWDWIvSXCGnx5lES6kL9GoR0ECnxTqUkMIc+QdRDB64OE7I1Q+XmIs1NJiz+4FINAfg3DVSFs4GbK2yo4zVNzMqQ0QNMHKtvruZI/QK9ZhEiFQeyr0TPKwB6/eVphvWY13gC5gcXcPmZPBTErJYLW2ZUEc8QWrXniKnGg1DvNKsMwKZoBI+rkHT0QyvGDP7xthQbmQGZ+8iP+RdW+lYjq2pdKz6gTb6aB5rl8SgyI3jgriVHLbGnhnOeBCk7j6waGWVJNlZieRFqP2lVVL5MM2UEpi4gI2q5fAG6Y8vccC7OEUGmDILZCFowtH9pVlAbC5IkCCJgIux21HTBHleZ2HJZzKhDhmUxWdJ+JQ380Sg8l+YHFY6uCb5vkjGlufEvw/BBQzAn4QtK+2oKg5q0lGEFxt/JLGTS8TFq4KsIOP3jhqvpm+/qJpzKPWdsxjg8kor+IG2yq5jVLhc9eJ1DX4ZiYijGw8VFWYxdZvx1BkxLJhcpN2kvFuziWNEobeOvXMqKUibeQHJ44geiJAaN0ytQvIHJA8mzK+GWoRsVT5g4rXtpf9QuW0tX1zClQAL1/wCSuzolkCiQvTTxMc0qS6XDCt2FqlzfqYlWDZ7lf2V+08EaeZlE3KbV8QmB3Mx5cHiFKKx8GAMlUNIYV2eIQDbxklwiPiC6EAbiEjhS14TumWlKHKL0viKALWo927IyKbwq0OS5Rs+UZliR8CK5TVKR09sSig8A/klqIHB14xDVpTdgWrzBnTVMsWXuqcxTkOyNoBDNJuEixbky0wh1uWqRXVRbNM5xK1C7HhiwEEvFS5H0e5dFLeTplEMHi21+JSxeeSAwWMJv3MqxbWE92dVr7jTIlniZPYZzCUG2sBCi9NmnuK7FobshwrTiYjXlIC4IF4YaC77SBnbZI9zczOeZVNpi+YeKrgj/AOEMgXE5Q0rnJzEWipgZ4HEKAoGBvHMouCLqDGfHiaVBQMLb8xSttaxwfX5ijlkPX/saJUjY8RKYbKZewd+I2XCBinXmXi30MHJRz7imQ/JCbcHbjfEZrL2R13LKML7Zjo8QGkCGW3DncFgq27HjfcZu1AabFismdUX8QSa0qqo6dgG18S+NipTQShq7gvBuVBpG7lMuVKuEDhwPMHwBtkhzBgwMxIC6PglRbJmv6gEXsqd+INCqWYVauCcaqXkx8fvEZQzU+uI02A84+I4Fv6hGi96eYolizvcVtSsLdPqIx9DEMLCdoGgZWr68yi1uue4Y+Nko+Dmo1qrOUMxLSVl5jLzWtMGw29cRmUYxVblxlKKs0y/Qxl5YYqXCo8BQ3Tt6MywpRlMQSS8KtcR+TPLl4mEBTFnJ3EzZdPcRxXmrJVebvEFG3dn8mA0F7jV4unDAYTtYho3RPYbCfKME0rXn9ANztj1KCxtvmdDHiCtYgOGVBpKBtioAtphh6FrF6mQZAPD0QaoAEbC8wbhbBfN5LiBsFjIqyuY0WB3ZvHHx3zMiuGDY5HhmaEoG65fPTB1WWRVuWuJ8KQO3zHesaNPh2sUBA5MDr/bmwBkwDjy+Jdsw4hOBHglSgqtFyeB6MxEgwORgXEVkQ7YSjJrZ3M8ZuVxNgqyopDGvuXffkwzitbSK2BLMwitMLU2VZMfMY2lxQslhwS12M0mMbAvN6IcClLPfiU6CQMLzfUxCJ+R468wq4tDFv9qOxZjiuZkGdcsq4Dm9zaAHAMRopfLVylR/fUVV4tijmIK041HfRy2RAFJTywISgHJM4K1shpALwJAveuiWcp4DHa16q13Ps9EQAqjK4i3yxz5hQm+HEGqDvDMgiLxXUUQrJUXNr1gmsZQxawzoVXkNzQcO6dyhWjvuWUrXZLa/lgZpSrRNWTAGSW3Qy05uFMNDNzOEqumJuVr+GVjWe5VfHco3bKbQ/wBiDYcczI9zjWZScpGSIOUgFGjNMRcACulgrvUqYqbZKd9MMVLIBqBpJGYJru8pGsCrg9EbNX2nRDKicknxG5qciu4FQnYgpDGYkNoaahSKcKKh3FWdg4eQ4iZagl9F7lZFI0Ug8leZRdVL0FxrPCWUGUd+oBnJQ+5it/BBtLz7gcKaeagrjdypvI4gKuQvBEhsubxHkxbs9wCbtsYuEUFbT9vM5uVBXYIzuALcF9TCTNg1BwVtUyyKs4DMldeQ0+YKgW+f6mbdA6JVYYw0nNxym5Q8u6eYrt/EEeXPAwQG99xoMn0TACqN1zDbLxbGZKByMyDbQEs8bVQcR3ms+ZRlvHRDl/EvbS1kJR6p8Qs8DomC3L5hKt8A4ZTAy4PzG+76I1cYP5Nw0YrPc4KD3OfEwWuXiFS3lUwpwuWVYm6LvuOBuv6lGKy9EpC6z7lZs13cOdPiO6s+JYeJz4iWe4dnuCxQYOBloi8IKTy3bn1xNZLgB/Z4ikHCWpdOe4RJpKHDZzLCcOHfXmZCFHbuYjRoV5/3EOUiG3Y/qUgwqBfbxEBmQTh4DubYKC0PJ0I/QAW0LkfzHOVLl2v2eIzOBIwde6gpDS0sjn5nEgCN9h1HnlKixXfmXLAqujn5/iOclg1Ghxa4hYrR4InWVBVqqylRg4G4XamUIKk9IKiKmP3RmUhDlPE1wJpu3idYQrm5YEOVi2WGqiwyPp4mDToc1uO459SrbWOR2xKEpfcpf5DHTgbxTqAs1V1dYqGiW2KtmVyXexhY6CuZW9Si7c1olx7eojk16QW8V1cKsyXqiphigRTdTA1HddRFUFeJSs6eWVFUarfcOHFXcTbeOLjasuNEq0HkHEOVLW3EzLGuCXcTXbKIVeIjdtEbwIu6qA2IJzcavGDviY4S1RZ11xKxkZwn5IVeb83K/MC4oo5IAvHyxLEdvULsoGuI7wMOMzzreZofJTUzas4X/MTgQEbyQb6ZVYHi4S8PNA6Ygp0O18zIwVGkgAAapr90Dq0RmT2HiDrE2BbyHs8QfR4gybPN7hKCQ3eyFMWyTA+HmBoyWjI9wAG5oKh6rEwgGgtf5+8MAADsHU0kISy+LfzLysigo6Y1KBCe0RtaRUDLj5lUDlgq9bIibqsZgN+bWYYlQGA+k/mBOqEVo9h/EYUpDlr3GNn5fzLtj7gmDTQmoiFpfdxg2VXIRyKB7IOBfNwABjRtgXVDwnM4sGudSrJT4f8AYmLGTNPUVZgNWzI7cSw7pOJdWvaYqAiA32RGyvoIWMN1Q9ylKLmzdxMHTp4idwusDr5iSzRpczKBaRNQcuWrYFJhrOXiGNctx3lA7YmrbtqXfgC+fcZkETCupm2ehUwXanbBiqe9wOWTzcXNUi8O0CmAFyumZJinJqY2yhgluHPbmY4mLyoeIUDaeYCsmtBOWNwLa1cb++oFP5XG+lbxBk5jeVDnUG2z6IKVvOnmYJgvPMFsCFNPiZiFEGvHrzHdQmRppIQWs5LXcDYKNqahFM2pbtf2gr4BdMWoDVaX1UehNwRk9H9Q/g8GRfH8wPLG0fqU6wXdCwy10y0d0KxeopLBfb346jBC7hKAarojOLLTZ2jkJeaSucRTTXBA2/eaFNHcLUwZNw2y22hljg0Has61Mlybw2iQmtVzEWGXcdtF06e40zq4NFoXy8zzF8QS4omWOeonWmuIhTWO5YGXaFMxG4y7y9cx2sWuDNIu3BxLWVR2yorZpeYHN4vLjUCmT0dxBd4YshEG2MPU3o3ZZvzKRdF1io1ysHrmUoIaDjx5lugGEOXi5egF9nEuKi758QOK/MAKKx3KWQ8kxsrgLx5ghyFuAchDE5jHAMoo1w1OAHG7ms/NdSlDNN1UqsaIurGAZfxCmcZiY99RMY+mce5WaM+WKD31KepW6nOolcbjYf2ilxG2mqKlyL+WEtHgAicyw1nj/ZicEBoM5ruOyIgjingYIrOd4GvUMlXeavqWSB6eI0RQepWl8RtQVwCn8wcmAhZpykaKghbLTFViNin/AGDqLChWVrZJTRVj7lADvJq4BuWm2a6GUAMuRlvuZcmtw9+IF6LuUaHXTKDbqzHK9QgPRt0PnuZAAAQ7X3DShT53MwsKMrLByfUtwr3MlrgbimxbqkSNNYxiUayp1LMLZQ0HyxfGdRIrA8+ZVsWzykFgWO5cMF6RuDjoi8smYLFAOSZCkp5YnLh+Zlha6oIyyEX9pWA3j+RcWh2Va6qNmbI455v/AGIb7YAw0azYaYGMCUT8BLwBW7ambwJyhF2lh0OIUPIRJyryQlXAOKg5VUJULdOeJo/CNXQI9keH9kF0GBARLi3kL1DQF90y8rMjMrkr1AM8VzAAKV7UjQqsdzTES/ERc57IergaGxOZTlDxBVHcsSmVgpYxtCNRWw5uF+ENvHyzIwANlGoaCPJyrlAfGUDTrH9xzWUQ8AnUxv2VVPsgDYIubfPEs2s1uxIWmgWgMfUIVGWg4hlGa6YNGXQ43iDU2HYaTqJscI2fvFNuD1KrW2eJkRwBphzSWxG5aQ0HHplwlbLB0IkSnPi6IrU/UxDGrSXdErlnhjzKcrYaogja/KYhbMA1XWQRawr7qKVqc9wL8viKoOKDLFJTechxEM2+zU4HbsY06Y5ruXZNDS3LAv6S2QPghoYz9dw8Co0iwNkbwc5mYci2TZO8W3y5IWC5INeo4FkGjN9VHAKCxZHUMbSi6LCZMQwrPvzN6cCs/UGwjQyVUAy1biuD4gXZb5F/MQHyDdwZLNlFpFtq+CbKh3cOSueTiCCxbC8wKuci44mC64ZXcDWB6l2GJb2lZw/LKrY5nFZxxK6iYziVWWWOflPL/EqsC8wiDPuHgUuEnFmkc/tMcKYBzUwuCCfKVVUIAz0DzHaREZHvuYDIiueVeI3wnD/P6l2wEs75lCLQOVdkKMloUqw8QY0RnJuUaMlBc2vdVBhDboZXfaBcHryTImAHTem/PcNsV4h7ejzKzZ4Z7mPYK3mL5G/MSi2jK9y9TYzTj0xOQAxg/iVscYEdx1PXEwqF8LjVX8hLEL6gVKnKtkwwAHm7grGLyEYXwOpb87/QMXMVYr1CDq6WmKywvR1Kt8ONIWus+UAAQxuoqLFHiKsh/lxHQC3gFfniD6QNbAmy+bjl0sLj2gLWaYr/AB/UzpsOjF+IgZWaVsQYCr8+IrGqZazMtTwpNIbOc/P/ACGWZsU59FTGjPdF/XU1GyIa8L3HKFuU4iULCnHCQgCob/4g1kFlMAB4Rw7Neo07pOpR2pbdvSVuDBm3j3KjVA6jZoPcAbxqZAt+xmDa+iVjK4lb1fmaxh8wqvWcy6yC9Q5KK8QtnHkeCU5HojFjlrjcTaKAuad+oKefFGfqalo0LblHBNyXjlYTDNAfQ9xXWyfLnPZNLgBkniMLjmipnuV+C0l0PJAxQVvHJ6fzKXA7A3cNGxlQnE/A2EsxXwEFhHZk1GYEq2ho7jE/RDyO/MWkMi8ml8yh6SiLW6V+ZelYzwwKcFtp3L5xLU/aWUnaoiIAVnk7mJZ9TKPOMcQy5vO2oMj8Ixot5ynMxFJvPmLGqtu4VnY81C1msvhKQufBIih1zLaotmALaVUrkWvIgo0N4H8oBMY7IgAO9wBUpwDMVVnwNcxVyuCHHUJAPKGuqiehmQ4PERxaCgTiCIFpqycjslA9cQL4ZYMtvbMCuhlJEK9PE7BAmJg0CKp4SU1guh28E8Quq0vUKcOPUVabcLmCIOgdyiXe1XWpTlyI2MTBwGhDZ7BOXmFuzysnFpeIFPHdPMtSym9TuhnMRaN9yxbSIY0eKgWU8zm6PUdqqoC/TPbxNZfqClhybi1iQVB5HcFZHk7mbLWBNkMreGHI8AcsLtB4SVynceykuWrzMa4RLLaTzBclrTDmepSZIKbFf7c0AFoMB3K1ZRJd9J35hHFJvS+ZpDXQFe5Z+RD/AKmBZ8C/qLoLv9kxQeHBuPPMeKEsaycsoUWvN1KlPBkiAcPlSHoQWaW+YEIGgO+4Gh4Uu47Yy1VXGw49MasOOCILHT1ElnF6WU2LYyZlI4DnuNZF/MJQv3jUalBzxM6Lq0DdB5Sbqz0iqDoAi8l3pgggTg8wkBdWdvuOus+RTKRdGYKKtqYa/wCwVzZwX36ltlZxhq/RCMA0gVGIsWkxuDBatH2iXr5lN5z5idytV1FUnWcyyqEPD95YWDyGPUdnfYOU89niKOw5SKqOFFEGQWMGYyoFVbLGmdNcwoAKviBwvZhPyxpq+WACR0qURWbCZY156lO2a5itWFeI2V09yrwriZXFWT9+400BXxKWs+2M0rEbqna5rytmAlBVzBkvRfjqHawtwmb6m9S8LNElaR5O4a2wFFHqLZrRdh+phaTRsV09wyyKZCJZdoNNP7QnTkQOEuoUYWYPU0rTwwXKT3NlZjebr2E09GiKVTFA13mCAlCaX8+oqyY7gF8003MSinqImyAy3x8dytKy/wB6jsAGvUwWR4sISzbHFwYEJk4uZANpeMRQ5fMugtfJqNiiniAbeBwhqsC8K4uawGlWK6/7LO2RtCZqsKDB5iFDTk0vuAZQ7HJMJRXdl1L0qBpAx2p5gVsEP8x4lRYndogBFmVXTNBB2oPRCUIvDkyd1DbBWB2QaHi24hQyczg33TA0vHUQxUALjXe4m3uJq2oXjHWppBNhfv17irr0Q7/5M3CY5P8As+IaEuFstK1M2wIpfgwM51fEoBlbw6fEIFwdOL6gtMBnNQNBdlOOohYpxmUqy/UD5pgMjrua/iewXki7KxKp5p6lNUW+4TWLNwwVv3Kgbd4uGboIx5D3MAW0a1FClbpvKy1JYKrPJ46lAUaaNJA1dUorPvqOeLYXb13DsXIYV5hhgtHV/TGu4ukvp1KCzTgZ6vuJQ7yXOgHcP0fMJhts4ZYvNnNHEaqk7JoChplBNjJeozWCA0S/HbGQpfDcvKNeoUl2+o7PDk1LwKq7WphhRqgDUyUZ+WBsFZ5YZAOuR4jKprQ7mhZpslFAHzyJcHsKvFQIBdJpG9Kl5qoV0gyUY/Ee4c069wVQKWv3RUBwAbvuYUEypg8GEoLOtfmcAGOAxMDdHwpZ2U618SgKIdH+pnSjFafERS7Vof4ggcMDN95j6inLuIWcwGoSPRxKrE3LsYP7l7HSBfZyS9FPIf2Th8QByexxBIzTLZDFhS5HhC1rK5F2enxBR32Dz5nX3eWJGoWYLgINmG+U5Fr8zhRVxJoqB4quZStW/EDhV9yuJDm/qXW+ErEpQHHMrQszzNUGLUUavxANC87r8zFBHOAlzXsVwc/7mYRLbQZrzGDlAKpniAKwhcPl69xl4W7FP9qIC8vlIVDVohfiZp0ojpxcEDQ0lhXbz7hnPzqH6Pma5lnQhQbUKdJCM40QaKexY7cDQnHfv9peWwzTXudCr1cyAWd3K2xooQmXI76ZcQDTlZQoyxjNRrHKttSjsBxWJa12nFxDdoVjMrtrYdnmCZQB2zH2h4YqDsJTanPAwXJBrS31LO21uCgvr1L8CsD9yMBRXSpQqs61HhfG4DRpzcy4MQl2HxFnbXnUqCx4O4tm/giXt5lfP8SyoYzzBxf1EH+5bMBSHDcqlhafU0B6zFCFalcL18yjG9FaNRC6DNNPrvzLTQSi/wCSUoluCmJKLALWyWUwW8R0Fy2q8JN2zA4ZagrXM6eXlIjzfuJQLvqXmqwcxwIW3YgMGB8Smh+EB5KeoQRpSBxr1Kit/EwogN/BFOsgBe+rhza2Lrl/5E4eE2GriqRYMGtHggVaIiml5gCaLiwv3RzN04BbwAxDUPJczsOLs9j/ABDbGKTK8FfzP2vj+JUJ1+jT5gIwmBHIuXsioC8PqNGNB2OoI68AVy7mg9bep950xNVvo/vBCYpxVwgAqjNShCHacTCBbdGKIFlniU7FXyzBTXlZgqrbxLlixVdTCztS5j2l5IQUXx0f9mwN7BeZeRybF+KgNFtUOTp9QPn1MUfVwL1rpmy3Hawca+ZQgp0hC4X+I1JiAefcxWFviUL1XfES+Lvl1H8nBN7mmM1KPnEzadYgoZwzTcF0PAXcuENqnN8Hn1DRWcK3XhlMoKqs5KikNIO3jonOCFXgdHmClaHA59nMLMXlLE2jdZDrmC6s+ZSBj4h5Haw5IYxmUl9XUq7bwc1KL0e7lMWxu37Eqis4n40KoS1S8kJCipmGZZwKeoNVSwcnHuPeALZkeM8rF5QAKaL3/EUsbUrAXHYn28nXuIVaCg88fMK4UbPiZhTxbf0MrVlk1nPwQQALCizz/c249Q/1QlTglaHPiXcMRKLqp3V4YuY4Va2O4Xpt3iYX0O+B1LYlbuIXYYhhoapaqcMHtIAUsmU6hBWNDUVjbwFgDeF05JdXIClj3ElapN3FpxvZCtgbb8IhQvO1xE2oLvzD0PoRBBMjQa8w0qyQG6OKiQp1BMMrgs3shd9IhmaT5zK2Vc6IU02MOsERFt+IgUj2QKYEgwsHxK1/YitEFNVqVqAOPghLGauqSBnVeTiV4iF4CVEDw2PruWcmVe57TzNbEyeOvcSCuUBVuTx6lD6ZdkA0xWrl0rGboMXLqOT5VACUVgP3lFX+DqdGnqGxrwxOhrqYHAuUMeZspy8wXl31MzfM0YzqyFU3VNhqWIVVQo1KKpixphUMFRngZaAhbeh/7FxNBHI79xlTYBavRBpWTww5iKgyF499MdjRabWBfFBbdgcwvePKOjzHZVK4AnghfXz+oqflBTlbq06vic/DDmHG2aUr6MroAyDVTJK01aLvNR7L9upeUrDvxOQp0uIFYJwYnLLmmZbCgxXVS4tajhhIo9DiIDjHEti1lg5RooK2KHEBeKCGDqM6BESvhEdNCjfmHeacnJGWgWEqVG0aG2iWH7hLCbYD3A5cZzUTQ15ga5VHxhuKhHK9wuHPVRaz+YFu6le7lXf8ygHEJKTfUbN4DuXSxxzHHBbYbOYJEBSrIdxmGVD5/wCQ17V1oXNxgr8oFXoeQjYpvGT/ALDBNAo6ephW2tPMCg0IaiIU9VKwsLWazKsuvSIFhsmaHRHx9zVdrEYGagBF9QNVgt71GEd08dQVZKWhlhS2HV+ZakI0X+FjOjAYTmvcOySaKb8EpbJetvR1GOlIsjy8eoNSCSlOWZcFCpT5PnxLmBhoeXqoNMLW4rgTlY8F3nm6PqY/7A/UFVL8TJZm0jDfcVH7I4GAMTBqxCsExUoKg0dwI3bEsuHxuIoayqo5WryQFaB08+IwvqGpmlaNjECs0auD/EG4DTvYDcqnFqwAfvA7MG1xBkFjHezwzCAcFXhJUibUHXqWIauQmfVasn8wquRY/uAbwJxNg69TfFPuUrOPmHCJXM2j7iNt/UtS8tcMplvHVxzVp8RUXinm5Xz5JXf7xPfuohraIu9DibgvK3xPkAfxMSyxTFvPiYhIIUF6Hr3KPQoKZ/zcvOpoPofzBaDwBgeIG0Md3LkuAQ6gOLlawt+Y398VKmEfU5Pcxjn3Kt69RH8gJkA28pGZwcIBVXnpm0NNQKQJCYVvCVwazZ/2KYtAbHT/ALMuoQgWmmCXDCZVv5ihBe2BWc9R5rMTk5xxFB2JySCOSBa3F+JtaVvDzfMb9z8pXM4qf5mF0n1L4gZODyvEWR/ErlxcAtWKzUuENFpxXU2ZKXPcHgfvNpsOb1AX35uVeNXjMoqkaMXuEM86qbhQzQ8wlba0PmVWASa3LQOgKr1C3Ytdn7ywYAtWswQ1hSoBi1FRACzlq8euIZ3BY7f4lElFNrpeINp4FV8eYgG0rf8AyVTdy/GPiFQX8mIjjHqpTS5wUhvD0kdgTs3CqqIdXDIFcCHEspqzNEGyUZy4L6jjj2MWc3UZt+8eShbeoYOrsi5eoTS4L5ISgHQd+ZqQGlykotmuXxM+Dx46gLfhm6ccfzDVkLrNMFH+oCDkzKWKxLCC8H7RM8r2wTKmfEXRl8ytFE8EyYPwlBKISsMCtUx2TNreW5ldnDLHciwYmrWuSNrBwHmtRqqRADxGoycDkXzEBjolQ+HHqE+yZgHHgiKEBhrw9Tg6gsfZCMNFAnHUFf1D9XTKuH94K2jsZWkh68Hcto0dBUI12qkPEONilnxcLDJ4isdLmAdizSQHyTBMQ0ADVOoDIpWiXoBMqPUAgpixq+pg4X+XcYAvLvEGjDazGP5jeoaXsgiKkzTAWShbGjxLsC6F8+mBI02ytXzZ3LyjXAfh5IZzLdz3NW7DacwBhWepjS/dwRwROllVOL6Ja26OuPMJsLtuHxONYluQgS6gHHu4uGhKF67m9FWH8ck9gIt9dze25YL47gqLaCDkGCCZDzKhIp0TOBeQN2eT+YCjYIq1qvERtQFvskQAFDbh7hSUsqzfyxdS5LXgYYeymNP7Zmix4HUetZLCf7/MQk8lS4WLDmI7ayx0LT6lIe5Rg+SVlOOY0rHzKxl+oXd4vtiUFiwLZW9BFFiMbGoFgWvmarV6idMRxXEFnkQn0AQAljmpd1tIPHhHHI9C7vcQ1DpdyqKLCrf9iKsC4vRcwM2Zu24IfqytdX3A3LOph3c4N+/Mwpl244lXFgmS+otkJWDEAUovh6mdNuSAaoSpmwqklIfaKwVniKa54ephCLbGjxKRZrpnEbhow24ZirW7w+iNZKTjHJFNgKwvMWkWmRyPMt5ly7HquZkHABdHZFLZ0dO6iOBgY/2ZjWYGqGUKjg0ouMlc1AMADmKgncOvfiIsQc8e4iSrGgL+45SUFqCZM3yLnyjRpCVapJh0LCjL1NgKnD8kp8hQNHbcBJwMFFc5jGKWqivvQt1FiicMoxqEYUnCcWwXID/oOpkAGxlguxRQbHxAHJOKLzxjl8QkMEDb+R5iXn8QCLbR4aPU1t2/maB0g6dcyj2e46svubBDBvueHu2ABStsDWFnMCaWnBKvSzzMNrvnqIU4fmHFKdYJgFWxDaDOVzAdX34hMXIR7X1RFLgFo6P93MKKqzKLIHETdcjKzKYDPSIOQiN4NHvzAN8QZf8A5d8fMNI3/wAizfzwxFSfGmWIDzXEGx0hf5jFAKeoAW3WqlqUyytDq42HTiWFRq9Zhey/fMrxH2E9S8VVDqIxWdigW7gcL4gmVA48RoYGmOZcmRsYuIiWzT9x7I4S2OQsGQx5MtGD1A65nIhYbICOFZpghgiGE/IMvyu4pmuvcwuI5Cnb4h0miij8MEAAOCHRYW7RqY1BjSbRZ1daNmChWEPoF1eLhBKb3Qcx6ojQVmPUqdrxFDTgnaxLKu7rmNxsKGgfcdAhLOwf1OCAAByrpjFACmpwR4itKs83KxjicRwGXrbZC8/37moV5RNvx3AwqjxUoxdwG7N+YHaepyZ+4BV9xy5VwGWoM+2DhPYTDpX1LWdImoVE4MKnnCTJeobfXEEK4HtDqIAwUUFSiKLrAwjoDU++ZuChTStSiAzXEr/E2/8AhmP9QebxF+epazVnJBw2/ibQXPf3KVRXAMF8QUJVdkIAZOW5yC6vccFN/MoQ26h5LOGJhmJaF5SDpImK6O5iRfuG1lszUCKljsXmKAvuyWJRslpYeGCzEGzYlOSHRhfUC3b2j+06Af4ivEoKK9P5mZQU2q/f9QHIFlHL0TOG+l/5csIDWGWVVpRruCb1oIWPcB95XJ88iI3YusA91KJU6Vh+IxkUweTxM7hzS5rmEVQdgmF/qbSUtUfiZSNK6PzE7AAcvnxFgpbH7uZQ060wEBoHYeVjpcYuM9XK8S9l6ib/AGuJ4PiUH+UyooXJ4ldb8ASmvWJQIm+oL/srmY2re4CoV8ksU3ncf7CxLOceYTh3DIW+eJe1ZuoR6sqx45r9INBd3X1CKACwN9SvOO5dbj2QVFHAuEvhkMQVS7ZhqCH62mf8oL7zYjXqUb3NB7lK18zIOPhlahaDR66lhAW4R/EFLGLxRKFebxFoOar6gAaV1C8nnuVXlfDFaaBxfMY0wfRM0BpdQVjxiVix5W/tErQI8ARpFUwHfM0w850eGGGytH7MoV+7zLbo5grOoOYphQ15qNqiWbHzGL0KUbYmXOwyxBbI0Mp5J8giYp/uZclpnYswKvBTFef+Q7wrbS/Uoy1NbHk9RVcSWM+EmaA7LZ/qMUPBB15OoDtfUF0V5JgkeoWtf7cvPBsTTpmbkoyXp3KYNBYvzCKRGgw3y+YpCaABv29yv8Rlqc7YDUMA0QjV9e4KUvGjqUrH4e4XzpzGgosQBd6CUpdFVKYF44I2NYp47gpH4IG2q4iUpHapSYLnOSATGcmiXUFAycy+hYgSk1s6mhGCZfwWQgcxLoK8whNDqYegyuPc+6NlhC/0Lnj9F3M3V1mbxvzMFvuCtJ8zs2+oTg0ByPcSqZDzMABQfpPYTUAPjtEwZLVRL0qyXRA04dqQ2FtswDQLPMspYviYuV5gUFvdP5llRbZExMoA0346miAwUUXBQGtZCZAa6Fiht7hq5eOMdnELQIgNmI4Jrz1K9uTbzpgS+ss+CnEUsDaKxz69S1iBcmXB0Q8kcLBOj/YmrSKMrhqVk3b/AKZlUBodh18wgUDFNcwA6McuIs5+5sp+4KqDVtjXiCBGzIbBBQ2ejUHagBVwcvmK3BotPiEQCr4/3M8/oU+nULKImFzIBKA2Ov8AcxwBxeauWyd8yuN+Zld6iVr1Kd+CyIPYahXD7lVqUGrtZQY3/EKrZim6lRkIg8h4h4otpxyzLgt2WvwxnWNgG/MFvFynXwT4l4hsPCU+Dc1IDdYh+oT/ABhv11BY3dVVVf54lkLYBVpCuQgVq/UVVqy108MtfFLD95tzjuaLSvPUyIXy8waEQeglANKdrslHD5XDI/FM5Wg0cSrl0dQJWe0upwzdygkXOaYHiZBXwA4TzAaOgBm+biqg20Dcqqc44mGN+4lQU3ghpljuhMSWeWfxDtBVZOek6j6BS2uT/sGovKVQ+YbfMBm3/bhVRG0b7PcUuFqscHiUuRh7PiISELVmv8QjRXk6ldVXc8vqGA7gY2GruC9hmjVd+GNWC6yXTyPiWtFiGvVxOFa3Q8Q4Tz+u/Tgcy9KY9MQZLst4xxKUKHxDB3nTKvUrOKiN1RjmViyvmIgjXxEXL3MaJRr7hdF7G5RRhTipiqC1VhzUeVAqzQ8r/uCxMnM6R5qJ4CaDB66lvH3HY8bqVMPqG30ThNSVlYahqH6dPE148w88C6Wv/Z8Jm3JgRVpn3DWMy1koe39oBDJQH+Zln+iHoGw3LKGXoZ+Je2tBl+eo5B3JYkKAWaCpTUW9EQeCO1w2ZreKIBASnUAvDpSx2rKhANv8xQdAXXcVyOwNvzFQeh5n0l4/qVxxMFVLYrRywLNF9kB5U8BFQbc8Shl9s30R9oHJoZRFbNr8yg2mCrx2+ZZAWC78krwBWpV3Rfm4LOw6lVDKAbPxCqpWat/2IpUV0aPfqVWIgKU8ryRBbvD1B5J3MLRX6cqBn9k01rBUbBoju5llW2VkvDDGD5m8D7gcfvAGD7mSl/iWMxN/1KKo0aYCl04COdiLf5/yDeE2OQ4/3Mo4isM/czt/O5X+JXH8TXshKDwk4zQiQ/8AhzDV1zzNmTBjx8wc1HTnNPUtrc1kcRWf3/skWwbaFnaZhc1tip3bMdBuxZfExQIt7+MRhoroFBLkFRhdXo8xRV2C1e+pejYI/cqWXnFVMsEWmD4AZtXHxHAAUS8tnUaQejh9sWmLL0GZnFu07ip29kvDZCrmFZixj6mvfiWu7fqW0c7yjaKowD8wwEabx6qBhsDhWXGVQd2QMDPglbN44JZlrPUwd/EJeIEVp6i6fqCi5+Yy1KbR47mTpsD/ADGRF5Ei58c/p/HE/CEyjA6oJfXMBk67gtae5fFY1bLHo7mhcVHO+sRySqc88zwzMLQoNaziFaAc1+818uHMfmwFUp8wojRZseR1BWLoFWSsTmc3mDNtWTOvqa/qfp8x3L1iY9vZOk0StxCsZtOpyUb57huqMUje3TGvuDYVbXMreYsauEsUt+3zHARBaqKoBwHCOUGguZzMEy5/xCpJjY1jwQNSlNnjyQRQoDhvfuaKudVT76i7icMPDuNYDQ51XbzK2Wx2CAq8a1cpAEt4uBjNeZk99wZ5QFlymGPmBdV9QN4uWw/aI/8AspePmUhu+AlKSFbzUR0vLbHMG9sMa1XLMPH1KU/kitj7SImeGLK+pT7wee52vKXF55nMr6sE4DjmMAdUzLHWl29SzXJBPdSzONxx0RRSjU4yGYuClOYgZ4hIAZ5TneS5sV/BMPCNMfUAA14p8wEwXgMfPcZEtk7/AF/GJqvsmp7msOf1Nzj9GX/Zg8e5qyuJi3UaM6bx0QY4xyxBTX0hJHCNVqKjYXaMSuAGHPzLyRgfwgMB07FSmkdjlAxAgeDoItwmBziZgFWI3KtRVoHLqMHoOow0WNyAynqJiG0XtE2Lq5Q2RvmFZi/cvtzcy8RDEyRL0RqCteKlEpqVoagvO8xevohIti2YYOq8D1DALeAufMCqcHfZKRvbomORfSygsY4GAhPkFY/mYFA0qqYuUO04gEKyFI8fr183gQYPzLvZQLlKzuXnH3NdX2RW6+JnDp3LV47IWYbfMsdKxzDGKw8wb9dxTHaQoGMxXdwSMQWqxuAgGKaUHQvcrACNJ+n+uVabgx7g1KgB3NZonNfqE4jmbVCfXBEvFw34k1H9pgwXBcoKOOBiuFWVc8EBFS3SrPH9w3I0NSijwvp/ECbLaqbuupkQ8X+XbHMIqDRKskNL9vMtA4A/BYHBKLeGfiGBYuQMVyS1gA5NkU22ggVkefiAgc+Euhc5q5gaiU9cTUXRzEcXXmEf+Eo7mTl9zFv4ZSPPuZDaHzghpkALVaK9wVQy8NfCwuFmg0TWDyFm+oQoOg/7ccGwCKkO1WW9MJDc6W/PEFWgGzc1Kkyalt1V3lxKO6wZefMwu5m5gW9tzQhZVbqm1l2rDBD/AMmpgaYAN/hlFd+CeBfhljR+onxl1Drt3HBRmuZWl489Rl9QMNdNL/Mt0WwtOscnjmbSBS7n+9z/AFQ0AFD1MpBKGPN9Q7n7n6Vmah8+5WIzX+Zq1xLs6T9EKkHTLIviDHw+aZYZZqyoE0CgMPZ5nNcLPERZbBW+WYQOuw8/E0wLUTjqM7jgZidmAvrzLwFiWtn9SsIiqtKf/IUQBak2m8TCALm9MajBHGzuWOkvTHuAAGxMFPE4VdeYN/EoBczkmjX3GhzL3zCr34iZKL5hZ34xNkL+CCARhYce4l2janXh/wCcwQCFsuiCQRwQmHxFOSRrpzMaSwSgfcVbS5dmi+5eE3hbXnmWwpwVc/MUIZLT6olaAYHIemGBa2ij9R/y0c3M/wBRltdXNjWNwmwWaTsZrkuszwZnGIXa9VE5/eaxoeZxz7lKGW+YKEv4lsDxEaOOIih54lsxqP8AnRrYrVLmr939X8RRFCG3dz8D1MtPiPJCb1+r/mOoMIczShSjdIgywxeY7xrqO/6nAO46CnRkmDgXsJ18Td6KXZ/33L5DpWvI8/vOtjsfqJaD1gLlqud6rsIZa0AJdSgULDse5RuAcpem397mcaJzx5iNwyW5lylyDYSxAX+XmXRlpwQ14TyRlgHhlm2DEoZKb7mDGU4GrmYbFShtjWqAliYqXpLDYkRpwBsWUbsLruCRCWZVb5l6rtLsf1xDYx6SNoCwjh83EJgFnJe5tQGRw8+4uAjLo0KNV2hLIgBZYGgBWjubkDRkPCHMuMtCjgOKOZcQEAT6alFX0Ou52Tn+5rDd61MF8M9RpjZeYXkjG4UF1iLs7rmX8Qa2N8xvVEs0wQpaVghP3QrL3HtoU3LHkpQ6I9CH6eZq/f8AXnvFbZYgiqGg7n8ppHddzx+hc37nSaOJ/p+lVXVDi54OKzLVlQqq8kqrwvc1demMC5DHf/JeVVQKD+0FhYVp4iAAnIcfMNAJlTKQmA4fEKhwoVgsIdtcCcV4eobEZUuKfUpSpgQ03yyxYpww8yfBxAsXdgQW3ZVWSxShV3+6C8wzUqore8Eui641cqhSr5lNHPaSlIWeSOQPPNzmPCiOix6e45YckMnruYqW7FgefMbNDReCcD6LHQhxRqxhihisjyl9sGoECGbNkFFBNAVEFB3QavUvAqMWU+50waHegihEBaNr76jW4CFXLncppujFT8CAyNFPmNFHB5ud3y1N3WjniWDp0S7oSN95jzd+hlrMa5iyoy9xbAo5gPJ3jiG8n/JiYSqLdHcCVTWS3meTg5lafx+pd8Yai2bszU0mkdy4MITaN0zVO4fvKv4Es3dLxPaXw5Sd6c+I8J/EpipsTcXgCNEtXd8yzyQFJ6hZk0K2S45Bb4PcV1o1R9JDiyHLAZK3VaiXGwm1t6htCl4OK5j0EsMLf3EXkezmJWRcWGYbAMtLcU3BYCmvMblzrmFVrCcrC0Lt2zAC4rbEhszyEbpGlLddkpLaw+RMkTg6NHcwSBF0x5SrI0jrz/UIKLZtXsxUFLBVnlAuBGBYHFQbsy4OYl5OzLkjKRAVbtKQaBtaILUzdGjuN2aMAY9x3Kr0DYSsDdEBkePcAiA7Wczl1rcvyRq+pNydalNI4HzMVv1cVNFo5CVhzrKVPB9Ew6uouUG8y2cb7ZjVfvCwP8ylpuuQjsQrzCoH1W4fqwocwWyOTh6IBcbWVzNEz+mX1HMdZjZxNajOzUJxD5nceIz/AFmMG6YwEBgxMlWuHELqZdk4m07uf+tlqNUnBj6jUyxakwTIQKW3qiNsRQwkuTDC8Hl4gbzy7eSCGm3odxFtVniYwU4TovmFyw3t+ZehyaW6ilKswIcSjQPHiILLnGXBGMAO6crHNKwaePUTK4DekTZhVWdR7GnCqeYUJkHZiWqhZWCGpjDT1DRtU3bMKKKRvpAAQ2g7dRzYrxhri4AtMeCU09hwrwypQuF3XsZWAgduyMQKyo7IWZNIts11YlGWjzHMUAsGXojGQaUFafMyEXYhpvxDcvoHH+5ldSuSO50/MbvFTBPDU7hriG9a19JbdjfMeSxZepe0NuKW5hajPJLUKujiooO0lmUuuZS6p+ZhZ9kvoSZTmXhs8xGQ+Flh42TbqvM+uAG9X5/eKmbsrqaE43OfEPmopm5jSfzjAvx+mZXW56/Q+Zz8Q49zqcBlyN5M2zr+xc4HqWEfzPIKMy+Tk3MsLu1e5ezFGiIIEmUJxZ2SqRy+cEvgMg2ByQuDnZMxUUPg+IzpwULoeI7BW+O0uSzYQALcjtD1euBLIaFlAAVGwZPVytwWFp6lICnYMZ4jC9MF5JXBEpaYvk7tE0Rco4Lf7y8uqDr9pQkKKFYipQUU2PuMVlELX8334jiP5A81L2UEzbvzHXBZs/MymLSDH13BRgCrKc1KyFjReeEIN48nJ6fEIhPwUfEc2Aixa4XTaqDWtVyvuBTRHb+YKL2ng8Ee6ABRz2fM3cTPPxKU/SI81QXgLvl6nMalIM0tr1KvML0qHhggbseybw6IxcFQfkhbHnU0fi5YGH+xBRZQNpx6lzHmPyeZ/fef1nTEnqJT5ifz/Q7hOI5nuMAk1XHuZVxnmWUpVOIqAfmU7+4Z+ZQyfEwtzRN3q3P4mh2fcIYqhxC2E6XZKosTV9S+9W8w6gNaVDqda6vEtFproS1GQ6UN2ul5ZbbNu9wg5OyZ1CcVzDnbQloS7AFOWBx9xWgFideoCHtXZ1ELErs/vMLNnJ/CIwKny8WdzIzswTHxLMN0faVqMFHBX9xIICYTlKU2UGrz1BACluvEsH0Vj07mTsWumd+v5h8gvg9+YT7AB/1Q5wD/AAEyBwVYOGDFtnqZ2bJrG6YWAtTRhXV8QahRoO/Nyq0UVLvxB+/0XOMdpvfFUSpgtXmUNV8wNrfRMNuOqivC67mWBVZqsxZDkcjHIHrkgojmLJxM2FNPcOYfqNjB5QMXCWr5go9dGaP0SCfES1oYxP5fo2hCH6P+zHOP3mjzLbZw+Ip+E4MQ8TiT7lS92ZVKAsoZdmVxdXMisDDnUtALAZBdvH8zgLhDe+5/xZKMh2YapLV6TuHE+ZgmTxLUJy4oiEwDyzO4EyMFhTtMC2Uo+5fglZL/ABcAiCZ8XxLORFDN9Tj4ANn3LyL4FPf+3Fa06zqGoIBA0Piu4Il8Fmg8RzeLWOzvww0IOA29SgXYH4IwQ3YwW7xGR2woZdRLgY4uWgrvC3UCg4O2yKEAoisZmWSwa9wBgMK69TOvTYUnzCOh6DnXEGGVxtncw6W0t8UpWuL/AIitjrnuC777Joi17Jtrh4gX4vmFkiNcR+r8xYXrVkHgv5gKc3imYqj7qaoKHEIV3mkOFtYnbPV8JlC5xX5hn1G5zdNfqbQ/QlR/zGavHmZCNPa+IzyNXC7zEC3EEozkagyfJLPGhRbaqbnn+EEKUKLx659QynLyVx8RbNBoMb3Xz1CpABV6cToC8P3uI0aORicsZ6gXWO4bAtvE1ItystI5OK5gqBwpLKd/Mq2NDS9+Y4JvO6afEAinNhz4jTcKlnbnEcsEXQ3nquvMBAXIsf8AIRsDIFr5z3KSc8WS5fCABU44GYKLDRKGm/VxC3bR0PmCBQ7vXwxzjeWYi6tsd+UmVKaMlwZAchp2dXxEFXM0GfmXsGQYjWKGmW+MQC2wBwdssY68yt3MuRvibDGqm4bKMeEnJUp1m/MoWDPRFsxeOJYhoOybwrHDEFAuHiYZsz1FpROKl0aq84mQLwrEzPNDZgKIfL8RN7uNaOp/EKqvVS1LXGJp8zjEsfoQmJqYQYzHg+YzwxRHB3Aw3ncHHXiWvHMzeKETWurUI8hpUuG/qdbyfExAomR0n+5ihFdhbtWXtFlvEbDQ7qpVyqFtVz9wxWWmDaAo96CFO6b0XAyetkQoSuQYtaz0fzPGGL36+JfQVyc9ExBSbHHiot+0XL8QwBXnJH1GYNALCvDHiBzSN0Rc2jFWS81/syviGGd+YIUgb5GGVAgm1u2DYqCsA8wIvPkwwl8vPiOKCA5Go7LctDDys1ZwRzVM4E1coEOVqgG4FEV8oeZMt1zNKLAoOenuVSG8U/v7nx9x8S5RW84zrZCpqoEw4eolVin7/QoNmGYG7v3FHOF8zWNwRLoJkJWssBw374gxVQVwuO4wTj/sN3HP5Jo5vkTL95NUZ0Qo2C1L4/GZ/XM4/qaXmcwh7/RmXua3OfhlrAtLBcxE0axAVr8RCGs9xt1g9x5eMA6ie8IfEYgdoalinmUsyHZmxiGAQBTUz1WAj8xpM374YEU1jDKWQzuuIDAvx4mi6fZDCuXkCngjYo54JuGDGYJZpcygpEMcXF0V4ExMFwyrGrDDNykKqCy2GW80LaYyycGFMRwMg6r+ZTV7hZL/AIjlLlHLHN9TApp6W8RAsoNztLPG/mNURZt+yAhA0jlE0Tg4ZPTL/mBdPENkW7DBugYwgnhIodrj3LMApL/7M9rGbGuRU+LceMGVVx9M4TdjMugvuNIAqt2wc0gETzmJTdj8VNCseGBQo+EVgzXmbD3sl2LwWNz8AqFvIz1xq/Tgg6Rp8E0r9HODD9WrjMrevzOIab8rgtMr2wVgX6hhn0mVYTHMBcmpKWs1+6Jow5muvqUueOsyyv0zMb9LxBkC0BtwwnDBpIqsC+IVN3TlgGRDNpsr6jReV+IqlGPLDJqx9y+zRzc0DXYy1F0bdwFWtHC4gjI8qwVLimUYqs9WO5ZAvnDMenZlYQ23IDkNY8xdxyLy3RxLxCgAuT5hPAHydQxgOxjcOPc7G/nxCMFRQd+SJGLodxtmw4HIzLCheGKioDNUHXxFzCAKgMLFWvB0ztgKHMTNNfBHnX1Dm8uZbCtm2BvECnMGVtFiMTlu+qjT37RHQebicj8zt8RsxX3Bdh+J93iDmjNdTFHWapllitF1UefnQzTjoV5TAfp1OQdbjMvj9PGMIQl4nN/iOp5/iXiW+VNnRF8kNXT7i7FzNTITl4mAF5YlS8RIFD+YMnQiwVqG6dkwjIB3+JcKHCqqXqsGeJnHdzIkKc25Y1q+NrBTY8ymL48xLbAL4mRT5JShAy4WZd1R5jaVg0ynII64i2wPnv4llXlerxGwjXbGkZqiI12HimrcfEzgA6C/Q9RtQASwdYl7ECwx4VMhFDqWULVpL946mUuGAar+CUcGSlGuPcbWlUUBVHay2g3bsD+YmEtix+o4A6DEdZwQGXmpekRczR7/AENw43tLY1VDBaZrOfHMaQ21nLqZGMl3/Uq7W/TzKHYPazbtPIze0L0sbwu0m38xIXx3OGNZxzBAyPtiyusxm4wE8O+U898pkEc7nMdDxNGuIrWc+P0aQzCENxjPCGp9ihMObJz6gdYqAcH3FdhlNo2litIykOH6Y+tK0/eY21XAxzFwsPEDRt4JMuC5arvBxM8Y5HKZoWUvidNniojT9X1GjTdeZbg8lwcXZb8RFuWczLYXUVBRyTmYIdrcSKwpxxcFpHpeJcxKq4rQL5c1zDIQLQjlOmXoFDFDp8zZ3q3Xji4ekGqRinzKUQtVnfqZZArg+yOmQAYN+cRBjg4bQFH2GyNTAMUsB/iviOlwFFfgFcy5xlrroI7AZc5nKmvM5hw4HMeVVfQRqqw4l4z9sXF5YB59wvQG+H95TV0Y5Jiaz0zAsLcMFsMnqNheKepYWol58n3OP6TPno3Fg/puOpzW4b68b8S1o/slFrcP0P0dzlC1csMdwKfkzUWU5uDlYzqGlLk8S8ArPMTgcHPqPJjCNR3wvD9PY6gzkeiXaFK6FiaWVlM6jtzKVW/VeIbQddncFbLZgkuIVlLb1GbY7F3MpmEuA4fRF0mEGss+JYKnzLC3GthFEpWjiBQBdbWIX4GcAXoNTfu+CJLCvcTTlqm45APNpqGtAYQ0c3AEtijB8eY21qcB8eCG8Dw4L8QLHoAY+UthyMJx8QAoob7N3FLCxknBLXw5ELBGjTFUHAX+xFQrMUWvMSsHEdMDZsHZMQ/TBqGFl/aJySnEMGlzuplLD8y6RmoK3zfiICkKcrxM8aInKnzCEZXPUHYcvZF0SjcpZe9QRDZBlrtfymWr0lD9DuYYOH4mHnqaT+Ep/wDBGMxeWDT+MsYuLdsBD8l1BRtp7jVbl7qX7fLCkbMgvmVO4wzHYc3TUV8o2uDyNSrZSm3EqzBjSLq43oZqD4lyoeC9RgL/APYbM27WALNnQRsACUfyilSrdtfvEnDXTBmDLwfzBjh91Ktj6jhozUFAVDFQtDSHKMcCPzAt3ZZuty2Ii8DDiDGYjA+0xMG36grRbm9Q0CdGVDSCtJm3zFEA0walCRg12IKwXeK/eJogKsMfCWIyO+ZVNwyMvKwcXxG0BVi1eQeYBdUAIs/+xx/2Oo8Xamn9olKw5IG129MMrQ+SW1tviNr+dxXuz1MZ7e5ZpjHBKUcC8xWgImqcQW6+SLGDByERZm2k0GQe5vzVmw2fpzNrsm2XxiasPTUX6EuHMUvcV2alml1cGY0LMVus+YBefmYZ4gHB513Mg6MtRXQR4jK44wP1MuVcLuU/UBco4CWYBtMnPoiEgFstvuKwVptgLVrGCEfMIoWqZleg8ouU40bDh8wzGiU2cX1A0PN6X1M7WtjcsAXXhYX49yhty+olABB/MRSBri0sbMeguFFWa4WAQ28hhuwK4OPc7ANuIwKMXxLGTe1Jlw8ncvVjbMF8GQd+Ytg7KrcBEy7DUXMHgKsgqI9w22nZ2RWizPA1K90ax2J1D9Butjf+5iC+OWOuHyTU88zBvMJdRiWRLp13BAqCrbWYOmWn/Za5Vc3lS+iUo29MLMGWOFfiAVbTOBlmHP4lp6w3XJBjL1n91LP6jqeIvpfpPHMpMfrj5jFM1EsY4i+BS9peFh6J2OH9Cmv5ivMwbE6jpsIo3+JjpCKdH31MItjAF5eYxTlcAHQTMlB6Y+19zKp5w1Fo0gcPcWiZOpay0cLfxDRpkoAi0A7L3DZbRau+gypcgYE2xnxi0wwdK7BmEFGZdf3QKptnYxGMFeiOSG2r5ljho1EOPhnJT1A/BAORwzLKQ8JcbKwmbD6Ed5he6x1AVac8JqMEDLarBWClcVHtLN3DVC8uXiDlSq72SpOXJhIzAr0HleYKiDVnT/m+JnBgJeJSxytupodv6ZZdjd7gjV3LdB8xzWcnMeW8s24mB5lGXPiGNfTPGM9Q1TxA2m3xGxrVpxLXwMKHt5Qy1/c013zMM3Gph56IsX+ZhKDD+p+jDcCGdxSU4gsqnjPqYy2qLXqZCjN8TC8A6GWaAL0tZitmbq6de5t9JVL4z3MaQlZeFP8AZmXIXauZxWfPmCsvFVAc1+JxgZzLcGBzBg5ckqMl1Wu4vAaagWANORZegbRlIY6JWfCUBKiuz4mltTk7lTd3mtQRa2H3EV5XuN2rYdQJx8ksQkcwXdtw3G2hXxOgtNkswLOW5sPzFgbydkxRdumYFp4EpNp4MurbeUNzZXEoGVK4QTl05SLlaC0g3EBMGUN7PEA6vDf9Q7qEMpIjdBbgcBcvmV9mriC+JXycoAbU7jxOBy9QzR46YC01nUSIooNktwxKLv5IYf7hMqu/xBXQu4aqquNAt+SI4ETY1FssqAr3xE7mdumefjlPxozxFi62lrXjE0f0bzPiXcJcYpdLgjyr5IYaJibwrPMUBp9VFHGbcsLFq6wbeCYIQpXL4PMwwEDB8vmFXRg/E3VCniWAudVcS5VZxN9PgjtMuKSvqCXu3EpfOOSCpqsbjzeWm01E0We2WoLfcrKxdOz/AGJaQnkt2ePHiLnDIDb6ghvhYLZ6llEbyKc9RS4Re5TxdcNRKK27ZdKwlZqVnN/JNa+5hfaIlJC8MvQ48kWpY7YlKRa5YJ0ZZaFBm7iLdBeG2KXIUW3KRZGaIbeAihoqMQogONPIwQCKBy1mM6FyuK6sVywoquzYceyLa/8AUCO4IsrgftfBHaB27PFxeQfhBtOMmiZae+YlPAdygYaOo0yfTAGkz6nitarzAAJabzFyDjwTDkLvmKby4alzjJa8XBpWRah5rjHkmyLP2Za7xNfcwnKWmoQ3Pf6eUOMxwy29/ELRFZq9SxHCrxM4q28UMvdTXQ2QPKcMrtORwOiGqPqpx/UustFdMdde5SUFBaHBDVgM2zCFY0HEFLfaNvF9TYKolSp6LmI7PFQHbxHyI52GWJxrtV13UpAbyF4SxVZp4gIw3YwniXAKV0+IraybTUpDxlSAVhxtJYC2+jmZVxvhNR2KG+kC278sAxZTxLKgU8QQoMXNIqnADlgVCl2CY1C72mTNrtf7Qo2I4qIS0rTG1JFr6pxLRAs6b8eIqcDY9RQbXiu4KEQcLikVmllRLoAwNN9nTMLchVRxb4l8AVdN+000D6Sg3QHDuVn+FlGjrgZkyXa4Fgo2F5piHkXFEMhv0Es2YPMc6fqcmD3HADfA8xxFxhz5mXfWpe7mc1+iadVGCLizPVTd4PuOTNuvE9QZ0/XRlRw3XEalH/ssRd2tgVrLTg0PDGCGwK3Fo6Hg6mdGWGN88XKpD5uI5+5Tg9lw3UDJwA2dW8VBIANtML1HMRzxUMwrL1GvVZwhDbrHUW9KmFGWtZ4mdAFrycSq1wyJ1MizqEOwVSWQMIU3lZ/UVWmh74hgIsHF+5hYI1jjzUuS3umWKPCFAJ7HEpRi3uI4Z3CgHLWCcwgxVEs/RS5gmFscLGTIXS5PcAxDW0IrEpm4c8pcQKF0ULjmE00tN+Zh1TyZerlqBb8ITkjAAtvYHh6lVN13W4dC05dysBZ0ucMr1hEWQp2GF/qXqbZTA6fUfwBa0Z1iAzbK0DxEYPGgjVY1xZH2CjQPMAsA+E0oDtMag9MPqDBNN/KA4UYedeIBcX6Y0spZxH5ZwMeutdTE8+ScXHx3NW4pR3RMvIfo5XLEhB/+AMuPmWKTh3UpwEG6Ze/Q5UvzC7PAcj2f3HAhwmw8Eu+5nxmeN1zFr9qhex22zolGVQX0c/8AUsAK2uc3NIs4zUqy5PHMRSO7r5giVlmoqqvGOJYAxfmFWy3i3UA0MZzcQCDc07EqiHlzom2CjQmvMc28FZI8dgWH3CoBZXTyggG2Ds6holPXNy6isA2gMjTmoBA2X0lys7cwRqgS7qZBS5rzAoK05tg589kycKebhBCkzcBQuk5COrsu7yGjxBQ7Gf2neAMDfn+4i0zLGbwFPX9xgjWP3HdzScjFgwAyvTMryiu4EB8hILe1WkuuxprIdauZlJKWP91K/SlW0F349S1yjwPqUgNKqcHlJbeHowukDkzBbRqyx8GprRWch2TDo25NPXMuTalqb/qWePibTQql47j68FXc16nSMPeHVeb7JgMa4uJY3LXif7B/8maJhrxBhLpZhmEodaPpjSxy7NNvcRclgXAQSHbd+JwVfuXXA+bmUlOjwJUVFloKzf8AHUEjD6g/VaCLYCnghqYHIuZaFK3VwUBfDwjwN3zBYu2uIylN8Erkl+IW2fUeh35mDHc8v/YTJqsXAMDQ3+WAXJ7wfSMpAww3T4/uBAsrYyieepXUwsoMHqFRXQLdwMQKyJtghRea5i5IPqI23k6g7DIeGBgG85AzOjRwxm4dBuBsTVPuGQqbaw5hwsbYBWPMDNoDq0ew8PiZEWzMzoMtazpOTzxDDAIoeBnrDK7Dr3AYKW1iL5F9koaKs6IoGCLmZQWzxWPMAQLteSWho7aIw2BsWPxFFCHBrEUBToT7+Y9HOWkaqWiwW6ItSeT+zlmIbZkWckCENnA5vqWY2L8viIYmbVcr/BFlxxjF136jp3Uuz5ilkE3+Kh+mP7istwnEVC6e59oFDiqjjANNS+oTQNBo+JfEM5/EP8wz59RbeK0Mo4PE08ehQ1truMxQ4Fa6RqtzljjkrtfEDJfe2HYaBBcLXhqJ0L7MMAmawIVAgXjiCvuK3d8RjgTYdTH24qISzMy4lDWT3/UXidB/l7lwWK5Lvq+4BCtCLR0dTI2BjYeIuo25G1cxLQHfn3LKByaN/MIAp6s3EWvl3G1Dh3AG1+LlCV+SN4pPZzFRYUPEC+DT3CquApSvHiGBpXgH9TH6JXI8+YgAzTSZKt7mxa/czYNQV7OyDn0WCrHKdRpaFRT0MTwNU9GGKCAUAtGh4O5sO3mAgtHwxxbIHT8ygZA6Rr5IhaNHSStCE74TqYC6Fr4hgUBXK/cBpdsAuP8AsGjdm0qvBEF1KysHXqGuJOa3/bnnHVPIeZhSDsWS/Oyc/Vxb4WLmJddPJO3ggYPU8pnwRY4fU9zwT1iZGvmbYL+YthKeVuNFH3Pv4n+M1OnXqCkE0MU/iKSGwCvz/EMIEcj8RjkE4CC6+Vyhztz5lqqLHggw1j3zKayVwEVN3jmM2V8krL56gxsYYKaeal7F+UhKq8avmUmvZP3SlKjax1B4fLqI6Aq6NYg7lM1lU3wOEPykbFIXinPmoyTd5UPxE7zvuLaXjhjbNtckS1uuJeMGIJk08VKZznZazM5STm2MCsAUYzFRQ99fJDMbAsjx5mQgAA3mYduYnC/RMjhrggorOAL2xAgKoyeDxFgFn4EefcdiAYLENv5B/Ms8mPIjSg4ILXyKIrQSjSwF2HIYghKVaotllKY5FuK5IpfglOXi3GxgkFG+2CXtJsP4lCVQyLMzGoDhGi4MEdDtA669TrQYB8QIhCsCHHBgGiZuqzqOTe67mVA33PCYlpv9O5pO00Y+4/4h4h/qlMWkoAFzksDDJX5MGzqzYNM9wKpDFLfkJhKrvJDTFb5Jgs+FQ6zkrmC89auELWo3YwWaMzJWJgHhckH0AdSxm1d3L8IDnqXKgawN5i0VDR3UBvuGjEX0bXa6lSvTQ8xiqbZpwcxdsGw4jMi6zVRG1evzG50DO54GeCJtauopQjXuK87fMyrdHLNAxTgJxWeVajzbP7v+zcNPQ38fzG4LO77mKg/Mtdv4le8w+CDlM+/iXKWCB+WAswV0dJAVduMRfJzL2YaWB5r9oNJlNj9n9SlEG+X9omy1vN6g4qnKiYGxeIgAoeYqChZAZ39QTvwD8IfCF22REIvJXCygNHsRFqDh5uLBgB1AKadG8+4HEbpU8l6mxKQXXdx7MBYHy9ywIC0VmUba8zTHc2/xD8fo4jA1x9TStv6n+qH+IWmLvxKYq0LLvgH9zKgGjj2nLLgNIHZY0dmWK1V5EyPwiWKDmoQR2eZxG9TfY3FgKYcWEEyvOcwDYGu2UPDiL6cqgPI6GLVizhP3hAE25bhE42qLafmPhfVSxiFKg2lWywyRxTpiKXPVVK4A0aPuYwFLQrM4DMhP8YHIvIptmgrOmpRsXpIpwctBf4jNShmzv4gQUA5CC312Mqy3fEEgFjd68yueRq5kef8AcxYcZ8QzCvghrr3B9+4nj9osAGw58epS6hTZlGMBabeyB7puFlvEDY9gMnXi+5SgwFbH6gBQheK5JRpttsK1LFsUbu40BprU1/SLkcN4mULfMQAs5O+5UChhHUbazNNkByxTdS2jo6CWpAnm4WK0tgGiADKmVdENmEH8iZW04aIF0epsEqtQKhuGo7ImC5ae5qf7E5iAGwBIAw5Q/D5JhYg6MeYdLDaDF5qdS4Ro2sJKnAGKgvdYYHbEc4I8j44lpz3HqnEqMK7/AIiWy5cEKga9wCGT6gDoXgIMluqyeYJu1u6vUYsh9RHXEwbIr33FdGWkynBJ3HgpQfQWUHQcgcoPV6UF5iIHEtr1GnBXAJdugM4YliqGlDFQEdubhTw1yrLCAbwfxERkUche3qZCGqGK5D/ZlGk2rNul+pds+pVsGFA4a6ghpIh0wcMVqLrZGraYVch4mfgywy+4bQWKeWJGqEGE5qWClyn1OoyuloL9BjYpWtOPcHBVGMxs4H4yfcp3wvJqPLGTaSx9DMfRSaojgWGips4+ZQwgDFJLpnXiBkRcaGK3YW8EDYDHDFvmgL/iWc5kYmvWb/mHHmXx1Fj9GMVNrLhD9A81CYx30TJAKruFYIOR/aEqPoJokjgdwBNHxVVFsB4jDUQrkyeoJpu3Dl8xDOPjiDF4JmVvHUJyucVGEgPlNQFj7VKWzKAe9HqYRY1kILC4Xg1Ko+WJWh7tzLYgMYfIlFnfiK4W9sAbD5Z5z0EoWK8q/aY6ClwPfEF34Bl/5C5cJhvxLaF4C3vuCq8uFMfERydDrwviAxoyEBSSrLY+KlcgA3Q9DGAQeAxKdNX3UFZQ+P0KPfxPlfKzDdSjigNQBcsc3AqdQ1VHqD0naGvfzLICwmv7lSEega+JcqLKSnuI+JUc+k89xviVQWHZ4jY3ZFaK7g4UIfMs2LprCc8QXSh8sQaBq5a8Gd6O/cAsOWFtPMHn6EKf6Zi3BXLcouj6YJV5AdEGDBhVfo85Yxf/AAZXIcf/AAP8x6cyA45Tx5lV3XQhxPMDz1KXAbAgkDoalKBFwI5RAcxeFHOeusShDoQloWO2/cSKr0GE5V93Cru8kw224ujiKYt7tmFkvoigCfiMCKJy1EtZb5fvK8m3mLkWBVuYOj8kOd/iJeA+DuUlAk3RgYQC+QlggHYmptCGkNTQoKbDccb0cjFDDqmGKlkJuwugv59wUDTTn35nwQBpjrQfPE0F/EoYw+5iVR5uXvYeosCOUfc0x+IBQ+JSWppiKGw2kNFadM/2YLTT8RGduRHzaF4N1EOXkMvqA3TLpzcak4YG6Oot1eGBgFptFgPlj98CNvUVIHPB3cRRE4Uq4kJsvJDcMqGGFG+9E0t34JcpbPBx1cyNA4TlKDsGeeifgoay78QcwLg/Ra/5PaYdfX/xkQqiyhiOxmQFNboi0AfEEYFMeUbQRKpOGZhkolNsucAZUc+YG55EQZHZEpI5A5hsAjwt3BasOVL0nczjxDQRxZl9xCw+hlW68gXHcAeEqo+9/dkyhYgTARpWHwb+YJknviXUPHHKKOwugwHruEA4VpXmLSgE7hZSL6lJWfUz4eZpZ9sHiE4SDRd46qFML/ERCuvUAaMDmmbbH6gzWX5mDGY21ftlhuz0IFm4Lpb7lGnPUSv+TQs+JjLRrFHMfkI0wbLP0r3EWEPqa022hHyqzwZZc5ycPEfXAcVFQpXgs2JC7Iq2yFYPKwY2EHZRIitGv3HcEA21k+5Ulf5VcRJmty4QcCLGSDFGkRm/5I/QLao2eKZhpFjHMMt/ECOvmEDvM5uZZnHH6sQL8EUfSDy6IRLKKbXiDHHogmSzzLANaCNQoooaF+5lg25xAK+U3r1HXAjSRiVo0M2gnaRgbOaS/qVGeVZxHgGNIvItXCWfUEED5CWKV6WvuKiCngnkGuC2os2eRriLbFUeJZuxOZkBbm4fAu+a/uVllX7/AHiU4tUsxW4JffhlB28mIFvMeseIw0XtJRZKtXxK1s1w9zJjuWrMRx/5KB/Uoc3FikvthwR+TEs6+J8K8sVZ/Iy1zmIOQlAzdeGC1EKvtjMVL7/+NOfbM+gXITMQxwkvd0bF/mOWG4Wona03k/MeKR1CZTLsVGAhoXcZQcg4lIoclxGUgZaQVM14P5e5mbMls9OmPB1jdzI+pZaGSFDD9KDVntlt9RHfcpxmuIfH6N3ecfBfUNi1N09++oPBl2yoAziyYkxos3FvCWWARqzESaxbdzN0XlCNh7CpmBAvCrqC1A4tbJRPaTX1AVIr0stkI6ErRVumCGFQ8sUNUG0QSBk5gG6t5JxCY4Ji2+EejP8Am4pNW5Iwtp+EMuQzySrWggLUY5JeweEaiwS3wkUg3mUwPmC9D4Za9/EKq5l5zdOJSlPHMyLszE3VOPM6A+WWOr6GCttJ3mWeniO6lnMrm34g+HmDTvc4CNf0FPM9LCXzDX/xURevTHOOfMuswnaS7VF5riDugdUwykrpLj0o8lctRDa0ikI00P7RSyXTWK9xaAN7BwvctpUhkb5gpYBQa/7+8X5mQue2ZGgPEwvcKv3D9f5geCG8alw0FAAHMMqOjchnB3+IqRsoLG8VFoLope0zSwGuIvheR7hkFLzRBF9BI3AXqOgCARsqAJ2WsMQWdMFQF24Io0BPOYEFXw5gmgeGUaBermcDPJaOBe1WHENag8wuKrzcDUS3u4BElOrdTxFtq5YZFOeCuDbExFu8SjAPKNYjXR/sRKKt2QnAM3uXm2hORPuaZoeCUU1fcouPhUywaauKUrbmYYIFRA5+FSxeXxPL8TyF+og5mbjzAXz8Sw2dy0MCyalD9L/r9KCC0yHmNlwV39MtvcaUpiG34CUN3bidsHipY0tvmYI9I27luAZW7N1B4SqyK/hjsJHTX/P3mCANHR/tTpazUu0b1xC6p3DVwK8y8T4nEzx+f0E8OEoWm6/mZDaaSBLBqkGfPzBUF3nEERa14RBWgDtg3W3qF2yB4JXAuAFdZXZESizwE0Ltd1KJW3iWVYOyQgJeeuZeYEvmUqyY3OIfhjqEXzeYGxg4vMQoD2zLAJC+ZYReghTLfCyu1LXgzFBTeDbE3CwcsHalcBOijwENg14IL0+pVck94hkwGLF8k2BfzAi644nDYvlmRX5S7MPwR3UG8ym8D9QQ5KztI1hcxzdQF/yDGFz1Oj4Rtz83BvGTLxEBBfEv/EMfoxZpMTI/ic/9mXB+YemuagDcxlwMVHC+oittumYKrLzNgnwSu20w9xVddq6/aFQFnnXUNReNHiLdkOk4gt3n0xO36Z5/Eymfx+plV+YSliBAM2BKX+CIgUaxLrr/AMi58S7W893zLSw2URC5DmL6QJXS9algDjlmb2Y0HUA1Co1sc9QdxlxEAIUrC3zKVsvpmVoFKdOOotbMTYd9XOzVnFQFHboSmUUcrHYADkl4pt9QBoVOKCVAg+kjwIBapcAS/wB4Ucgy1KK9kQl2NR1uviK9HxF0pPJLf9mK2sF+/ModAeIUFjMt5gjVTmXHiZOR8y1xXmA0a7jDj4mS+b4OoNA+4laa9wpE24eY6t0bAJgzV+I3ZcPxLvj9ChE6nF8RyeIgxVdRTZs4i87gTQmRY8wd4ZXxpaMGUtcCjUsvC9MK0qLdrxXT5ioTtC89+HUKW9+RxFDOYRjBzWpreBWXzRKWgWRgrp/qIzECgaV49keksCgUX6lCYDCUzQ8/xKoLXklwPBMBzQyS3ArlBlGVl6CUFCvmAYQUW8uJlQtOiV4roHE3AByMvi9pYWUPMoqfbMstVELFLAZBhtqKxZXJKDR+IdvpFKxZ8yy0U+4Bk18SqYN9RDRqXFkGXWenMG18EzfB2MRtSUwADNVxLLsu5Z3Fs08zAbrmUvMqcrl5olhrHcAiOV9Q9h4YgaFHWJeg3XLDiZjzGMVLmGqeB5lENjzX4jgz9XMfcKcnPEfzFN1G7w/cwarUV/1MiopRW/ESstVEu6K6jbQHUGRwdEt9hjOE9zAxgtGD0x2qKeOUNvBbU0A5X94vYhFvoP8Asqgc08jMDwTTM09x6YtRVhcS1ywkZ8Dk8x2kqwNt+4AIphSriGoDdxsMmKMbDA5BNwsarDTiOKNdyytV5YK1pmaXT3Klv0yooENrBpAEQstekZSjHqpQlqfUALBfETDAGqqGFG3DMiofFHxNHtzNhSOB5gHkHVwo6CCN8eZhZdRgtteqnN9KmHiXayHuOHKeAiGAu5v2XxbAE/qO2L9Q7IviVNV83Ns8dwDCJ6qcmZpx+YJ0g0cnipS4ryy7zi4DVL7qN4Z9kbcarmIH7IsFK9Rpl0YJSgcl4ripVN35ubaryyjL9x+47zz3O164mQqj4hjL+ZlhVS0zXmoEa4OajVyVH/gwhqp2lxtmujwR4rZnFSsABQxnd9jqXmGGBy0+IgPB6njQdQVDUY6lXlMWCqh30BxElrRQ/K/1zMkDRpllSrAOYS3AAjWCFaTiazl1ACIB6aqIqAugncwUqwzDQzxmouE9xTILNHcsmfgMKTKHQwpXD5lmFAdSseWptjPiCcMNFQayPghsp0EimFYzQQ1PzI5DnqFXz7WbKwubaL5gCgN9rE5K9llkzTfJKYz8QSx+2U2RfVyxlMnNy8gEM5m27vuYNs+5vcfDFoDnzGi6+ogFjzKVipfjMadkOA+5wdcyzqCItuqgBhavmpii9Ff5hIUvRqol/Gpdb/DHiKy4E30xu+RZnaaQbrruoqwJ15ZZd7OonXyXNRcPMa8XeE4UO8xoDUJkHbhuOpQuByY+64ioOo1f0Xie5fiaPZ4hjGgqyvn/AJLAkCrauOzLs8PHmBf2JShoyr8QoA3eMGIjaF93KIcJSEEQoIyGuIKx7BNZW9zWEccx8mHiCZAbgZlZGQDFQKbX3KW0vpiiA6VnqCuVvMKxVwdGPEUcHzKNVb3BXOX+GApwFaYqA0eBmApCuiGWIJmwdRqK/JioH7JQOD1n9ClBxAK0vySl3TXUq8nMo2WspDFPgiFWnqYGVC13qXCyW1i2LoExx+JaN2SzvNu71Amixi8eoBWLGiLZXsYml2QbmMzhpy8yxtPIlLyfmJvLOKv4hgrjqM7cHEDWc8BBxTXyS7hYeowCsOPEucnRYJnSi6NeO4wCgMue4NVdvCxbVXgiog36RUlqSrHcrQ0EKDx+5HoKwBXlO2Dnn0wAtKRcQLAgyzWY8tD4hp+1LsGe4UgQpPdnMusEeIg1duiUVRutkVChyWIGsJ6l6UgbFeJahS2xdjfiGxl81MwvuNgFwY1iCvj4iq5VW5gDKnKT0h8ytjfNXEsAciADXPLHbAHdylYsnS/uHr9pg7WuJZlMsAy3KGv3lS/MAC8/M2KECloiPE9X1Ml2MFaGJwRkbOZTT9TBvnNTkBgXeniBOF9ESA3shk5/uecW8zHT3Ll56Rorx1FbKhSrA7iJbqWssViPM+jonQZTsE5QuUg1AsUy4DiFpFzfsnVS8ChBoLqnz2zE0u7OuYryO8h4hcw3Moios+IZoAozXqXoPa5YUX9zEb2s4lwKNFQceKlGgBlQzMK/BqLDC+mUaKL1mAUo9JQ39GNRVtxcS4IOyYmvIkVig9AxBixvogieHQxYsTGy5vLbYYzT6IBqs83G1T9JQOXsmkL6YFFac3LtEaF3+J4iPUwMDxZFNhXgwqcX5hZRD3AgNPbBajxzKrgX5gsS/wAw6v7uKZKI8ExbaFsgPcyWr6uWXQ/Mvg3nUyY/LMG1+oUNtx4vgwRzVReqfqZGf2ij38w46gIii+AlqNJjlgZhF1M8KSx9DcFPh6iHn3FXgmDI13EusSr9SoopfqacLeZUvEvwGq1cNKYcrEYP41FQJaFv+oawIKKdy2pRuQ4lqlGBGsfKUnCMUUXXmq3zLWK1nAzZvEveBVv9R9z3MX4imdfM9xDanDA6+pbi7TmYDk+obKaKKzCYBgz+UtS6chn5gKkdBuCAVvJFMqhoSGrp6hWb14YBhb1cvgBDhI4yJ3UWDB0ZnsrPiDmwKcLEbUG6qJlKs5JsUH1EDCPkMEvQPcWqbbSDLBDoiWz5IIGR7jxrfiVgLiViNPzNgY5WFkr3ZBataOoGgiMpSZhVm3tlGCvYwKyHqoAfwmVDTFei5luL7xB/2uAAB+IUGR+JinXmWI58Es3nHETvPxElSHhl1/AIHp+onjSUJYRzqCRBZ64hgg4KJarvsgvzGns8Sk1d1HUqJKr4GfygRXZ64lwUq8qwoR7AwLAeQQwKrNgH9zXPZHl57jopaFw8VLsFUPcTEoDC1yshdCncXVp34lrK5ve5kW9XUvdY+43/AJ/RrL+JdlXshihq66hgoflickCArGDBMlTdOLgoSDtwhAKLYEuZAtDQ1KNWeURDAPmWcPQQgGpgUbihmNKzf7IICA7q8sKaYPFyjIBi4xT4liVrwSq8/cBxruCCkfMGUJvhNJs+IdRBMILt3iCncBq82csaaGY10DHEURs9CDZGjhJYGT2zBy+Y9pTshU5BbuLrAdbmW1rHEROd+YLXyuLM/RjQ2+WcqX4YiqiqyRIsY10ShduYmqpHqANFnmLffuFGdeiIMZuaCb5jMyorciuLjBQDqAXDfZChWjxMMcsANMvgs88xMFmeBKAwGW0QerIsVzcKiJty8QXfhYckNANkyvkgNjNgcckzAUF4TjhfkiUXbRs0+H+JvOQJlj0eIJVYSNYyRDk9spq4AEaUznqUVbd7htsn/9k='),
      ]);
    } catch (exception) {
      debugPrint('Error Sending Data. $exception');
    }
  }

  Future<void> _updateWidget() async {
    try {
      print('Future updat widget');
      return HomeWidget.updateWidget(
        name: 'HomeWidgetProvider',
        iOSName: 'HomeWidget',
      );
    } catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }

  // Future<void> _loadData() async {
  //   try {
  //     return Future.wait([
  //       HomeWidget.getWidgetData<String>('title', defaultValue: 'Default Title')
  //           .then((value) => _titleController.text = value),
  //       HomeWidget.getWidgetData<String>('message',
  //           defaultValue: 'Default Message')
  //           .then((value) => _messageController.text = value),
  //     ]);
  //   } catch (exception) {
  //     debugPrint('Error Getting Data. $exception');
  //   }
  // }

  @action
  Future<void> sendAndUpdate() async {
    print('Sending data to widget');
    await _sendData();
    await _updateWidget();
    print('Finished sending data');
  }
}

enum PopPinScreenTo {
  TabsScreen,
  SettingsScreen,
  PhotoScreen,
}
