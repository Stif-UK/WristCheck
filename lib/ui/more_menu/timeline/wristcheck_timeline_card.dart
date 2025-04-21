import 'package:flutter/material.dart';

class WristCheckTimelineCard extends StatelessWidget {
  WristCheckTimelineCard({super.key, required this.childWidget});

  final Widget childWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.deepPurple[100],
      ),
      child: childWidget,
    );
  }
}
