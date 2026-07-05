import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wrist_recap_controllers/wrist_recap_monthly_controller.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/collection_movement.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/monthly_wear_chart.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/worn_watch_card.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class WristRecapMonthly extends StatelessWidget {
  WristRecapMonthly({super.key, required this.month, required this.year});

  final int month;
  final int year;
  final recapController = Get.put(WristRecapMonthlyController());

  @override
  Widget build(BuildContext context) {
    //Initialise the controller
    recapController.updateMonth(month);
    recapController.updateYear(year);
    //Run refresh in controller
    recapController.refresh();

    return Scaffold(
      appBar: AppBar(
        title: (Text("Wrist Recap")),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(icon: Icon(FontAwesomeIcons.gear),
            onPressed: (){},),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                    icon: Icon(FontAwesomeIcons.chevronLeft),
                onPressed: () => recapController.decrementMonth(),),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                        child: recapController.isLastMonth.value ? Text("Last Month", style: Theme.of(context).textTheme.bodyLarge,) : const SizedBox(height: 0,),
                      )),
                      Obx(() => Padding(
                        padding: const EdgeInsets.all(8.0),
                        //TODO: Update to include full month name
                        child: Text("${WristCheckFormatter.getMonthName(recapController.month.value)} ${recapController.year.value}",
                          style: Theme.of(context).textTheme.headlineSmall,),
                      )),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.chevronRight),
                  onPressed: () => recapController.incrementMonth(),),
              ],
            ),
            
            const Divider(thickness: 2,),
            
            Obx(() => recapController.watchesWorn.isEmpty
            //TODO: Handle empty data gracefully
              ? const SizedBox(height: 0,)
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Watches worn:", style: Theme.of(context).textTheme.bodyLarge,),
                  ),
                  SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: recapController.watchesWorn.length,
                        itemBuilder: (context, index) {
                          final wornWatch = recapController.watchesWorn[index];
                          return WornWatchCard(wornWatch: wornWatch);
                        },
                      ),
                    ),
                  MonthlyWearChart(),
                ],
              )
            ),
            Obx(()=> recapController.watchesBought.length > 0 || recapController.watchesSold.length > 0 ?
            CollectionMovement() : const SizedBox(height: 0,)),
            const SizedBox(height: 50,)

          ],
        ),
      ),
    );
  }

  Widget _wristRecapGridViewTile(BuildContext context, String title, String value, String? subtitle) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Center(
        child: Column(
          children: [
            Text(title),
            Text(value),
            Text(subtitle ?? "")
          ],
        )
        ),
      );
  }
}
