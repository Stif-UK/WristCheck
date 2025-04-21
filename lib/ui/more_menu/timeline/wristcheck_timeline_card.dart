import 'package:flutter/material.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class WristCheckTimelineCard extends StatelessWidget {
  WristCheckTimelineCard({super.key, required this.description, required this.date});

  final DateTime date;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.deepPurple[100],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: _getStyledText(WristCheckFormatter.getFormattedDate(date)),),
          _getStyledText(description)
        ],
      ),
    );
  }
}

_getStyledText(String text){
  return Text(text, style: TextStyle(color: Colors.black), textAlign: TextAlign.start,);
}
