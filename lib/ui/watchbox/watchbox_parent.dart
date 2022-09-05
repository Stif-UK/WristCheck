import 'package:flutter/material.dart';
import 'package:wristcheck/ui/watchbox/WatchBoxWidget.dart';
import 'package:wristcheck/ui/watchbox/watchbox_header.dart';

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
      children:const [
        WatchBoxHeader(),

        Expanded(
            child: WatchBoxWidget())
      ]

    );
  }
}
