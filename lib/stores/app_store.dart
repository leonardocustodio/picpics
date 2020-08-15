import 'package:mobx/mobx.dart';

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
