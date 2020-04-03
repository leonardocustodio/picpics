// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pic.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PicAdapter extends TypeAdapter<Pic> {
  @override
  final typeId = 0;

  @override
  Pic read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pic(
      fields[0] as String,
      fields[1] as DateTime,
      fields[2] as double,
      fields[3] as double,
      fields[4] as String,
      (fields[5] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Pic obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.photoId)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.longitude)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.tags);
  }
}
