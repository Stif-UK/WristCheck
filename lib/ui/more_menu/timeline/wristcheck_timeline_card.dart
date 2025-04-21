import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/model/enums/timeline_type_enum.dart';
import 'package:wristcheck/util/timeline_helper.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class WristCheckTimelineCard extends StatelessWidget {
  WristCheckTimelineCard({super.key, required this.event});

  final TimeLineEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: event.type == TimeLineType.year ? null : Colors.deepPurple[100],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: event.type == TimeLineType.year ? [_getSectionText(event.description)]
            : [
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: _getStyledText(WristCheckFormatter.getFormattedDate(event.date)),),
          _getStyledText(event.description)
        ],
      ),
    );
  }
}

_getSectionText(String text){
  return Text(text, style: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: Theme.of(Get.context!).textTheme.headlineSmall!.fontSize,
  ),
  textAlign: TextAlign.center,);
}

_getStyledText(String text){
  return Text(text, style: TextStyle(color: Colors.black), textAlign: TextAlign.start,);
}
