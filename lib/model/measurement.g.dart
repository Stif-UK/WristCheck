// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeasurementAdapter extends TypeAdapter<Measurement> {
  @override
  final int typeId = 1;

  @override
  Measurement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Measurement()
      ..watchKey = fields[0] as int
      ..baseLine = fields[1] as bool
      ..atomicTime = fields[2] as DateTime
      ..watchTime = fields[3] as DateTime
      ..rawAccuracy = fields[4] as double?;
  }

  @override
  void write(BinaryWriter writer, Measurement obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.watchKey)
      ..writeByte(1)
      ..write(obj.baseLine)
      ..writeByte(2)
      ..write(obj.atomicTime)
      ..writeByte(3)
      ..write(obj.watchTime)
      ..writeByte(4)
      ..write(obj.rawAccuracy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeasurementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
