import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/accuracy_controller.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

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
    //On build, set the value of watch time to 1 minute ahead (ignore seconds)
    var now = DateTime.now();
    var nowPlus = now.add(Duration(minutes: 1));
    widget.accuracyController.updateWatchDateTime(DateTime(nowPlus.year, nowPlus.month, nowPlus.day, nowPlus.hour, nowPlus.minute));
    return Scaffold(
      appBar: AppBar(title: const Text("Accuracy Tracker"),),
      body: Column(
        children: [
          Obx(()=> Text("Time now: $now, \nPlus one: $nowPlus, \nController: ${widget.accuracyController.watchDateTime}")),
          Obx(()=> SwitchListTile(
            title: const Text("24 Hour Display:"),
              value: widget.accuracyController.militaryTime.value,
              onChanged:(value) =>widget.accuracyController.updateMilitaryTime(value) )),
          Obx(()=> SwitchListTile(
              title: const Text("Baseline measurement:"),
              value: widget.accuracyController.baseLine.value,
              onChanged:(value) =>widget.accuracyController.updateBaseline(value) )),
          IconButton(
            icon: Icon(FontAwesomeIcons.caretUp),
            onPressed: ()=> widget.accuracyController.addAMinute(),
          ),
          Obx(()=> Text(WristCheckFormatter.getShortTime(widget.accuracyController.watchDateTime.value, widget.accuracyController.militaryTime.value),
            style: Theme.of(context).textTheme.headlineLarge ,)),
          IconButton(
            icon: Icon(FontAwesomeIcons.caretDown),
            onPressed: ()=> widget.accuracyController.subtractAMinute(),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("00 seconds", style: Theme.of(context).textTheme.headlineSmall,),
              ),
              onPressed: (){},
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 15.0, 25.0, 15.0),
                child: ElevatedButton(
                  child: Text("45 seconds", style: Theme.of(context).textTheme.bodyLarge,),
                  onPressed: (){},
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 15.0, 8.0, 15.0),
                child: ElevatedButton(
                  child: Text("15 seconds",style: Theme.of(context).textTheme.bodyLarge,),
                  onPressed: (){},
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              child: Text("30 seconds", style: Theme.of(context).textTheme.bodyLarge,),
              onPressed: (){},
            ),
          ),
          const Divider(thickness: 2,)
        ],
      ),
    );
  }
}
