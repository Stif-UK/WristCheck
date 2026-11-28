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
    ..status = 'In Collection'
    ..purchaseDate = null
    ..soldDate = null;
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

  group('AnimatedRecapPreviewPage.hasEnoughDataForRewind', () {
    test('returns false when 2026 tracked wears is below 30', () {
      expect(AnimatedRecapPreviewPage.hasEnoughDataForRewind(0), isFalse);
      expect(AnimatedRecapPreviewPage.hasEnoughDataForRewind(29), isFalse);
    });

    test('returns true when 2026 tracked wears is 30 or more', () {
      expect(AnimatedRecapPreviewPage.hasEnoughDataForRewind(30), isTrue);
      expect(AnimatedRecapPreviewPage.hasEnoughDataForRewind(31), isTrue);
      expect(AnimatedRecapPreviewPage.hasEnoughDataForRewind(365), isTrue);
    });
  });

  group('AnimatedRecapPreviewPage.computeBoughtAndSoldForYear', () {
    test('counts non-deleted watches bought or sold in 2026 regardless of wearList or status', () {
      final watches = [
        // Bought in 2026, never worn
        _makeWatch('BoughtUnworn', 'Diver')
          ..purchaseDate = DateTime(2026, 2, 14)
          ..isDeleted = false,
        // Bought AND sold in 2026, archived, never worn
        _makeWatch('BoughtAndSoldArchived', 'Dress')
          ..status = 'Archived'
          ..purchaseDate = DateTime(2026, 1, 5)
          ..soldDate = DateTime(2026, 8, 20)
          ..isDeleted = null,
        // Bought earlier, sold in 2026
        _makeWatch('SoldOnly2026', 'Pilot')
          ..status = 'Sold'
          ..purchaseDate = DateTime(2024, 5, 1)
          ..soldDate = DateTime(2026, 11, 1)
          ..isDeleted = false,
        // Deleted watch should be excluded even with 2026 dates
        _makeWatch('DeletedWatch', 'Sports')
          ..purchaseDate = DateTime(2026, 3, 10)
          ..soldDate = DateTime(2026, 4, 10)
          ..isDeleted = true,
        // Different years should be excluded
        _makeWatch('OtherYearWatch', 'Field')
          ..purchaseDate = DateTime(2025, 12, 31)
          ..soldDate = DateTime(2027, 1, 1)
          ..isDeleted = false,
      ];

      final result = AnimatedRecapPreviewPage.computeBoughtAndSoldForYear(
        watches,
        year: 2026,
      );

      expect(result.bought, 2);
      expect(result.sold, 2);
    });
  });
}
