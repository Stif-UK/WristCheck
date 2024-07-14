import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/time_controller.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class TimeSetting extends StatefulWidget {
  final timeController = Get.put(TimeController());

  @override
  State<TimeSetting> createState() => _TimeSettingState();
}


class _TimeSettingState extends State<TimeSetting> {



  @override
  Widget build(BuildContext context) {
    updateTime();
    return PopScope(
      onPopInvoked: (bool didPop) => widget.timeController.updateIsTimerActive(!didPop),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => Text(widget.timeController.currentDate.value, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall,)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => Text(widget.timeController.currentTime.value, textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayMedium,)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("Last Synced:", style: Theme.of(context).textTheme.bodySmall,),
                    ),
                    SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(strokeWidth: 1.5,)
                    ),

                  ],
                ),
                const Divider(thickness: 2,),
                Obx(() => SwitchListTile(
                  title: Text("Beep Countdown"),
                    value: widget.timeController.enableBeep.value,
                    onChanged: (beep) => widget.timeController.updateBeepSetting(beep))),
                const Divider(thickness: 2,),
                Obx(() => SwitchListTile(
                  title: Text("24 hour time"),
                    value: widget.timeController.militaryTime.value,
                    onChanged: (mt) => widget.timeController.updateMilitaryTime(mt))),
                const Divider(thickness: 2,),
              ],
            ),
          ),
        ],
      ),
    );


  }

  updateTime() {
    Timer.periodic(Duration(milliseconds: 50), (Timer t) {
      if(!widget.timeController.isTimerActive.value){
        t.cancel();
      }
      var date = DateTime.now();
      triggerBeep(date.second);
      widget.timeController.currentDateTime(date);
      widget.timeController.currentTime(WristCheckFormatter.getTime(date, widget.timeController.militaryTime.value));
      widget.timeController.currentDate(WristCheckFormatter.getFormattedDateWithDay(date));

    });

  }

  triggerBeep(int current){
    final player = AudioPlayer();
    var triggerList = [57, 58, 59, 00];
    if(triggerList.contains(current)) {
      if(widget.timeController.enableBeep.value) {
        if (current != widget.timeController.lastBeep.value) {
          current == 00
              ? player.play(AssetSource('audio/main_chime1.mp3'))
              : player.play(AssetSource('audio/chime1.mp3'));
        }
        ;
      }
      widget.timeController.updateLastBeep(current);
    }
  }

  @override
  void dispose() {
    widget.timeController.isTimerActive(false);
    Get.delete<TimeController>();
    super.dispose();
  }

  @override
  void initState() {
    widget.timeController.isTimerActive(true);
    super.initState();
  }
}
