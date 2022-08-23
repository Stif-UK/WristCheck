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
        //Button 1: Link to Wear Stats
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: (MediaQuery.of(context).size.width)*0.8,
            height: (MediaQuery.of(context).size.height)*0.15,
            child: ElevatedButton(
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("Wear Stats",
                style: TextStyle(
                  fontSize: 30,
                ),),
              ),
              onPressed: (){ Get.to(() => const WearStats());},
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: const BorderSide(color: Colors.black)
                        )

    )
    )
    ),
          ),
          ),


        //Button 2: Link to Collection Stats
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: (MediaQuery.of(context).size.width)*0.8,
            height: (MediaQuery.of(context).size.height)*0.15,
            child: ElevatedButton(
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Collection Stats",
                    style: TextStyle(
                      fontSize: 30,
                    ),),
                ),
                onPressed: (){ },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: const BorderSide(color: Colors.black)
                        )

                    )
                )
            ),
          ),
        ),


        //Button 3: Link to Watch Stats
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: (MediaQuery.of(context).size.width)*0.8,
            height: (MediaQuery.of(context).size.height)*0.15,
            child: ElevatedButton(
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Watch Stats",
                    style: TextStyle(
                      fontSize: 30,
                    ),),
                ),
                onPressed: (){ },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: const BorderSide(color: Colors.black)
                        )

                    )
                )
            ),
          ),
        )

      ],
    );

  }
}


//Saving this to re-use later
// return Container(
// alignment: Alignment.center,
// child: const Text("Nothing to show yet!\n\nTrack wearing your watches to display graphs.", textAlign: TextAlign.center,),
// );