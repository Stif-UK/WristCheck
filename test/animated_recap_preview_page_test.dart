import 'package:flutter_test/flutter_test.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/wrist_recap/animated_recap_preview_page.dart';
import 'package:wristcheck/util/helper_classes.dart';

Watches _makeWatch(String model, String? category) {
  return Watches()
    ..manufacturer = 'TestBrand'
    ..model = model
    ..category = category
    ..wearList = []
    ..favourite = false
    ..frontImagePath = ''
    ..backImagePath = ''
    ..lumeImagePath = ''
    ..status = 'In Collection';
}

void main() {
  group('AnimatedRecapPreviewPage.computeTopWatchStyle', () {
    test('returns Diver when worn list is empty', () {
      expect(AnimatedRecapPreviewPage.computeTopWatchStyle([]), 'Diver');
    });

    test('picks category with highest aggregated wear count instead of top watch category', () {
      final worn = [
        WornWatchesClass(_makeWatch('Submariner', 'Diver'), 10),
        WornWatchesClass(_makeWatch('Tank', 'Dress'), 7),
        WornWatchesClass(_makeWatch('Calatrava', 'Dress'), 6),
      ];

      expect(AnimatedRecapPreviewPage.computeTopWatchStyle(worn), 'Dress');
    });

    test('prefers non-blank category over unassigned category when non-blank exists', () {
      final worn = [
        WornWatchesClass(_makeWatch('Unassigned 1', null), 8),
        WornWatchesClass(_makeWatch('Unassigned 2', 'Not Selected'), 8),
        WornWatchesClass(_makeWatch('Speedmaster', 'Chronograph'), 5),
      ];

      expect(AnimatedRecapPreviewPage.computeTopWatchStyle(worn), 'Chronograph');
    });

    test('falls back to Not Selected when all worn watches have blank category', () {
      final worn = [
        WornWatchesClass(_makeWatch('Unassigned 1', null), 4),
        WornWatchesClass(_makeWatch('Unassigned 2', ''), 2),
      ];

      expect(AnimatedRecapPreviewPage.computeTopWatchStyle(worn), 'Not Selected');
    });
  });
}
