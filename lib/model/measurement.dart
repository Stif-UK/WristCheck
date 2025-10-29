import 'package:hive/hive.dart';

part 'measurement.g.dart';

@HiveType(typeId: 1)
class Measurement extends HiveObject {

  @HiveField(0)
  late int watchKey;

  @HiveField(1)
  late bool baseLine;

  @HiveField(2)
  late DateTime atomicTime;

  @HiveField(3)
  late DateTime watchTime;

}