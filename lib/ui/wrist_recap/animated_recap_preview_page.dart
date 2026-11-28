import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/helper_classes.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/ui/widgets/animations/wt_annual_recap_animation.dart';

class AnimatedRecapPreviewPage extends StatefulWidget {
  const AnimatedRecapPreviewPage({super.key});

  static const int minWearsForRewind = 30;

  @visibleForTesting
  static bool hasEnoughDataForRewind(int totalWears2026) {
    return totalWears2026 >= minWearsForRewind;
  }

  /// Counts how many non-deleted watches have [purchaseDate] or [soldDate] in [year],
  /// regardless of whether they were worn during [year].
  @visibleForTesting
  static ({int bought, int sold}) computeBoughtAndSoldForYear(
    List<Watches> watches, {
    int year = 2026,
  }) {
    int bought = 0;
    int sold = 0;
    for (final watch in watches) {
      if (watch.isDeleted == true) continue;
      DateTime? purchaseDate;
      DateTime? soldDate;
      try {
        purchaseDate = watch.purchaseDate;
      } catch (_) {}
      try {
        soldDate = watch.soldDate;
      } catch (_) {}
      if (purchaseDate?.year == year) {
        bought++;
      }
      if (soldDate?.year == year) {
        sold++;
      }
    }
    return (bought: bought, sold: sold);
  }

  /// Returns the DB string of the watch category with the highest total wear count.
  /// Prefers non-blank categories if any worn watch has a category assigned.
  @visibleForTesting
  static String computeTopWatchStyle(List<WornWatchesClass> wornWatches) {
    if (wornWatches.isEmpty) {
      return 'Diver';
    }

    final Map<CategoryEnum, int> categoryCounts = {};
    for (final worn in wornWatches) {
      final category = CategoryEnumLocalization.fromDbString(worn.watch.category);
      categoryCounts[category] = (categoryCounts[category] ?? 0) + worn.count;
    }

    final nonBlankEntries = categoryCounts.entries.where((e) => e.key != CategoryEnum.blank);
    final candidates = nonBlankEntries.isNotEmpty ? nonBlankEntries : categoryCounts.entries;
    final topEntry = candidates.reduce((a, b) => a.value >= b.value ? a : b);
    return topEntry.key.toDbString();
  }

  @override
  State<AnimatedRecapPreviewPage> createState() => _AnimatedRecapPreviewPageState();
}

