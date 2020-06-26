// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final typeId = 2;

  @override
  User read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      email: fields[1] as String,
      password: fields[2] as String,
      notifications: fields[3] as bool,
      dailyChallenges: fields[4] as bool,
      goal: fields[5] as int,
      hourOfDay: fields[6] as int,
      minutesOfDay: fields[7] as int,
      isPremium: fields[8] as bool,
      recentTags: (fields[9] as List)?.cast<String>(),
      tutorialCompleted: fields[10] as bool,
      picsTaggedToday: fields[11] as int,
      lastTaggedPicDate: fields[12] as DateTime,
      canTagToday: fields[13] as bool,
      appLanguage: fields[14] as String,
      appVersion: fields[15] as String,
      hasSwiped: fields[16] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.notifications)
      ..writeByte(4)
      ..write(obj.dailyChallenges)
      ..writeByte(5)
      ..write(obj.goal)
      ..writeByte(6)
      ..write(obj.hourOfDay)
      ..writeByte(7)
      ..write(obj.minutesOfDay)
      ..writeByte(8)
      ..write(obj.isPremium)
      ..writeByte(9)
      ..write(obj.recentTags)
      ..writeByte(10)
      ..write(obj.tutorialCompleted)
      ..writeByte(11)
      ..write(obj.picsTaggedToday)
      ..writeByte(12)
      ..write(obj.lastTaggedPicDate)
      ..writeByte(13)
      ..write(obj.canTagToday)
      ..writeByte(14)
      ..write(obj.appLanguage)
      ..writeByte(15)
      ..write(obj.appVersion)
      ..writeByte(16)
      ..write(obj.hasSwiped);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
