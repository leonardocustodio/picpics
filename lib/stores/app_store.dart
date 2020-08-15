import 'package:mobx/mobx.dart';
import 'package:picPics/analytics_manager.dart';
import 'package:picPics/push_notifications_manager.dart';

part 'app_store.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  _AppStore() {
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

  String appVersion = '1.0.0';
}