class _AnimatedRecapPreviewPageState extends State<AnimatedRecapPreviewPage> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final ScreenshotController _screenshotController = ScreenshotController();
  final GlobalKey _screenshotKey = GlobalKey();
  bool _isSharing = false;
  bool _hasLoggedFinalSlide = false;

  late bool enoughData;
  late double daysTracked;
  late double totalWearsTracked;
  late double watchesWorn;
  late double totalBought;
  late double totalSold;
  late String topWatchStyle;

  late String top1Watch;
  late double top1WatchWorn;
  late String topWatch1ICON;

  late String top2Watch;
  late double top2WatchWorn;
  late String topWatch2ICON;

  late String top3Watch;
  late double top3WatchWorn;
  late String topWatch3ICON;

  late String springWatchTEXT;
  late String springWatch;

  late String summerWatchTEXT;
  late String summerWatch;

  late String autumnWatchTEXT;
  late String autumnWatch;

  late String winterWatchTEXT;
  late String winterWatch;

  late double timeSec;
  late double timeMin;
  late double timeHour;
  late double timeHourDIG;
  late String timeDay;
  late double timeDate;

  @override
  void initState() {
    super.initState();
    analytics.setAnalyticsCollectionEnabled(true);
    analytics.logScreenView(screenName: 'animated_wrist_rewind');
    analytics.logEvent(name: 'animated_rewind_entered');
    _load2026Data();
  }

  void _load2026Data() {
    const year = 2026;
    final allWatches = Boxes.getAllNonArchivedWatches();

    // 0. Time & date inputs for "WristTrack rewind" clock physics animation
    final now = DateTime.now();
    timeSec = now.second.toDouble();
    timeMin = now.minute.toDouble();
    timeHour = now.hour.toDouble();
    timeHourDIG = (now.hour * 60 + now.minute).toDouble();
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    timeDay = days[now.weekday - 1];
    timeDate = now.day.toDouble();

    // 1. Calculate daysTracked and totalWearsTracked for 2026
    int totalWears = 0;
    final Set<String> daysSet = {};

    for (final watch in allWatches) {
      for (final date in watch.wearList) {
        if (date.year == year) {
          totalWears++;
          daysSet.add("${date.year}-${date.month}-${date.day}");
        }
      }
    }

    daysTracked = daysSet.length.toDouble();
    totalWearsTracked = totalWears.toDouble();
    enoughData = AnimatedRecapPreviewPage.hasEnoughDataForRewind(totalWears);

    // Count all non-deleted watches bought or sold in 2026 (including archived/sold watches,
    // regardless of whether they have wears recorded in 2026).
    final nonDeletedWatches = Boxes.getAllWatches()
        .where((watch) => watch.isDeleted != true)
        .toList();
    final boughtAndSold = AnimatedRecapPreviewPage.computeBoughtAndSoldForYear(
      nonDeletedWatches,
      year: year,
    );
    totalBought = boughtAndSold.bought.toDouble();
    totalSold = boughtAndSold.sold.toDouble();

    // 2. Fetch watches worn in 2026 from WatchBox database (fallback to all-time if 2026 has no wears yet)
    List<WornWatchesClass> worn2026 = [];
    try {
      worn2026 = Boxes.getWatchesWornFilter(allWatches, null, year);
      if (worn2026.isEmpty) {
        worn2026 = Boxes.getWatchesWornFilter(allWatches, null, null);
      }
      worn2026.sort((a, b) => b.count.compareTo(a.count));
    } catch (_) {}

    watchesWorn = worn2026.length.toDouble();

    topWatchStyle = AnimatedRecapPreviewPage.computeTopWatchStyle(worn2026);

    // Top 1 Watch
    if (worn2026.isNotEmpty) {
      top1Watch = worn2026[0].watch.toString();
      top1WatchWorn = worn2026[0].count.toDouble();
      topWatch1ICON = _mapCategoryToAnimationStyle(worn2026[0].watch.category);
    } else {
      top1Watch = "N/A";
      top1WatchWorn = 0;
      topWatch1ICON = "DIVER";
    }

    // Top 2 Watch
    if (worn2026.length > 1) {
      top2Watch = worn2026[1].watch.toString();
      top2WatchWorn = worn2026[1].count.toDouble();
      topWatch2ICON = _mapCategoryToAnimationStyle(worn2026[1].watch.category);
    } else {
      top2Watch = "N/A";
      top2WatchWorn = 0;
      topWatch2ICON = "DIVER";
    }

    // Top 3 Watch
    if (worn2026.length > 2) {
      top3Watch = worn2026[2].watch.toString();
      top3WatchWorn = worn2026[2].count.toDouble();
      topWatch3ICON = _mapCategoryToAnimationStyle(worn2026[2].watch.category);
    } else {
      top3Watch = "N/A";
      top3WatchWorn = 0;
      topWatch3ICON = "DIVER";
    }

    // 3. Seasonal Top Watches for 2026
    final spring = _getSeasonalTop(allWatches, [3, 4, 5], year);
    springWatchTEXT = spring.$1;
    springWatch = spring.$2;

    final summer = _getSeasonalTop(allWatches, [6, 7, 8], year);
    summerWatchTEXT = summer.$1;
    summerWatch = summer.$2;

    final autumn = _getSeasonalTop(allWatches, [9, 10, 11], year);
    autumnWatchTEXT = autumn.$1;
    autumnWatch = autumn.$2;

    final winter = _getSeasonalTop(allWatches, [12, 1, 2], year);
    winterWatchTEXT = winter.$1;
    winterWatch = winter.$2;
  }

  (String text, String icon) _getSeasonalTop(List<Watches> watches, List<int> months, int targetYear) {
    final Map<Watches, int> watchCounts = {};
    for (final watch in watches) {
      final c = watch.wearList.where((d) {
        if (months.contains(12) && d.month == 12) {
          return (d.year == targetYear - 1 || d.year == targetYear) && months.contains(d.month);
        }
        return d.year == targetYear && months.contains(d.month);
      }).length;
      if (c > 0) {
        watchCounts[watch] = c;
      }
    }
    // If no seasonal wears in 2026, fallback to all-time seasonal wears
    if (watchCounts.isEmpty) {
      for (final watch in watches) {
        final c = watch.wearList.where((d) => months.contains(d.month)).length;
        if (c > 0) watchCounts[watch] = c;
      }
    }
    if (watchCounts.isEmpty) {
      return ("N/A", "DIVER");
    }
    Watches? topWatch;
    int maxC = -1;
    watchCounts.forEach((watch, count) {
      if (count > maxC) {
        maxC = count;
        topWatch = watch;
      }
    });
    return (topWatch!.toString(), _mapCategoryToAnimationStyle(topWatch!.category));
  }

  String _mapCategoryToAnimationStyle(String? categoryStr) {
    final category = WristCheckFormatter.getCategoryEnum(categoryStr);
    switch (category) {
      case CategoryEnum.digital:
        return 'DIGITAL';
      case CategoryEnum.dive:
        return 'DIVER';
      case CategoryEnum.dress:
        return 'DRESS';
      case CategoryEnum.luxury:
        return 'DRESS';
      case CategoryEnum.field:
        return 'FIELD';
      case CategoryEnum.flight:
        return 'PILOT';
      case CategoryEnum.sports:
        return 'SPORTS';
      case CategoryEnum.chronograph:
        return 'PILOT';
      case CategoryEnum.smartWatch:
        return 'SMART';
      case CategoryEnum.casual:
        return 'DIGITAL';
      case CategoryEnum.tool:
        return 'FIELD';
      case CategoryEnum.travel:
        return 'PILOT';
      case CategoryEnum.general:
        return 'DIVER';
      case CategoryEnum.blank:
        return 'DIVER';
    }
  }

  void _onFinalSlide() {
    if (_hasLoggedFinalSlide) return;
    _hasLoggedFinalSlide = true;
    analytics.logEvent(name: 'animated_rewind_final_page');
  }

  Future<void> _shareRecap() async {
    if (_isSharing) return;
    _isSharing = true;
    analytics.logEvent(name: 'animated_rewind_share_pressed');
    try {
      final bytes = await _screenshotController.capture();
      if (bytes == null) return;
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/wristtrack_rewind_2026.png');
      await file.writeAsBytes(bytes);

      Rect? sharePositionOrigin;
      final renderBox = _screenshotKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final origin = renderBox.localToGlobal(Offset.zero);
        sharePositionOrigin = Rect.fromCenter(
          center: origin + renderBox.size.center(Offset.zero),
          width: 1,
          height: 1,
        );
      }

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'My WristTrack Rewind 2026',
          sharePositionOrigin: sharePositionOrigin,
        ),
      );
    } catch (e) {
      debugPrint('Error sharing WristTrack Rewind: $e');
    } finally {
      _isSharing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: WristCheckConfig.getWCColour(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: Material(
              color: Colors.black.withValues(alpha: 0.35),
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
          ),
        ),
      ),
      body: SizedBox.expand(
        child: Screenshot(
          key: _screenshotKey,
          controller: _screenshotController,
          child: WTAnnualRecapAnimation(
            fallbackIconDimensions: 200,
            onScreenshotTrigger: _shareRecap,
            onFinalSlide: _onFinalSlide,
            enoughData: enoughData,
            daysTracked: daysTracked,
            totalWearsTracked: totalWearsTracked,
            watchesWorn: watchesWorn,
            totalBought: totalBought,
            totalSold: totalSold,
            topWatchStyle: topWatchStyle,
            top1Watch: top1Watch,
            top1WatchWorn: top1WatchWorn,
            topWatch1ICON: topWatch1ICON,
            top2Watch: top2Watch,
            top2WatchWorn: top2WatchWorn,
            topWatch2ICON: topWatch2ICON,
            top3Watch: top3Watch,
            top3WatchWorn: top3WatchWorn,
            topWatch3ICON: topWatch3ICON,
            springWatchTEXT: springWatchTEXT,
            springWatch: springWatch,
            summerWatchTEXT: summerWatchTEXT,
            summerWatch: summerWatch,
            autumnWatchTEXT: autumnWatchTEXT,
            autumnWatch: autumnWatch,
            winterWatchTEXT: winterWatchTEXT,
            winterWatch: winterWatch,
            timeSec: timeSec,
            timeMin: timeMin,
            timeHour: timeHour,
            timeHourDIG: timeHourDIG,
            timeDay: timeDay,
            timeDate: timeDate,
          ),
        ),
      ),
    );
  }
}

