import 'package:flutter/material.dart';
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
  final bool dailyChallenges;

  @HiveField(4)
  final int goal;

  @HiveField(5)
  final int hourOfDay;

  @HiveField(6)
  final int minutesOfDay;

  @HiveField(7)
  final bool isPremium;

  @HiveField(8)
  final List<String> recentTags;

  User(this.id, this.email, this.password, this.dailyChallenges, this.goal, this.hourOfDay, this.minutesOfDay, this.isPremium,
      this.recentTags);
}
