// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secret.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SecretAdapter extends TypeAdapter<Secret> {
  @override
  final int typeId = 3;

  @override
  Secret read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Secret(
      photoId: fields[0] as String,
      photoPath: fields[1] as String,
      thumbPath: fields[2] as String,
      createDateTime: fields[3] as DateTime,
      originalLatitude: fields[4] as double,
      originalLongitude: fields[5] as double,
      nonce: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Secret obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.photoId)
      ..writeByte(1)
      ..write(obj.photoPath)
      ..writeByte(2)
      ..write(obj.thumbPath)
      ..writeByte(3)
      ..write(obj.createDateTime)
      ..writeByte(4)
      ..write(obj.originalLatitude)
      ..writeByte(5)
      ..write(obj.originalLongitude)
      ..writeByte(6)
      ..write(obj.nonce);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecretAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
