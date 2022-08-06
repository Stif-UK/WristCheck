import 'package:flutter/material.dart';
import 'package:wristcheck/model/watches.dart';

class ViewWatch extends StatelessWidget {
  //const ViewWatch({Key? key}) : super(key: key);

  final Watches currentWatch;
  ViewWatch({
    required this.currentWatch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${currentWatch.manufacturer} ${currentWatch.model}")
      ),
    );
  }
}
