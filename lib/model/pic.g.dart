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
      fields[4] as double,
      fields[5] as double,
      fields[6] as String,
      fields[7] as String,
      (fields[8] as List)?.cast<String>(),
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
}
