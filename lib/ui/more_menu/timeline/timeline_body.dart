import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/more_menu/timeline/wristcheck_timeline_tile.dart';
import 'package:wristcheck/util/timeline_helper.dart';

class TimelineBody extends StatelessWidget {
  const TimelineBody({super.key, required this.showPurchases, required this.showSold, required this.showServiced, required this.showWarranty, required this.orderAscending});

  final bool orderAscending;
  final bool showPurchases;
  final bool showSold;
  final bool showServiced;
  final bool showWarranty;


  @override
  Widget build(BuildContext context) {
    //Get Data
    List<TimeLineEvent> data = TimeLineHelper.getTimeLineData(orderAscending, showPurchases, showSold, showServiced, showWarranty);

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: data.isEmpty? _getEmptyDataPage() : ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index){
            return WristCheckTimelineTile(
              isFirst: index == 0,
              isLast: index == data.length-1,
              event: data[index],);
          },
        ),
      ),
    );
  }

  //Handle empty data
  Widget _getEmptyDataPage() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 100,),
          Center(
            child: Text("No data was found to display.\n\n"
                "Add dates to the 'schedule' tab for your watches to populate your timeline.", style: Theme.of(Get.context!).textTheme.bodyLarge,),
          ),
        ],
      ),
    );
  }
}
