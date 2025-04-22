import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/timeline_controller.dart';
import 'package:wristcheck/ui/more_menu/timeline/timeline_body.dart';
import 'package:wristcheck/ui/more_menu/timeline/timeline_settings_bottomsheet.dart';

class WristCheckTimeline extends StatelessWidget {
  WristCheckTimeline({super.key});
  final timelineController = Get.put(TimelineController());

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Timeline"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: Icon(FontAwesomeIcons.gear),
            onPressed: (){
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context){
                      return TimelineSettingsBottomSheet();
                    }
                );
              },
            ),
          )
        ],
      ),
      body: Obx(() => TimelineBody(
          orderAscending: timelineController.timelineOrderAscending.value,
          showPurchases: timelineController.showPurchases.value,
          showSold: timelineController.showSales.value,
          showServiced: timelineController.showLastServiced.value,
          showWarranty: timelineController.showWarrantyEnd.value,
        ),
      )
    );
  }
}
