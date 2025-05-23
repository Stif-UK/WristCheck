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
      ..status = fields[4] as String?
      ..purchaseDate = fields[5] as DateTime?
      ..lastServicedDate = fields[6] as DateTime?
      ..serviceInterval = fields[7] as int
      ..nextServiceDue = fields[8] as DateTime?
      ..notes = fields[9] as String?
      ..wearList = (fields[10] as List).cast<DateTime>()
      ..filteredWearList = (fields[11] as List?)?.cast<DateTime>()
      ..frontImagePath = fields[12] as String?
      ..referenceNumber = fields[13] as String?
      ..backImagePath = fields[14] as String?
      ..movement = fields[15] as String?
      ..category = fields[16] as String?
      ..purchasedFrom = fields[17] as String?
      ..soldTo = fields[18] as String?
      ..purchasePrice = fields[19] as int?
      ..soldPrice = fields[20] as int?
      ..soldDate = fields[21] as DateTime?
      ..deliveryDate = fields[22] as DateTime?
      ..warrantyEndDate = fields[23] as DateTime?
      ..caseDiameter = fields[24] as double?
      ..lugWidth = fields[25] as int?
      ..lug2lug = fields[26] as double?
      ..caseThickness = fields[27] as double?
      ..waterResistance = fields[28] as int?
      ..caseMaterial = fields[29] as String?
      ..winderTPD = fields[30] as int?
      ..winderDirection = fields[31] as String?
      ..dateComplication = fields[32] as String?;
  }

  @override
  void write(BinaryWriter writer, Watches obj) {
    writer
      ..writeByte(33)
      ..writeByte(0)
      ..write(obj.manufacturer)
      ..writeByte(1)
      ..write(obj.model)
      ..writeByte(2)
      ..write(obj.serialNumber)
      ..writeByte(3)
      ..write(obj.favourite)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.purchaseDate)
      ..writeByte(6)
      ..write(obj.lastServicedDate)
      ..writeByte(7)
      ..write(obj.serviceInterval)
      ..writeByte(8)
      ..write(obj.nextServiceDue)
      ..writeByte(9)
      ..write(obj.notes)
      ..writeByte(10)
      ..write(obj.wearList)
      ..writeByte(11)
      ..write(obj.filteredWearList)
      ..writeByte(12)
      ..write(obj.frontImagePath)
      ..writeByte(13)
      ..write(obj.referenceNumber)
      ..writeByte(14)
      ..write(obj.backImagePath)
      ..writeByte(15)
      ..write(obj.movement)
      ..writeByte(16)
      ..write(obj.category)
      ..writeByte(17)
      ..write(obj.purchasedFrom)
      ..writeByte(18)
      ..write(obj.soldTo)
      ..writeByte(19)
      ..write(obj.purchasePrice)
      ..writeByte(20)
      ..write(obj.soldPrice)
      ..writeByte(21)
      ..write(obj.soldDate)
      ..writeByte(22)
      ..write(obj.deliveryDate)
      ..writeByte(23)
      ..write(obj.warrantyEndDate)
      ..writeByte(24)
      ..write(obj.caseDiameter)
      ..writeByte(25)
      ..write(obj.lugWidth)
      ..writeByte(26)
      ..write(obj.lug2lug)
      ..writeByte(27)
      ..write(obj.caseThickness)
      ..writeByte(28)
      ..write(obj.waterResistance)
      ..writeByte(29)
      ..write(obj.caseMaterial)
      ..writeByte(30)
      ..write(obj.winderTPD)
      ..writeByte(31)
      ..write(obj.winderDirection)
      ..writeByte(32)
      ..write(obj.dateComplication);
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
