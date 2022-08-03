import 'package:flutter/material.dart';
import 'package:wristcheck/ui/WatchBoxWidget.dart';
import 'package:wristcheck/ui/watchbox_header.dart';

class WatchBoxParent extends StatefulWidget {
  const WatchBoxParent({Key? key}) : super(key: key);

  @override
  State<WatchBoxParent> createState() => _WatchBoxParentState();
}

class _WatchBoxParentState extends State<WatchBoxParent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children:[
        WatchBoxHeader(),

        Expanded(
            child: WatchBoxWidget())
      ]

    );
  }
}
