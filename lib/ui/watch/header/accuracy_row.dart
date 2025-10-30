import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 8.0, 0, 8.0),
      child: Row(
        children: [
          Expanded(child: Text("Accuracy:", style: Theme.of(context).textTheme.bodyLarge,)),
          ElevatedButton(
              child: Icon(FontAwesomeIcons.plus),
          onPressed: (){},)
        ],
      ),
    );
  }
}
