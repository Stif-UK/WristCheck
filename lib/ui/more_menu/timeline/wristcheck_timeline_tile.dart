import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:wristcheck/model/enums/timeline_type_enum.dart';
import 'package:wristcheck/ui/more_menu/timeline/wristcheck_timeline_card.dart';
import 'package:wristcheck/util/timeline_helper.dart';

class WristCheckTimelineTile extends StatelessWidget {
  WristCheckTimelineTile({super.key, required this.isFirst, required this.isLast, required this.event});

  final bool isFirst;
  final bool isLast;
  final TimeLineEvent event;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,

      indicatorStyle: IndicatorStyle(
        width: 40,
        color: TimeLineHelper.getTimeLineIndicatorColour(event.type),
        iconStyle: IconStyle(iconData: TimeLineHelper.getTimeLineIcon(event.type)!,
            color: Colors.white, fontSize: 25)
      ),

      endChild: WristCheckTimelineCard(event: event),
    );
  }
}
