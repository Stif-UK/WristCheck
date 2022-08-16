import 'package:flutter/material.dart';
import 'package:wristcheck/model/watches.dart';

class WearDatesWidget extends StatefulWidget {
  // const WearDatesWidget({Key? key} ) : super(key: key);

  final Watches currentWatch;

  const WearDatesWidget({
    Key? key,
    required this.currentWatch});

  @override
  State<WearDatesWidget> createState() => _WearDatesWidgetState();
}

class _WearDatesWidgetState extends State<WearDatesWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.currentWatch.manufacturer} ${widget.currentWatch.model}"),
      ),
    );
  }
}
