import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wrist_recap_controllers/wrist_recap_monthly_controller.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/collection_movement.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/monthly_brand_chart.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/monthly_category_chart.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/monthly_wear_chart.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/status_wear_chart.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/watches_worn_carousel.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/wrist_recap_insights.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/empty_data.dart';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(FontAwesomeIcons.chevronLeft),
                onPressed: () => recapController.decrementMonth(),
              ),
              Expanded(
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Obx(() => recapController.isLastMonth.value
                      //     ? Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: Text(
                      //           "Last Month",
                      //           style: Theme.of(context).textTheme.bodyLarge,
                      //         ),
                      //       )
                      //     : const SizedBox(height: 0)),
                      Obx(() => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${WristCheckFormatter.getMonthFullName(recapController.month.value)} ${recapController.year.value}",
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.chevronRight),
                onPressed: () => recapController.incrementMonth(),
              ),
            ],
          ),
          const Divider(
            thickness: 2,
          ),
          Expanded(
            child: Obx(() => _dataExists(recapController.watchesWorn.isNotEmpty,
                recapController.watchesBought.isNotEmpty,
                recapController.watchesSold.isNotEmpty)
                ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => recapController.watchesWorn.isEmpty
                        ? const SizedBox(height: 0)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              WatchesWornCarousel(),
                              MonthlyWearChart(),
                            ],
                          )),
                    //Show bought/sold section if any movement in the collection
                    Obx(() => recapController.watchesBought.isNotEmpty || recapController.watchesSold.isNotEmpty ? CollectionMovement() : const SizedBox(height: 0)),
                    //Show insights if watches have been worn
                    Obx(() => recapController.watchesWorn.isNotEmpty ? WristRecapInsights() : const SizedBox(height: 0)),
                    //Show brand chart if any brand worn more than once
                    Obx(() => recapController.duplicateBrand.value ? MonthlyBrandChart() : const SizedBox(height: 0,)),
                    Obx(() => recapController.categoriesWorn.length > 1 ? MonthlyCategoryChart() : const SizedBox(height: 0)),
                    Obx(() => recapController.statusWorn.length > 1 ? StatusWearChart() : const SizedBox(height: 0)),
                    //Space at bottom of page
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
                //If the _dataExists check is false show a 'no data' placeholder
              ) : WristRecapEmptyData(),
            ),
          ),
        ],
      ),
    );
  }

  bool _dataExists(bool watchesWorn, bool watchesBought, bool watchesSold){
    return watchesWorn || watchesBought || watchesSold;
  }

}
