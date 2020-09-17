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
      pin: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Secret obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.pin);
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
