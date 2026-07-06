import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wrist_recap_controllers/wrist_recap_monthly_controller.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/insight_card.dart';

class WristRecapInsights extends StatelessWidget {
  WristRecapInsights({super.key});

  final recapController = Get.put(WristRecapMonthlyController());

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Insights",style: Theme.of(context).textTheme.bodyLarge),
              Obx(() => GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: _getInsights(),
              )),
            ],
          ),
        ));
  }

  List<InsightCard> _getInsights(){
    List<InsightCard> insights = [];
    if(recapController.watchesWorn.length > 0) {
      int wearcount = recapController.watchesWorn.length;
      //Get total watches worn
      insights.add(InsightCard(
          title: "Watches worn",
          value: wearcount.toString(),
      valueBig: true,));
      //Get wears tracked per day
      //TODO: handle months with less than a full track - get first wear entry in the month and if later than the 1st of the month reduce count
      int days = DateUtils.getDaysInMonth(recapController.year.value, recapController.month.value);
      insights.add(InsightCard(title: "Wears per day", value: (wearcount/days).toStringAsFixed(1), valueBig: true,));
      //Top Brand
      insights.add(InsightCard(title: "Top Brand", value: recapController.brandsWorn.first.manufacturer, valueBig: false,));
      if(recapController.categoriesWorn.length >0) insights.add(InsightCard(title: "Top Category", value: recapController.categoriesWorn.first.category,
          valueBig: false));
    }
    return insights;
  }
}
