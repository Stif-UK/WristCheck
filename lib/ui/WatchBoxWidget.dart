import 'package:flutter/material.dart';


class WatchBoxWidget extends StatefulWidget {
  const WatchBoxWidget({Key? key}) : super(key: key);

  @override
  State<WatchBoxWidget> createState() => _WatchBoxWidgetState();
}

class _WatchBoxWidgetState extends State<WatchBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text("Nothing to show here"),
    );
  }

}
