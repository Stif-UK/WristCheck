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
      child: Text("Your watch-box is currently empty\n\nPress the red button to add watches to your collection",
      textAlign: TextAlign.center,),
    );
  }

}
