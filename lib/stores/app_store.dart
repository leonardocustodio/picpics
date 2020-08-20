import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/analytics_manager.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/login_screen.dart';
import 'package:picPics/model/user.dart';
import 'package:picPics/push_notifications_manager.dart';
import 'package:picPics/tabs_screen.dart';
import 'package:picPics/utils/languages.dart';
import 'package:uuid/uuid.dart';

part 'app_store.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  final String appVersion;
  final String deviceLocale;

  _AppStore({this.appVersion, this.deviceLocale}) {
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
        hourOfDay: 21,
        minutesOfDay: 30,
        isPremium: false,
        recentTags: [],
        tutorialCompleted: false,
        picsTaggedToday: 0,
        lastTaggedPicDate: DateTime.now(),
        canTagToday: true,
        appLanguage: deviceLocale,
        hasSwiped: false,
        hasGalleryPermission: null,
      );

      user = createUser;
      userBox.put(0, createUser);

      initialRoute = LoginScreen.id;
      Analytics.setUserId(user.id);
      Analytics.sendEvent(Event.created_user);
    } else {
      user = userBox.getAt(0);
      initialRoute = TabsScreen.id;
      Analytics.setUserId(user.id);
      Analytics.sendEvent(Event.user_returned);
    }

    notifications = user.notifications;
    dailyChallenges = user.dailyChallenges;
    hourOfDay = user.hourOfDay;
    minutesOfDay = user.minutesOfDay;
    isPremium = user.isPremium;
    tutorialCompleted = user.tutorialCompleted;
    hasSwiped = user.hasSwiped;
    appLanguage = user.appLanguage;
    hasGalleryPermission = user.hasGalleryPermission;

    if (user.hasGalleryPermission != null || user.tutorialCompleted) {
      requestGalleryPermission();
    }

    // Executa primeira vez para ver se ainda tem permissão
    checkNotificationPermission();

    DatabaseManager.instance.initPlatformState(user.id);

    if (user.isPremium) {
      checkPremiumStatus();
    }

    autorun((_) {
      print('autorun');
    });
  }

  String initialRoute;

  @observable
  bool notifications = false;

  @action
  void requestNotificationPermission() {
    if (Platform.isAndroid) {
      var userBox = Hive.box('user');
      User currentUser = userBox.getAt(0);

      currentUser.notifications = true;
      currentUser.dailyChallenges = true;
      currentUser.save();
    } else {
      PushNotificationsManager push = PushNotificationsManager();
      push.init();
    }
  }

  @action
  Future<void> checkNotificationPermission({bool firstPermissionCheck = false}) async {
    return NotificationPermissions.getNotificationPermissionStatus().then((status) {
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
          currentUser.dailyChallenges = true;
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
  void switchDailyChallenges() {
    dailyChallenges = !dailyChallenges;

    var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.dailyChallenges = dailyChallenges;
    currentUser.save();

//    PushNotificationsManager push = PushNotificationsManager();
//
//    if (dailyChallenges) {
//      push.deregister();
//    } else {
//      push.register();
//    }

    Analytics.sendEvent(Event.notification_switch);
  }

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
  }

  @action
  Future<void> checkPremiumStatus() async {
    bool premium = await DatabaseManager.instance.checkPremiumStatus();
    if (!premium) {
      setIsPremium(false);
    }
  }

//  List<String> recentTags;

  @observable
  bool tutorialCompleted;

  @action
  void setTutorialCompleted(bool value) {
    tutorialCompleted = value;

    var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.tutorialCompleted = value;
    currentUser.save();
  }

  int picsTaggedToday;

  DateTime lastTaggedPicDate;

  bool canTagToday;

  @observable
  bool hasSwiped = false;

  @action
  void setHasSwiped(bool value) {
    hasSwiped = true;

    var userBox = Hive.box('user');
    User currentUser = userBox.getAt(0);
    currentUser.hasSwiped = value;
    currentUser.save();
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
}
