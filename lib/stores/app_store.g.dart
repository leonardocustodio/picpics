// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppStore on _AppStore, Store {
  Computed<Locale> _$appLocaleComputed;

  @override
  Locale get appLocale => (_$appLocaleComputed ??=
          Computed<Locale>(() => super.appLocale, name: '_AppStore.appLocale'))
      .value;
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

  final _$isPinRegisteredAtom = Atom(name: '_AppStore.isPinRegistered');

  @override
  bool get isPinRegistered {
    _$isPinRegisteredAtom.reportRead();
    return super.isPinRegistered;
  }

  @override
  set isPinRegistered(bool value) {
    _$isPinRegisteredAtom.reportWrite(value, super.isPinRegistered, () {
      super.isPinRegistered = value;
    });
  }

  final _$secretPhotosAtom = Atom(name: '_AppStore.secretPhotos');

  @override
  bool get secretPhotos {
    _$secretPhotosAtom.reportRead();
    return super.secretPhotos;
  }

  @override
  set secretPhotos(bool value) {
    _$secretPhotosAtom.reportWrite(value, super.secretPhotos, () {
      super.secretPhotos = value;
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

  final _$canTagTodayAtom = Atom(name: '_AppStore.canTagToday');

  @override
  bool get canTagToday {
    _$canTagTodayAtom.reportRead();
    return super.canTagToday;
  }

  @override
  set canTagToday(bool value) {
    _$canTagTodayAtom.reportWrite(value, super.canTagToday, () {
      super.canTagToday = value;
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

  final _$hasGalleryPermissionAtom =
      Atom(name: '_AppStore.hasGalleryPermission');

  @override
  bool get hasGalleryPermission {
    _$hasGalleryPermissionAtom.reportRead();
    return super.hasGalleryPermission;
  }

  @override
  set hasGalleryPermission(bool value) {
    _$hasGalleryPermissionAtom.reportWrite(value, super.hasGalleryPermission,
        () {
      super.hasGalleryPermission = value;
    });
  }

  final _$checkNotificationPermissionAsyncAction =
      AsyncAction('_AppStore.checkNotificationPermission');

  @override
  Future<void> checkNotificationPermission(
      {bool firstPermissionCheck = false}) {
    return _$checkNotificationPermissionAsyncAction.run(() => super
        .checkNotificationPermission(
            firstPermissionCheck: firstPermissionCheck));
  }

  final _$checkPremiumStatusAsyncAction =
      AsyncAction('_AppStore.checkPremiumStatus');

  @override
  Future<void> checkPremiumStatus() {
    return _$checkPremiumStatusAsyncAction
        .run(() => super.checkPremiumStatus());
  }

  final _$increaseTodayTaggedPicsAsyncAction =
      AsyncAction('_AppStore.increaseTodayTaggedPics');

  @override
  Future<void> increaseTodayTaggedPics() {
    return _$increaseTodayTaggedPicsAsyncAction
        .run(() => super.increaseTodayTaggedPics());
  }

  final _$requestGalleryPermissionAsyncAction =
      AsyncAction('_AppStore.requestGalleryPermission');

  @override
  Future<void> requestGalleryPermission() {
    return _$requestGalleryPermissionAsyncAction
        .run(() => super.requestGalleryPermission());
  }

  final _$_AppStoreActionController = ActionController(name: '_AppStore');

  @override
  void setTryBuyId(String value) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setTryBuyId');
    try {
      return super.setTryBuyId(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void requestNotificationPermission() {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.requestNotificationPermission');
    try {
      return super.requestNotificationPermission();
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

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
  void setIsPinRegistered(bool value) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setIsPinRegistered');
    try {
      return super.setIsPinRegistered(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void switchSecretPhotos() {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.switchSecretPhotos');
    try {
      return super.switchSecretPhotos();
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
  void setIsPremium(bool value) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setIsPremium');
    try {
      return super.setIsPremium(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadTags() {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.loadTags');
    try {
      return super.loadTags();
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addTag(TagsStore tagsStore) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.addTag');
    try {
      return super.addTag(tagsStore);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void editTag({String oldTagKey, String newTagKey, String newName}) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.editTag');
    try {
      return super.editTag(
          oldTagKey: oldTagKey, newTagKey: newTagKey, newName: newName);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeTag({TagsStore tagsStore}) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.removeTag');
    try {
      return super.removeTag(tagsStore: tagsStore);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addRecentTags(String tagKey) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.addRecentTags');
    try {
      return super.addRecentTags(tagKey);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void editRecentTags(String oldTagKey, String newTagKey) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.editRecentTags');
    try {
      return super.editRecentTags(oldTagKey, newTagKey);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTutorialCompleted(bool value) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setTutorialCompleted');
    try {
      return super.setTutorialCompleted(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoggedIn(bool value) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setLoggedIn');
    try {
      return super.setLoggedIn(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCanTagToday(bool value) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setCanTagToday');
    try {
      return super.setCanTagToday(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setHasSwiped(bool value) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setHasSwiped');
    try {
      return super.setHasSwiped(value);
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
  void createDefaultTags(BuildContext context) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.createDefaultTags');
    try {
      return super.createDefaultTags(context);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addTagToRecent({String tagKey}) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.addTagToRecent');
    try {
      return super.addTagToRecent(tagKey: tagKey);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeTagFromRecent({String tagKey}) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.removeTagFromRecent');
    try {
      return super.removeTagFromRecent(tagKey: tagKey);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
notifications: ${notifications},
dailyChallenges: ${dailyChallenges},
isPinRegistered: ${isPinRegistered},
secretPhotos: ${secretPhotos},
hourOfDay: ${hourOfDay},
minutesOfDay: ${minutesOfDay},
isPremium: ${isPremium},
tutorialCompleted: ${tutorialCompleted},
canTagToday: ${canTagToday},
hasSwiped: ${hasSwiped},
appLanguage: ${appLanguage},
hasGalleryPermission: ${hasGalleryPermission},
appLocale: ${appLocale},
currentLanguage: ${currentLanguage}
    ''';
  }
}
