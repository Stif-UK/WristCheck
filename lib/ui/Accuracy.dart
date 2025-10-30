import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/accuracy_controller.dart';
import 'package:wristcheck/model/watches.dart';

class Accuracy extends StatefulWidget {
  Accuracy({super.key, required this.currentWatch});

  final Watches currentWatch;
  final accuracyController = Get.put(AccuracyController());

  @override
  State<Accuracy> createState() => _AccuracyState();
}

class _AccuracyState extends State<Accuracy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Accuracy Tracker"),),
      body: Container(
        child: Text("Watch Key: ${widget.currentWatch.key}"),
      ),
    );
  }
}
