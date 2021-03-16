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

  final _$keepAskingToDeleteAtom = Atom(name: '_AppStore.keepAskingToDelete');

  @override
  bool get keepAskingToDelete {
    _$keepAskingToDeleteAtom.reportRead();
    return super.keepAskingToDelete;
  }

  @override
  set keepAskingToDelete(bool value) {
    _$keepAskingToDeleteAtom.reportWrite(value, super.keepAskingToDelete, () {
      super.keepAskingToDelete = value;
    });
  }

  final _$shouldDeleteOnPrivateAtom =
      Atom(name: '_AppStore.shouldDeleteOnPrivate');

  @override
  bool get shouldDeleteOnPrivate {
    _$shouldDeleteOnPrivateAtom.reportRead();
    return super.shouldDeleteOnPrivate;
  }

  @override
  set shouldDeleteOnPrivate(bool value) {
    _$shouldDeleteOnPrivateAtom.reportWrite(value, super.shouldDeleteOnPrivate,
        () {
      super.shouldDeleteOnPrivate = value;
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

  final _$requireSecretAtom = Atom(name: '_AppStore.requireSecret');

  @override
  int get requireSecret {
    _$requireSecretAtom.reportRead();
    return super.requireSecret;
  }

  @override
  set requireSecret(int value) {
    _$requireSecretAtom.reportWrite(value, super.requireSecret, () {
      super.requireSecret = value;
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

  final _$tagsAtom = Atom(name: '_AppStore.tags');

  @override
  Map<String, TagsStore> get tags {
    _$tagsAtom.reportRead();
    return super.tags;
  }

  @override
  set tags(Map<String, TagsStore> value) {
    _$tagsAtom.reportWrite(value, super.tags, () {
      super.tags = value;
    });
  }

  final _$mostUsedTagsAtom = Atom(name: '_AppStore.mostUsedTags');

  @override
  List<TagsStore> get mostUsedTags {
    _$mostUsedTagsAtom.reportRead();
    return super.mostUsedTags;
  }

  @override
  set mostUsedTags(List<TagsStore> value) {
    _$mostUsedTagsAtom.reportWrite(value, super.mostUsedTags, () {
      super.mostUsedTags = value;
    });
  }

  final _$lastWeekUsedTagsAtom = Atom(name: '_AppStore.lastWeekUsedTags');

  @override
  List<TagsStore> get lastWeekUsedTags {
    _$lastWeekUsedTagsAtom.reportRead();
    return super.lastWeekUsedTags;
  }

  @override
  set lastWeekUsedTags(List<TagsStore> value) {
    _$lastWeekUsedTagsAtom.reportWrite(value, super.lastWeekUsedTags, () {
      super.lastWeekUsedTags = value;
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

  final _$waitingAccessCodeAtom = Atom(name: '_AppStore.waitingAccessCode');

  @override
  bool get waitingAccessCode {
    _$waitingAccessCodeAtom.reportRead();
    return super.waitingAccessCode;
  }

  @override
  set waitingAccessCode(bool value) {
    _$waitingAccessCodeAtom.reportWrite(value, super.waitingAccessCode, () {
      super.waitingAccessCode = value;
    });
  }

  final _$photoHeightInCardWidgetAtom =
      Atom(name: '_AppStore.photoHeightInCardWidget');

  @override
  double get photoHeightInCardWidget {
    _$photoHeightInCardWidgetAtom.reportRead();
    return super.photoHeightInCardWidget;
  }

  @override
  set photoHeightInCardWidget(double value) {
    _$photoHeightInCardWidgetAtom
        .reportWrite(value, super.photoHeightInCardWidget, () {
      super.photoHeightInCardWidget = value;
    });
  }

  final _$isBiometricActivatedAtom =
      Atom(name: '_AppStore.isBiometricActivated');

  @override
  bool get isBiometricActivated {
    _$isBiometricActivatedAtom.reportRead();
    return super.isBiometricActivated;
  }

  @override
  set isBiometricActivated(bool value) {
    _$isBiometricActivatedAtom.reportWrite(value, super.isBiometricActivated,
        () {
      super.isBiometricActivated = value;
    });
  }

  final _$availableBiometricsAtom = Atom(name: '_AppStore.availableBiometrics');

  @override
  List<BiometricType> get availableBiometrics {
    _$availableBiometricsAtom.reportRead();
    return super.availableBiometrics;
  }

  @override
  set availableBiometrics(List<BiometricType> value) {
    _$availableBiometricsAtom.reportWrite(value, super.availableBiometrics, () {
      super.availableBiometrics = value;
    });
  }

  final _$isMenuExpandedAtom = Atom(name: '_AppStore.isMenuExpanded');

  @override
  bool get isMenuExpanded {
    _$isMenuExpandedAtom.reportRead();
    return super.isMenuExpanded;
  }

  @override
  set isMenuExpanded(bool value) {
    _$isMenuExpandedAtom.reportWrite(value, super.isMenuExpanded, () {
      super.isMenuExpanded = value;
    });
  }

  final _$requestNotificationPermissionAsyncAction =
      AsyncAction('_AppStore.requestNotificationPermission');

  @override
  Future<void> requestNotificationPermission() {
    return _$requestNotificationPermissionAsyncAction
        .run(() => super.requestNotificationPermission());
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

  final _$switchDailyChallengesAsyncAction =
      AsyncAction('_AppStore.switchDailyChallenges');

  @override
  Future<void> switchDailyChallenges(
      {String notificationTitle, String notificationDescription}) {
    return _$switchDailyChallengesAsyncAction.run(() => super
        .switchDailyChallenges(
            notificationTitle: notificationTitle,
            notificationDescription: notificationDescription));
  }

  final _$setIsPinRegisteredAsyncAction =
      AsyncAction('_AppStore.setIsPinRegistered');

  @override
  Future<void> setIsPinRegistered(bool value) {
    return _$setIsPinRegisteredAsyncAction
        .run(() => super.setIsPinRegistered(value));
  }

  final _$setKeepAskingToDeleteAsyncAction =
      AsyncAction('_AppStore.setKeepAskingToDelete');

  @override
  Future<void> setKeepAskingToDelete(bool value) {
    return _$setKeepAskingToDeleteAsyncAction
        .run(() => super.setKeepAskingToDelete(value));
  }

  final _$setShouldDeleteOnPrivateAsyncAction =
      AsyncAction('_AppStore.setShouldDeleteOnPrivate');

  @override
  Future<void> setShouldDeleteOnPrivate(bool value) {
    return _$setShouldDeleteOnPrivateAsyncAction
        .run(() => super.setShouldDeleteOnPrivate(value));
  }

  final _$switchSecretPhotosAsyncAction =
      AsyncAction('_AppStore.switchSecretPhotos');

  @override
  Future<void> switchSecretPhotos() {
    return _$switchSecretPhotosAsyncAction
        .run(() => super.switchSecretPhotos());
  }

  final _$changeUserTimeOfDayAsyncAction =
      AsyncAction('_AppStore.changeUserTimeOfDay');

  @override
  Future<void> changeUserTimeOfDay(int hour, int minute) {
    return _$changeUserTimeOfDayAsyncAction
        .run(() => super.changeUserTimeOfDay(hour, minute));
  }

  final _$setIsPremiumAsyncAction = AsyncAction('_AppStore.setIsPremium');

  @override
  Future<void> setIsPremium(bool value) {
    return _$setIsPremiumAsyncAction.run(() => super.setIsPremium(value));
  }

  final _$checkPremiumStatusAsyncAction =
      AsyncAction('_AppStore.checkPremiumStatus');

  @override
  Future<void> checkPremiumStatus() {
    return _$checkPremiumStatusAsyncAction
        .run(() => super.checkPremiumStatus());
  }

  final _$loadTagsAsyncAction = AsyncAction('_AppStore.loadTags');

  @override
  Future<void> loadTags() {
    return _$loadTagsAsyncAction.run(() => super.loadTags());
  }

  final _$editRecentTagsAsyncAction = AsyncAction('_AppStore.editRecentTags');

  @override
  Future<void> editRecentTags(String oldTagKey, String newTagKey) {
    return _$editRecentTagsAsyncAction
        .run(() => super.editRecentTags(oldTagKey, newTagKey));
  }

  final _$setTutorialCompletedAsyncAction =
      AsyncAction('_AppStore.setTutorialCompleted');

  @override
  Future<void> setTutorialCompleted(bool value) {
    return _$setTutorialCompletedAsyncAction
        .run(() => super.setTutorialCompleted(value));
  }

  final _$setLoggedInAsyncAction = AsyncAction('_AppStore.setLoggedIn');

  @override
  Future<void> setLoggedIn(bool value) {
    return _$setLoggedInAsyncAction.run(() => super.setLoggedIn(value));
  }

  final _$setCanTagTodayAsyncAction = AsyncAction('_AppStore.setCanTagToday');

  @override
  Future<void> setCanTagToday(bool value) {
    return _$setCanTagTodayAsyncAction.run(() => super.setCanTagToday(value));
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
  Future<bool> requestGalleryPermission() {
    return _$requestGalleryPermissionAsyncAction
        .run(() => super.requestGalleryPermission());
  }

  final _$changeUserLanguageAsyncAction =
      AsyncAction('_AppStore.changeUserLanguage');

  @override
  Future<void> changeUserLanguage(String language) {
    return _$changeUserLanguageAsyncAction
        .run(() => super.changeUserLanguage(language));
  }

  final _$createDefaultTagsAsyncAction =
      AsyncAction('_AppStore.createDefaultTags');

  @override
  Future<void> createDefaultTags(BuildContext context) {
    return _$createDefaultTagsAsyncAction
        .run(() => super.createDefaultTags(context));
  }

  final _$addTagToRecentAsyncAction = AsyncAction('_AppStore.addTagToRecent');

  @override
  Future<void> addTagToRecent({String tagKey}) {
    return _$addTagToRecentAsyncAction
        .run(() => super.addTagToRecent(tagKey: tagKey));
  }

  final _$removeTagFromRecentAsyncAction =
      AsyncAction('_AppStore.removeTagFromRecent');

  @override
  Future<void> removeTagFromRecent({String tagKey}) {
    return _$removeTagFromRecentAsyncAction
        .run(() => super.removeTagFromRecent(tagKey: tagKey));
  }

  final _$setIsBiometricActivatedAsyncAction =
      AsyncAction('_AppStore.setIsBiometricActivated');

  @override
  Future<void> setIsBiometricActivated(bool value) {
    return _$setIsBiometricActivatedAsyncAction
        .run(() => super.setIsBiometricActivated(value));
  }

  final _$checkAvailableBiometricsAsyncAction =
      AsyncAction('_AppStore.checkAvailableBiometrics');

  @override
  Future<void> checkAvailableBiometrics() {
    return _$checkAvailableBiometricsAsyncAction
        .run(() => super.checkAvailableBiometrics());
  }

  final _$deactivateBiometricAsyncAction =
      AsyncAction('_AppStore.deactivateBiometric');

  @override
  Future<void> deactivateBiometric() {
    return _$deactivateBiometricAsyncAction
        .run(() => super.deactivateBiometric());
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
  void setRequireSecret(int value) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setRequireSecret');
    try {
      return super.setRequireSecret(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadMostUsedTags({int maxTagsLength = 12}) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.loadMostUsedTags');
    try {
      return super.loadMostUsedTags(maxTagsLength: maxTagsLength);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadLastWeekUsedTags({int maxTagsLength = 12}) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.loadLastWeekUsedTags');
    try {
      return super.loadLastWeekUsedTags(maxTagsLength: maxTagsLength);
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
  void setWaitingAccessCode(bool value) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setWaitingAccessCode');
    try {
      return super.setWaitingAccessCode(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPhotoHeightInCardWidget(double value) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setPhotoHeightInCardWidget');
    try {
      return super.setPhotoHeightInCardWidget(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void switchIsMenuExpanded() {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.switchIsMenuExpanded');
    try {
      return super.switchIsMenuExpanded();
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
keepAskingToDelete: ${keepAskingToDelete},
shouldDeleteOnPrivate: ${shouldDeleteOnPrivate},
secretPhotos: ${secretPhotos},
requireSecret: ${requireSecret},
hourOfDay: ${hourOfDay},
minutesOfDay: ${minutesOfDay},
isPremium: ${isPremium},
tags: ${tags},
mostUsedTags: ${mostUsedTags},
lastWeekUsedTags: ${lastWeekUsedTags},
tutorialCompleted: ${tutorialCompleted},
canTagToday: ${canTagToday},
appLanguage: ${appLanguage},
hasGalleryPermission: ${hasGalleryPermission},
waitingAccessCode: ${waitingAccessCode},
photoHeightInCardWidget: ${photoHeightInCardWidget},
isBiometricActivated: ${isBiometricActivated},
availableBiometrics: ${availableBiometrics},
isMenuExpanded: ${isMenuExpanded},
appLocale: ${appLocale},
currentLanguage: ${currentLanguage}
    ''';
  }
}
