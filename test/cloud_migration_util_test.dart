import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/cloud_migration_util.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('wristcheck_migration_test_');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(WatchesAdapter());
    }
  });

  setUp(() async {
    if (Hive.isBoxOpen('WatchBox')) {
      await Hive.box<Watches>('WatchBox').clear();
    } else {
      await Hive.openBox<Watches>('WatchBox');
    }
  });

  tearDownAll(() async {
    if (Hive.isBoxOpen('WatchBox')) {
      await Hive.box<Watches>('WatchBox').close();
    }
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  Watches buildBaseWatch({
    String? id,
    DateTime? updatedAt,
    bool? isDirty,
    bool? isDeleted,
    String? frontImagePath,
    String? backImagePath,
    String? lumeImagePath,
    bool? frontImageSynced,
    bool? backImageSynced,
    bool? lumeImageSynced,
  }) {
    return Watches.fromJson({
      'id': id,
      'manufacturer': 'Omega',
      'model': 'Speedmaster',
      'favourite': false,
      'service_interval': 5,
      'wear_list': <String>[],
      'front_image_path': frontImagePath,
      'back_image_path': backImagePath,
      'lume_image_path': lumeImagePath,
      'updated_at': updatedAt?.toIso8601String(),
      'is_deleted': isDeleted ?? false,
      'front_image_synced': frontImageSynced ?? false,
      'back_image_synced': backImageSynced ?? false,
      'lume_image_synced': lumeImageSynced ?? false,
    })
      ..id = id
      ..updatedAt = updatedAt
      ..isDirty = isDirty
      ..isDeleted = isDeleted
      ..frontImageSynced = frontImageSynced
      ..backImageSynced = backImageSynced
      ..lumeImageSynced = lumeImageSynced;
  }

  test('migrateExistingWatches does not re-dirty already-synced watches', () async {
    final box = Hive.box<Watches>('WatchBox');
    final syncedTime = DateTime.utc(2026, 1, 1);
    final watch = buildBaseWatch(
      id: 'watch-1',
      updatedAt: syncedTime,
      isDirty: false,
      isDeleted: false,
      frontImagePath: '/img/f.jpg',
      backImagePath: '/img/b.jpg',
      lumeImagePath: '/img/l.jpg',
      frontImageSynced: true,
      backImageSynced: true,
      lumeImageSynced: true,
    );
    await box.add(watch);

    CloudMigrationUtil.migrateExistingWatches();

    final saved = box.values.first;
    expect(saved.isDirty, isFalse);
    expect(saved.frontImageSynced, isTrue);
    expect(saved.backImageSynced, isTrue);
    expect(saved.lumeImageSynced, isTrue);
    expect(saved.updatedAt, syncedTime);
  });

  test('migrateExistingWatches initializes missing sync metadata and marks dirty', () async {
    final box = Hive.box<Watches>('WatchBox');
    final watch = buildBaseWatch(
      frontImagePath: '/img/f.jpg',
      backImagePath: '',
      lumeImagePath: '/img/l.jpg',
    );
    await box.add(watch);

    CloudMigrationUtil.migrateExistingWatches();

    final saved = box.values.first;
    expect(saved.id, isNotNull);
    expect(saved.id, isNotEmpty);
    expect(saved.updatedAt, isNotNull);
    expect(saved.isDeleted, isFalse);
    expect(saved.isDirty, isTrue);
    expect(saved.frontImageSynced, isFalse);
    expect(saved.backImageSynced, isTrue);
    expect(saved.lumeImageSynced, isFalse);
  });

  test('migrateExistingWatches with forceDirty resets non-empty image sync flags', () async {
    final box = Hive.box<Watches>('WatchBox');
    final watch = buildBaseWatch(
      id: 'watch-2',
      updatedAt: DateTime.utc(2026, 1, 1),
      isDirty: false,
      isDeleted: false,
      frontImagePath: '/img/f.jpg',
      backImagePath: '',
      lumeImagePath: '/img/l.jpg',
      frontImageSynced: true,
      backImageSynced: true,
      lumeImageSynced: true,
    );
    await box.add(watch);

    CloudMigrationUtil.migrateExistingWatches(forceDirty: true);

    final saved = box.values.first;
    expect(saved.isDirty, isTrue);
    expect(saved.frontImageSynced, isFalse);
    expect(saved.backImageSynced, isTrue);
    expect(saved.lumeImageSynced, isFalse);
  });
}
