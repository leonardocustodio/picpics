import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/analytics_manager.dart';
import 'package:picPics/model/user.dart';
import 'package:picPics/push_notifications_manager.dart';
import 'package:picPics/utils/languages.dart';

part 'app_store.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  final String appVersion;

  _AppStore({this.appVersion}) {
    var userBox = Hive.box('user');
    User user = userBox.getAt(0);

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

    autorun((_) {
      print('autorun');
    });
  }

  @observable
  bool notifications = false;

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

  @observable
  String appLanguage = 'pt_BR';

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
    String lang = appLanguage.split('_')[0];
    var local = LanguageLocal();
    return '${local.getDisplayLanguage(lang)['nativeName']}';
  }
}
