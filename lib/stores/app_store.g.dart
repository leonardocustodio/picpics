// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppStore on _AppStore, Store {
  Computed<String> _$currentLanguageComputed;

  @override
  String get currentLanguage => (_$currentLanguageComputed ??= Computed<String>(
          () => super.currentLanguage,
          name: '_AppStore.currentLanguage'))
      .value;

  final _$notificationsAtom = Atom(name: '_AppStore.notifications');

  @override
  bool get notifications {
    _$notificationsAtom.reportRead();
    return super.notifications;
  }

  @override
  set notifications(bool value) {
    _$notificationsAtom.reportWrite(value, super.notifications, () {
      super.notifications = value;
    });
  }

  final _$dailyChallengesAtom = Atom(name: '_AppStore.dailyChallenges');

  @override
  bool get dailyChallenges {
    _$dailyChallengesAtom.reportRead();
    return super.dailyChallenges;
  }

  @override
  set dailyChallenges(bool value) {
    _$dailyChallengesAtom.reportWrite(value, super.dailyChallenges, () {
      super.dailyChallenges = value;
    });
  }

  final _$hourOfDayAtom = Atom(name: '_AppStore.hourOfDay');

  @override
  int get hourOfDay {
    _$hourOfDayAtom.reportRead();
    return super.hourOfDay;
  }

  @override
  set hourOfDay(int value) {
    _$hourOfDayAtom.reportWrite(value, super.hourOfDay, () {
      super.hourOfDay = value;
    });
  }

  final _$minutesOfDayAtom = Atom(name: '_AppStore.minutesOfDay');

  @override
  int get minutesOfDay {
    _$minutesOfDayAtom.reportRead();
    return super.minutesOfDay;
  }

  @override
  set minutesOfDay(int value) {
    _$minutesOfDayAtom.reportWrite(value, super.minutesOfDay, () {
      super.minutesOfDay = value;
    });
  }

  final _$isPremiumAtom = Atom(name: '_AppStore.isPremium');

  @override
  bool get isPremium {
    _$isPremiumAtom.reportRead();
    return super.isPremium;
  }

  @override
  set isPremium(bool value) {
    _$isPremiumAtom.reportWrite(value, super.isPremium, () {
      super.isPremium = value;
    });
  }

  final _$tutorialCompletedAtom = Atom(name: '_AppStore.tutorialCompleted');

  @override
  bool get tutorialCompleted {
    _$tutorialCompletedAtom.reportRead();
    return super.tutorialCompleted;
  }

  @override
  set tutorialCompleted(bool value) {
    _$tutorialCompletedAtom.reportWrite(value, super.tutorialCompleted, () {
      super.tutorialCompleted = value;
    });
  }

  final _$hasSwipedAtom = Atom(name: '_AppStore.hasSwiped');

  @override
  bool get hasSwiped {
    _$hasSwipedAtom.reportRead();
    return super.hasSwiped;
  }

  @override
  set hasSwiped(bool value) {
    _$hasSwipedAtom.reportWrite(value, super.hasSwiped, () {
      super.hasSwiped = value;
    });
  }

  final _$appLanguageAtom = Atom(name: '_AppStore.appLanguage');

  @override
  String get appLanguage {
    _$appLanguageAtom.reportRead();
    return super.appLanguage;
  }

  @override
  set appLanguage(String value) {
    _$appLanguageAtom.reportWrite(value, super.appLanguage, () {
      super.appLanguage = value;
    });
  }

  final _$_AppStoreActionController = ActionController(name: '_AppStore');

  @override
  void switchDailyChallenges() {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.switchDailyChallenges');
    try {
      return super.switchDailyChallenges();
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeUserTimeOfDay(int hour, int minute) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.changeUserTimeOfDay');
    try {
      return super.changeUserTimeOfDay(hour, minute);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeUserLanguage(String language) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.changeUserLanguage');
    try {
      return super.changeUserLanguage(language);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
notifications: ${notifications},
dailyChallenges: ${dailyChallenges},
hourOfDay: ${hourOfDay},
minutesOfDay: ${minutesOfDay},
isPremium: ${isPremium},
tutorialCompleted: ${tutorialCompleted},
hasSwiped: ${hasSwiped},
appLanguage: ${appLanguage},
currentLanguage: ${currentLanguage}
    ''';
  }
}
