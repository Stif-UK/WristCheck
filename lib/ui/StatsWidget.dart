import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/wearStats.dart';

class StatsWidget extends StatefulWidget {
  const StatsWidget({Key? key}) : super(key: key);

  @override
  State<StatsWidget> createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("All-time Wear Stats",
              style: TextStyle(
                fontSize: 30,
              ),),
            ),
            onPressed: (){ Get.to(() => WearStats());},
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(color: Colors.black)
                      )

    )
    )
    ),
          ),

      ],
    );

  }
}


//Saving this to re-use later
// return Container(
// alignment: Alignment.center,
// child: const Text("Nothing to show yet!\n\nTrack wearing your watches to display graphs.", textAlign: TextAlign.center,),
// );