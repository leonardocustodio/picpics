class User {
  final String id;
  final List<String> recentTags;
  String email, password, appLanguage, appVersion, defaultWidgetImage;
  int goal, hourOfDay, minutesOfDay, picsTaggedToday;
  bool canTagToday,
      hasGalleryPermission,
      loggedIn,
      secretPhotos,
      isPinRegistered,
      keepAskingToDelete,
      shouldDeleteOnPrivate,
      tourCompleted,
      isBiometricActivated,
      isPremium,
      notifications,
      dailyChallenges,
      tutorialCompleted;
  DateTime lastTaggedPicDate;
  List<String> starredPhotos;
  User({
    this.id,
    this.email,
    this.password,
    this.notifications,
    this.dailyChallenges,
    this.goal,
    this.hourOfDay,
    this.minutesOfDay,
    this.isPremium,
    this.recentTags,
    this.tutorialCompleted,
    this.picsTaggedToday,
    this.lastTaggedPicDate,
    this.canTagToday,
    this.appLanguage,
    this.appVersion,
    this.hasGalleryPermission,
    this.loggedIn,
    this.secretPhotos,
    this.isPinRegistered,
    this.keepAskingToDelete,
    this.shouldDeleteOnPrivate,
    this.tourCompleted,
    this.isBiometricActivated,
    this.starredPhotos,
    this.defaultWidgetImage,
  });
}
