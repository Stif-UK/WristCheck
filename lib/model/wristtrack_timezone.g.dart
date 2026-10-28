// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wristtrack_timezone.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WristTrackTimezoneAdapter extends TypeAdapter<WristTrackTimezone> {
  @override
  final int typeId = 2;

  @override
  WristTrackTimezone read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WristTrackTimezone(
      title: fields[0] as String? ?? '',
      offset: (fields[1] as num?)?.toDouble() ?? 0.0,
      timeZoneId: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WristTrackTimezone obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.offset)
      ..writeByte(2)
      ..write(obj.timeZoneId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WristTrackTimezoneAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
