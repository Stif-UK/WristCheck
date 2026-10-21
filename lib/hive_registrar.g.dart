import 'package:hive_ce/hive.dart';
import 'package:wristcheck/model/measurement.dart';
import 'package:wristcheck/model/watches.dart';

extension HiveRegistrar on HiveInterface {
  void registerAdapters() {
    registerAdapter(MeasurementAdapter());
    registerAdapter(WatchesAdapter());
  }
}
