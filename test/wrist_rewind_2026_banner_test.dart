import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_ce/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/developer/developer_stats.dart';
import 'package:wristcheck/ui/more_menu/more_menu.dart';
import 'package:wristcheck/ui/widgets/nba_notifications/wrist_rewind_2026_notification.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    await initializeDateFormatting();
    tempDir = await Directory.systemTemp.createTemp('wrist_rewind_banner_test_');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(WatchesAdapter());
    }
  });

  setUp(() async {
    Get.reset();
    if (Hive.isBoxOpen('WatchBox')) {
      await Hive.box<Watches>('WatchBox').clear();
    } else {
      await Hive.openBox<Watches>('WatchBox');
    }
    SharedPreferences.setMockInitialValues({
      'appPurchased': false,
      'locale': 'en_US',
    });
    await WristCheckPreferences.init();
  });

  tearDownAll(() async {
    if (Hive.isBoxOpen('WatchBox')) {
      await Hive.box<Watches>('WatchBox').close();
    }
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('2026 Wrist Rewind NBA banner lifecycle', () {
    test('does not show or start 7-day window when remote config is false', () async {
      final day1 = DateTime(2026, 12, 1, 10, 0);
      await WristCheckPreferences.setLastNBADate(day1);
      final controller = Get.put(WristCheckController());

      await controller.checkForNotifications(
        nowOverride: day1,
        wristRewindEnabledOverride: false,
      );

      expect(controller.showWristRewind2026.value, isFalse);
      expect(controller.activeNBA.value, isNot(isA<WristRewind2026Notification>()));
      expect(WristCheckPreferences.getWristRewind2026FirstShown(), isNull);
    });

    test('stays active for 7 days across sessions and same-day restarts until expired', () async {
      final day1 = DateTime(2026, 12, 1, 10, 0);
      await WristCheckPreferences.setLastNBADate(day1);

      // Day 1 launch
      var controller = Get.put(WristCheckController());
      await controller.checkForNotifications(
        nowOverride: day1,
        wristRewindEnabledOverride: true,
      );
      expect(controller.showWristRewind2026.value, isTrue);
      expect(controller.activeNBA.value, isA<WristRewind2026Notification>());
      expect(WristCheckPreferences.getWristRewind2026FirstShown(), day1);

      // Simulate same-day app restart (activeNBA reset, lastNBADate is still today)
      Get.reset();
      controller = Get.put(WristCheckController());
      await controller.checkForNotifications(
        nowOverride: day1.add(const Duration(hours: 4)),
        wristRewindEnabledOverride: true,
      );
      expect(controller.activeNBA.value, isA<WristRewind2026Notification>());

      // Day 6 (still within 7 days)
      Get.reset();
      controller = Get.put(WristCheckController());
      await controller.checkForNotifications(
        nowOverride: day1.add(const Duration(days: 6, hours: 23)),
        wristRewindEnabledOverride: true,
      );
      expect(controller.activeNBA.value, isA<WristRewind2026Notification>());

      // Day 7 (7 days elapsed -> expires)
      final day7 = day1.add(const Duration(days: 7));
      await WristCheckPreferences.setLastNBADate(day7);
      await controller.checkForNotifications(
        nowOverride: day7,
        wristRewindEnabledOverride: true,
      );
      expect(controller.activeNBA.value, isNot(isA<WristRewind2026Notification>()));
      expect(controller.activeNBA.value, isA<SizedBox>());
    });

    test('remains hidden once dismissed or followed', () async {
      final day1 = DateTime(2026, 12, 1, 10, 0);
      final controller = Get.put(WristCheckController());

      await controller.checkForNotifications(
        nowOverride: day1,
        wristRewindEnabledOverride: true,
      );
      expect(controller.activeNBA.value, isA<WristRewind2026Notification>());

      await controller.dismissWristRewind2026Notification();
      await Future<void>.delayed(Duration.zero);

      expect(WristCheckPreferences.getWristRewind2026Dismissed(), isTrue);
      expect(controller.activeNBA.value, isA<SizedBox>());

      // Next day within 7 days should stay dismissed
      final day2 = day1.add(const Duration(days: 2));
      await WristCheckPreferences.setLastNBADate(day2);
      await controller.checkForNotifications(
        nowOverride: day2,
        wristRewindEnabledOverride: true,
      );
      expect(controller.activeNBA.value, isNot(isA<WristRewind2026Notification>()));
    });

    testWidgets('WristRewind2026Notification displays animation inside a padded Card with chevron and without legacy text or dismiss button', (tester) async {
      final controller = Get.put(WristCheckController());
      const placeholderAnimation = SizedBox(
        key: Key('banner_animation_placeholder'),
        height: 120,
      );
      controller.activeNBA(const WristRewind2026Notification(
        animationOverride: placeholderAnimation,
      ));

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Obx(() => controller.activeNBA.value ?? const SizedBox.shrink()),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.byKey(const Key('banner_animation_placeholder')), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.text('Your 2026 Wrist Rewind is here!'), findsNothing);
      expect(find.text('Click here to see your animated year in review!'), findsNothing);
    });

    test('getWristRewind2026CountdownStatus and resetWristRewind2026Notification track and reset countdown', () async {
      final day1 = DateTime(2026, 12, 1, 10, 0);
      final controller = Get.put(WristCheckController());

      // Before starting
      var status = controller.getWristRewind2026CountdownStatus(nowOverride: day1);
      expect(status.firstShown, isNull);
      expect(status.isActive, isFalse);

      // Start countdown
      await controller.checkForNotifications(
        nowOverride: day1,
        wristRewindEnabledOverride: true,
      );
      status = controller.getWristRewind2026CountdownStatus(
        nowOverride: day1.add(const Duration(days: 2, hours: 3)),
      );
      expect(status.isActive, isTrue);
      expect(status.remaining, const Duration(days: 4, hours: 21));

      // Dismiss and verify reset restores a fresh 7-day countdown
      await controller.dismissWristRewind2026Notification();
      await Future<void>.delayed(Duration.zero);
      expect(controller.getWristRewind2026CountdownStatus().isDismissed, isTrue);

      final resetTime = day1.add(const Duration(days: 5));
      await controller.resetWristRewind2026Notification(
        enabledOverride: true,
        nowOverride: resetTime,
      );

      final afterReset = controller.getWristRewind2026CountdownStatus(nowOverride: resetTime);
      expect(afterReset.isDismissed, isFalse);
      expect(afterReset.firstShown, resetTime);
      expect(afterReset.remaining, const Duration(days: 7));
      expect(afterReset.isActive, isTrue);
      expect(controller.activeNBA.value, isA<WristRewind2026Notification>());
    });

    testWidgets('DeveloperStats Notifications tab shows countdown status and resets on button tap', (tester) async {
      final controller = Get.put(WristCheckController());
      final startedAt = DateTime.now().subtract(const Duration(days: 2));
      await WristCheckPreferences.setWristRewind2026FirstShown(startedAt);
      await WristCheckPreferences.setWristRewind2026Dismissed(true);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: DeveloperStats(
            initialTabIndex: 3,
            wristRewindEnabledOverride: true,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('2026 Wrist Rewind 7-Day Countdown'), findsOneWidget);
      expect(find.textContaining('Status: Dismissed / Followed'), findsOneWidget);
      expect(find.textContaining('Dismissed: true'), findsOneWidget);

      await tester.tap(find.byTooltip('Reset 7-day countdown'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 4));

      expect(WristCheckPreferences.getWristRewind2026Dismissed(), isFalse);
      expect(find.textContaining('Status: Active'), findsOneWidget);
      expect(find.textContaining('Dismissed: false'), findsOneWidget);
      expect(find.textContaining('6d 23h'), findsOneWidget);
      expect(controller.activeNBA.value, isA<WristRewind2026Notification>());
    });

    test('MoreMenu avoids mediumRectangle ad sizing and chooses compact ad sizes', () {
      expect(MoreMenu.adSizeForScreenHeight(667.0), AdSize.banner);
      expect(MoreMenu.adSizeForScreenHeight(800.0), AdSize.banner);
      expect(MoreMenu.adSizeForScreenHeight(850.0), AdSize.largeBanner);
      expect(MoreMenu.adSizeForScreenHeight(932.0), AdSize.largeBanner);
    });
  });
}
