import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
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
//    PushNotificationsManager push = PushNotificationsManager();
//
//    if (dailyChallenges) {
//      push.deregister();
//    } else {
//      push.register();
//    }
    dailyChallenges = !dailyChallenges;
//
//    Analytics.sendEvent(Event.notification_switch);
  }

//  int goal;

  @observable
  int hourOfDay = 20;

  @observable
  int minutesOfDay = 00;

  @action
  void changeUserTimeOfDay(int hour, int minute) {
    var userBox = Hive.box('user');
    hourOfDay = hour;
    minutesOfDay = minute;
//    userBox.putAt(0, userSettings);
    Analytics.sendEvent(Event.notification_time);
//    notifyListeners();

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

  int picsTaggedToday;

  DateTime lastTaggedPicDate;

  bool canTagToday;

  @observable
  bool hasSwiped = false;

  @observable
  String appLanguage = 'pt_BR';

  @action
  void changeUserLanguage(String language) {
    var userBox = Hive.box('user');
    appLanguage = language;
//    userBox.putAt(0, userSettings);

    Analytics.sendEvent(Event.changed_language);
  }

  @computed
  String get currentLanguage {
    String lang = appLanguage.split('_')[0];
    var local = LanguageLocal();
    return '${local.getDisplayLanguage(lang)['nativeName']}';
  }
}
