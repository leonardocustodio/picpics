import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 2)
class User extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String email;

  @HiveField(2)
  String password;

  @HiveField(3)
  bool notifications;

  @HiveField(4)
  bool dailyChallenges;

  @HiveField(5)
  int goal;

  @HiveField(6)
  int hourOfDay;

  @HiveField(7)
  int minutesOfDay;

  @HiveField(8)
  bool isPremium;

  @HiveField(9)
  final List<String> recentTags;

  @HiveField(10)
  bool tutorialCompleted;

  @HiveField(11)
  int picsTaggedToday;

  @HiveField(12)
  DateTime lastTaggedPicDate;

  @HiveField(13)
  bool canTagToday;

  @HiveField(14)
  String appLanguage;

  @HiveField(15)
  String appVersion;

  @HiveField(16)
  bool hasSwiped;

  @HiveField(17)
  bool hasGalleryPermission;

  @HiveField(18)
  bool loggedIn;

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
    this.hasSwiped,
    this.hasGalleryPermission,
    this.loggedIn,
  });
}
