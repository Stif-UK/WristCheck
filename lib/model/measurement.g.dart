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
      ..watchKey = (fields[0] as num).toInt()
      ..baseLine = fields[1] as bool
      ..atomicTime = fields[2] as DateTime
      ..watchTime = fields[3] as DateTime
      ..rawAccuracy = (fields[4] as num?)?.toDouble()
      ..id = fields[5] as String?
      ..watchId = fields[6] as String?
      ..updatedAt = fields[7] as DateTime?
      ..isDeleted = fields[8] as bool?
      ..isDirty = fields[9] as bool?;
  }

  @override
  void write(BinaryWriter writer, Measurement obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.watchKey)
      ..writeByte(1)
      ..write(obj.baseLine)
      ..writeByte(2)
      ..write(obj.atomicTime)
      ..writeByte(3)
      ..write(obj.watchTime)
      ..writeByte(4)
      ..write(obj.rawAccuracy)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.watchId)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.isDeleted)
      ..writeByte(9)
      ..write(obj.isDirty);
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
