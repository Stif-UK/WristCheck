import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path/path.dart' as p;
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/images_util.dart';

void main() {
  late Directory tempDir;
  late Directory imgDir;
  late Directory exportTargetDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('wristcheck_img_recovery_test_');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(WatchesAdapter());
    }
  });

  setUp(() async {
    imgDir = Directory(p.join(tempDir.path, 'img'));
    if (await imgDir.exists()) {
      await imgDir.delete(recursive: true);
    }
    await imgDir.create(recursive: true);

    exportTargetDir = Directory(p.join(tempDir.path, 'export_target'));
    if (await exportTargetDir.exists()) {
      await exportTargetDir.delete(recursive: true);
    }
    await exportTargetDir.create(recursive: true);

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

  Watches makeWatch({
    required String id,
    required String manufacturer,
    required String model,
    String? frontImagePath = '',
    String? backImagePath = '',
    String? lumeImagePath = '',
  }) {
    return Watches.fromJson({
      'id': id,
      'manufacturer': manufacturer,
      'model': model,
      'favourite': false,
      'service_interval': 5,
      'wear_list': <String>[],
      'front_image_path': frontImagePath,
      'back_image_path': backImagePath,
      'lume_image_path': lumeImagePath,
      'updated_at': DateTime.utc(2026, 1, 1).toIso8601String(),
      'is_deleted': false,
      'front_image_synced': true,
      'back_image_synced': true,
      'lume_image_synced': true,
    })
      ..isDirty = false;
  }

  test('exportAllImgDirectoryFiles exports full images and only orphaned fallback thumbnails', () async {
    await File(p.join(imgDir.path, '1111110OmegaSpeedmaster_front.jpg')).writeAsBytes([1, 2, 3]);
    await File(p.join(imgDir.path, '1111110OmegaSpeedmaster_front_thumb.png')).writeAsBytes([4, 5]);
    await File(p.join(imgDir.path, '2222220OmegaSpeedmaster_lume_thumb.png')).writeAsBytes([6, 7]);

    final result = await ImagesUtil.exportAllImgDirectoryFiles(
      exportTargetDir.path,
      imgDirOverride: imgDir,
    );

    expect(result.totalFilesScanned, 3);
    expect(result.fullImagesExported, 1);
    expect(result.thumbnailFallbacksExported, 1);
    expect(result.failedCount, 0);
    expect(result.exportDirectoryPath, isNotNull);

    final exportedNames = Directory(result.exportDirectoryPath!)
        .listSync()
        .whereType<File>()
        .map((f) => p.basename(f.path))
        .toSet();
    expect(
      exportedNames,
      equals({
        '1111110OmegaSpeedmaster_front.jpg',
        '2222220OmegaSpeedmaster_lume_thumb.png',
      }),
    );
  });

  test('relinkOrphanedImages restores wiped front/back/lume paths and preserves active ones', () async {
    final box = Hive.box<Watches>('WatchBox');

    final watch1 = makeWatch(
      id: 'w-1',
      manufacturer: 'Omega',
      model: 'Speedmaster Pro',
      frontImagePath: '/img/1000010OmegaSpeedmasterPro_front.jpg',
      backImagePath: '',
      lumeImagePath: '',
    );
    final key1 = await box.add(watch1);

    final watch2 = makeWatch(
      id: 'w-2',
      manufacturer: 'Seiko',
      model: 'SKX-007',
      frontImagePath: '',
      backImagePath: '',
      lumeImagePath: '',
    );
    await box.add(watch2);

    // Active file for watch1 front
    await File(p.join(imgDir.path, '1000010OmegaSpeedmasterPro_front.jpg')).writeAsBytes([1]);
    // Orphaned back & lume for watch1 (matching key1)
    await File(p.join(imgDir.path, '100002${key1}OmegaSpeedmasterPro_back.jpg')).writeAsBytes([2]);
    await File(p.join(imgDir.path, '100003${key1}OmegaSpeedmasterPro_lume.jpg')).writeAsBytes([3]);
    // Orphaned lume for watch2 with a shifted/different old key (99)
    await File(p.join(imgDir.path, '10000499SeikoSKX007_lume.jpg')).writeAsBytes([4]);
    // Thumbnail should not be linked directly
    await File(p.join(imgDir.path, '10000499SeikoSKX007_front_thumb.png')).writeAsBytes([5]);

    final result = await ImagesUtil.relinkOrphanedImages(
      imgDirOverride: imgDir,
      triggerSync: false,
    );

    expect(result.orphanedFilesFound, 3);
    expect(result.slotsRestored, 3);
    expect(result.watchesUpdated, 2);

    final updated1 = box.get(key1)!;
    expect(updated1.frontImagePath, '/img/1000010OmegaSpeedmasterPro_front.jpg');
    expect(updated1.backImagePath, '/img/100002${key1}OmegaSpeedmasterPro_back.jpg');
    expect(updated1.lumeImagePath, '/img/100003${key1}OmegaSpeedmasterPro_lume.jpg');
    expect(updated1.backImageSynced, isFalse);
    expect(updated1.lumeImageSynced, isFalse);
    expect(updated1.isDirty, isTrue);

    final updated2 = box.values.firstWhere((w) => w.id == 'w-2');
    expect(updated2.frontImagePath, isEmpty);
    expect(updated2.lumeImagePath, '/img/10000499SeikoSKX007_lume.jpg');
    expect(updated2.lumeImageSynced, isFalse);
    expect(updated2.isDirty, isTrue);
  });
}
