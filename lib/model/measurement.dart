import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

part 'measurement.g.dart';

@HiveType(typeId: 1)
class Measurement extends HiveObject {

  Measurement();

  @HiveField(0)
  late int watchKey;

  @HiveField(1)
  late bool baseLine;

  @HiveField(2)
  late DateTime atomicTime;

  @HiveField(3)
  late DateTime watchTime;

  @HiveField(4)
  late double? rawAccuracy;

  // --- Cloud Sync Fields ---
  @HiveField(5)
  String? id;

  @HiveField(6)
  String? watchId;

  @HiveField(7)
  DateTime? updatedAt;

  @HiveField(8)
  bool? isDeleted;

  @HiveField(9)
  bool? isDirty;

  /// Ensure ID, watchId, and sync metadata are initialized
  void ensureInitialized(String parentWatchUuid) {
    id ??= const Uuid().v4();
    watchId = parentWatchUuid;
    updatedAt ??= DateTime.now();
    isDeleted ??= false;
    isDirty ??= true;
  }

  /// Serialize to JSON for Supabase upsert
  Map<String, dynamic> toJson(String userId) {
    return {
      'id': id ?? const Uuid().v4(),
      'user_id': userId,
      'watch_id': watchId,
      'base_line': baseLine,
      'atomic_time': atomicTime.toIso8601String(),
      'watch_time': watchTime.toIso8601String(),
      'raw_accuracy': rawAccuracy,
      'updated_at': (updatedAt ?? DateTime.now()).toIso8601String(),
      'is_deleted': isDeleted ?? false,
    };
  }

  /// Deserialize from Supabase JSON response
  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement()
      ..id = json['id'] as String?
      ..watchId = json['watch_id'] as String?
      ..baseLine = json['base_line'] as bool? ?? false
      ..atomicTime = json['atomic_time'] != null ? DateTime.parse(json['atomic_time']) : DateTime.now()
      ..watchTime = json['watch_time'] != null ? DateTime.parse(json['watch_time']) : DateTime.now()
      ..rawAccuracy = (json['raw_accuracy'] as num?)?.toDouble()
      ..updatedAt = json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null
      ..isDeleted = json['is_deleted'] as bool? ?? false
      ..isDirty = false;
  }
}
