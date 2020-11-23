// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 2;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
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
      hasGalleryPermission: fields[17] as bool,
      loggedIn: fields[18] as bool,
      secretPhotos: fields[19] as bool,
      isPinRegistered: fields[20] as bool,
      keepAskingToDelete: fields[21] as bool,
      shouldDeleteOnPrivate: fields[22] as bool,
      tourCompleted: fields[23] as bool,
      isBiometricActivated: fields[24] as bool,
      starredPhotos: (fields[25] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(25)
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
      ..writeByte(17)
      ..write(obj.hasGalleryPermission)
      ..writeByte(18)
      ..write(obj.loggedIn)
      ..writeByte(19)
      ..write(obj.secretPhotos)
      ..writeByte(20)
      ..write(obj.isPinRegistered)
      ..writeByte(21)
      ..write(obj.keepAskingToDelete)
      ..writeByte(22)
      ..write(obj.shouldDeleteOnPrivate)
      ..writeByte(23)
      ..write(obj.tourCompleted)
      ..writeByte(24)
      ..write(obj.isBiometricActivated)
      ..writeByte(25)
      ..write(obj.starredPhotos);
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
