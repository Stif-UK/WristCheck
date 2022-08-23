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
  String? frontImagePath;

}