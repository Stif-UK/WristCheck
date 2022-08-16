import 'package:flutter/material.dart';

class StatsWidget extends StatefulWidget {
  const StatsWidget({Key? key}) : super(key: key);

  @override
  State<StatsWidget> createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: const Text("Nothing to show yet!\n\nTrack wearing your watches to display graphs.", textAlign: TextAlign.center,),
    );
  }
}
