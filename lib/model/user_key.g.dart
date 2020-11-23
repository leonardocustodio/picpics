// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_key.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserKeyAdapter extends TypeAdapter<UserKey> {
  @override
  final int typeId = 5;

  @override
  UserKey read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserKey(
      secretKey: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserKey obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.secretKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserKeyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
