import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/time_controller.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class TimeSetting extends StatefulWidget {
  //const TimeSetting({super.key});

  @override
  State<TimeSetting> createState() => _TimeSettingState();
}



class _TimeSettingState extends State<TimeSetting> {


  @override
  Widget build(BuildContext context) {
    final timeController = Get.put(TimeController());
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // SizedBox(width: MediaQuery.sizeOf(context).width*0.18,),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Obx(() => Text(timeController.currentDate.value, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall,)),
              ),
              Obx(() => Text(timeController.currentTime.value, textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayMedium,)),
              const Divider(thickness: 2,),
              Obx(() => SwitchListTile(
                title: Text("Beep Countdown"),
                  value: timeController.enableBeep.value,
                  onChanged: (beep) => timeController.updateBeepSetting(beep))),
              const Divider(thickness: 2,),
              Obx(() => SwitchListTile(
                title: Text("24 hour time"),
                  value: timeController.militaryTime.value,
                  onChanged: (mt) => timeController.updateMilitaryTime(mt))),
              const Divider(thickness: 2,),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    Get.delete<TimeController>();
    super.dispose();
  }
}
