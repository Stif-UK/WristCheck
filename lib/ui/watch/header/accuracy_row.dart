import 'package:flutter/material.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:get/get.dart';

class AccuracyRow extends StatelessWidget {
  AccuracyRow({super.key,
     this.currentWatch});

  final watchViewController = Get.put(WatchViewController());
  final Watches? currentWatch;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text("Test Row: Current watch =  ${currentWatch.toString()}", overflow: TextOverflow.ellipsis,))
      ],
    );
  }
}
