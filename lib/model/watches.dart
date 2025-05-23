import 'package:hive/hive.dart';

part 'watches.g.dart';

@HiveType(typeId: 0)
class Watches extends HiveObject{

  @HiveField(0)
  late String manufacturer;
  
  @HiveField(1)
  late String model;
  
  @HiveField(2)
  late String? serialNumber;
  
  @HiveField(3)
  late bool favourite;

  @HiveField(4)
  late String? status;

  @HiveField(5)
  late DateTime? purchaseDate;

  @HiveField(6)
  late DateTime? lastServicedDate;

  @HiveField(7)
  late int serviceInterval;

  @HiveField(8)
  late DateTime? nextServiceDue;

  @HiveField(9)
  late String? notes;

  @HiveField(10)
  late List<DateTime> wearList;

  @HiveField(11)
  late List<DateTime>? filteredWearList;

  @HiveField(12)
  late String? frontImagePath;

  @HiveField(13)
  late String? referenceNumber;

  @HiveField(14)
  late String? backImagePath;

  @HiveField(15)
  late String? movement;

  @HiveField(16)
  late String? category;

  @HiveField(17)
  late String? purchasedFrom;

  @HiveField(18)
  late String? soldTo;

  @HiveField(19)
  late int? purchasePrice;

  @HiveField(20)
  late int? soldPrice;

  @HiveField(21)
  late DateTime? soldDate;

  @HiveField(22)
  late DateTime? deliveryDate;

  @HiveField(23)
  late DateTime? warrantyEndDate;

  @HiveField(24)
  late double? caseDiameter;

  @HiveField(25)
  late int? lugWidth;

  @HiveField(26)
  late double? lug2lug;
  
  @HiveField(27)
  late double? caseThickness;

  @HiveField(28)
  late int? waterResistance;

  @HiveField(29)
  late String? caseMaterial;

  @HiveField(30)
  late int? winderTPD;

  @HiveField(31)
  late String? winderDirection;

  @HiveField(32)
  late String? dateComplication;

  @override
  String toString() {
    return "${this.manufacturer} ${this.model}";
  }
}