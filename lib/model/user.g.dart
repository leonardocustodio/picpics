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
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as bool,
      fields[4] as int,
      fields[5] as int,
      fields[6] as int,
      fields[7] as bool,
      (fields[8] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.dailyChallenges)
      ..writeByte(4)
      ..write(obj.goal)
      ..writeByte(5)
      ..write(obj.hourOfDay)
      ..writeByte(6)
      ..write(obj.minutesOfDay)
      ..writeByte(7)
      ..write(obj.isPremium)
      ..writeByte(8)
      ..write(obj.recentTags);
  }
}
