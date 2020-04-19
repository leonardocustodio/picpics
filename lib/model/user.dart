import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 2)
class User {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String password;

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
  final bool isPremium;

  @HiveField(9)
  final List<String> recentTags;

  @HiveField(10)
  bool tutorialCompleted;

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
  });
}
