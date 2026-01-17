class User {
  User({
    required this.id,
    required this.email,
    required this.password,
    required this.notifications,
    required this.dailyChallenges,
    required this.goal,
    required this.hourOfDay,
    required this.minutesOfDay,
    required this.recentTags,
    required this.tutorialCompleted,
    required this.picsTaggedToday,
    required this.lastTaggedPicDate,
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
  final String id;
  final List<String> recentTags;
  String email;
  String password;
  String appLanguage;
  String appVersion;
  String defaultWidgetImage;
  int goal;
  int hourOfDay;
  int minutesOfDay;
  int picsTaggedToday;
  bool hasGalleryPermission;
  bool loggedIn;
  bool secretPhotos;
  bool isPinRegistered;
  bool keepAskingToDelete;
  bool shouldDeleteOnPrivate;
  bool tourCompleted;
  bool isBiometricActivated;
  bool notifications;
  bool dailyChallenges;
  bool tutorialCompleted;
  DateTime lastTaggedPicDate;
  Map<String, String> starredPhotos;
}
