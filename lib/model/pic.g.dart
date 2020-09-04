// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pic.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PicAdapter extends TypeAdapter<Pic> {
  @override
  final int typeId = 0;

  @override
  Pic read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pic(
      photoId: fields[0] as String,
      createdAt: fields[1] as DateTime,
      originalLatitude: fields[2] as double,
      originalLongitude: fields[3] as double,
      latitude: fields[4] as double,
      longitude: fields[5] as double,
      specificLocation: fields[6] as String,
      generalLocation: fields[7] as String,
      tags: (fields[8] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Pic obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.photoId)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.originalLatitude)
      ..writeByte(3)
      ..write(obj.originalLongitude)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.longitude)
      ..writeByte(6)
      ..write(obj.specificLocation)
      ..writeByte(7)
      ..write(obj.generalLocation)
      ..writeByte(8)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PicAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
