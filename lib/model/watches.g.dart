// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watches.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WatchesAdapter extends TypeAdapter<Watches> {
  @override
  final int typeId = 0;

  @override
  Watches read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Watches()
      ..manufacturer = fields[0] as String
      ..model = fields[1] as String
      ..serialNumber = fields[2] as String?
      ..favourite = fields[3] as bool
      ..status = fields[4] as String?;
  }

  @override
  void write(BinaryWriter writer, Watches obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.manufacturer)
      ..writeByte(1)
      ..write(obj.model)
      ..writeByte(2)
      ..write(obj.serialNumber)
      ..writeByte(3)
      ..write(obj.favourite)
      ..writeByte(4)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
