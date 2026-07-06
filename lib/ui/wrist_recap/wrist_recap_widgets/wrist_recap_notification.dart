import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_monthly.dart';

class WristRecapNotification extends StatelessWidget {
  const WristRecapNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          //SizedBox to give card height
          const SizedBox(height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 0.0),
                  child: Icon(FontAwesomeIcons.xmark),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image:  AssetImage('assets/icon/drawerheader.png'),
                    fit: BoxFit.contain
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("New Wrist Recap available!", style: Theme.of(context).textTheme.bodyLarge,),
              FittedBox(child: Text("Click to check your last months stats", style: Theme.of(context).textTheme.bodyMedium,))
            ],
          ),
          Expanded(
            child: IconButton(
                icon: Icon(FontAwesomeIcons.chevronRight),
                onPressed: () {
                  var now = DateTime.now();
                  var lastMonth = DateTime(now.year, now.month-1);
                  Get.to(() => WristRecapMonthly(month: lastMonth.month, year: lastMonth.year));
                }),
          )
        ],
      ),

    );
  }
}
