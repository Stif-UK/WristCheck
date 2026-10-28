import 'package:hive_ce/hive.dart';

part 'wristtrack_timezone.g.dart';

@HiveType(typeId: 2)
class WristTrackTimezone extends HiveObject {
  WristTrackTimezone({
    this.title = '',
    this.offset = 0.0,
    this.timeZoneId,
  });

  @HiveField(0)
  late String title;

  @HiveField(1)
  late double offset;

  @HiveField(2)
  String? timeZoneId;
}
