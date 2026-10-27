import 'package:hive_ce/hive.dart';
import 'package:wristcheck/model/measurement.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristtrack_timezone.dart';

extension HiveRegistrar on HiveInterface {
  void registerAdapters() {
    registerAdapter(MeasurementAdapter());
    registerAdapter(WatchesAdapter());
    registerAdapter(WristTrackTimezoneAdapter());
  }
}
