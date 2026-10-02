import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/util/helper_classes.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/ui/widgets/animations/wt_annual_recap_animation.dart';

class AnimatedRecapPreviewPage extends StatefulWidget {
  const AnimatedRecapPreviewPage({super.key});

  @override
  State<AnimatedRecapPreviewPage> createState() => _AnimatedRecapPreviewPageState();
}

class _AnimatedRecapPreviewPageState extends State<AnimatedRecapPreviewPage> {
  late String watchStyle;
  late double timeSec;
  late double timeMin;
  late double timeHour;
  late double timeHourDIG;
  late String timeDay;
  late double timeDate;
  late String top1Watch;
  late String top2Watch;
  late String top3Watch;

  @override
  void initState() {
    super.initState();
    _loadDataAndCalculateTime();
  }

  void _loadDataAndCalculateTime() {
    // 1. Calculate date and time using DateTime.now() at load point
    final now = DateTime.now();
    timeSec = now.second.toDouble();
    timeMin = now.minute.toDouble();
    timeHour = now.hour.toDouble();
    timeHourDIG = (now.hour * 60 + now.minute).toDouble();
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    timeDay = days[now.weekday - 1];
    timeDate = now.day.toDouble();

    // 2. Fetch watches worn in 2026 from WatchBox database
    try {
      List<WornWatchesClass> worn2026 = Boxes.getWatchesWornFilter(Boxes.getAllNonArchivedWatches(), null, 2026);
      worn2026.sort((a, b) => b.count.compareTo(a.count));

      top1Watch = worn2026.isNotEmpty ? worn2026[0].watch.toString() : "Not Found";
      top2Watch = worn2026.length > 1 ? worn2026[1].watch.toString() : "Not Found";
      top3Watch = worn2026.length > 2 ? worn2026[2].watch.toString() : "Not Found";

      watchStyle = worn2026.isNotEmpty
          ? _mapCategoryToAnimationStyle(worn2026[0].watch.category)
          : "DIVER";
    } catch (_) {
      top1Watch = "Not Found";
      top2Watch = "Not Found";
      top3Watch = "Not Found";
      watchStyle = "DIVER";
    }
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
      case CategoryEnum.field:
        return 'FIELD';
      case CategoryEnum.flight:
        return 'PILOT';
      case CategoryEnum.sports:
      case CategoryEnum.chronograph:
        return 'SPORTS';
      case CategoryEnum.smartWatch:
        return 'SMART';
      case CategoryEnum.casual:
      case CategoryEnum.tool:
      case CategoryEnum.travel:
      case CategoryEnum.general:
      case CategoryEnum.blank:
        return 'DIVER';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your animated recap"),
        backgroundColor: WristCheckConfig.getWCColour(),
      ),
      body: SizedBox.expand(
        child: WTAnnualRecapAnimation(
          fallbackIconDimensions: 200,
          watchStyle: watchStyle,
          timeSec: timeSec,
          timeMin: timeMin,
          timeHour: timeHour,
          timeHourDIG: timeHourDIG,
          timeDay: timeDay,
          timeDate: timeDate,
          top1Watch: top1Watch,
          top2Watch: top2Watch,
          top3Watch: top3Watch,
        ),
      ),
    );
  }
}
