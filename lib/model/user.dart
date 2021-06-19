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
    required this.id,
    required this.email,
    required this.password,
    required this.notifications,
    required this.dailyChallenges,
    required this.goal,
    required this.hourOfDay,
    required this.minutesOfDay,
    required this.isPremium,
    required this.recentTags,
    required this.tutorialCompleted,
    required this.picsTaggedToday,
    required this.lastTaggedPicDate,
    required this.canTagToday,
    required this.appLanguage,
    required this.appVersion,
    required this.hasGalleryPermission,
    required this.loggedIn,
    required this.secretPhotos,
    required this.isPinRegistered,
    required this.keepAskingToDelete,
    required this.shouldDeleteOnPrivate,
    required this.tourCompleted,
    required this.isBiometricActivated,
    required this.starredPhotos,
    required this.defaultWidgetImage,
  });
}
