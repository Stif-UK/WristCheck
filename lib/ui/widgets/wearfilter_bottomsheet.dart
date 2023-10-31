import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/chart_options.dart';


class WearFilterBottomSheet extends StatefulWidget {
  WearFilterBottomSheet({Key? key}) : super(key: key);
  //final wristCheckController = Get.put(WristCheckController());

  @override
  State<WearFilterBottomSheet> createState() => _WearFilterBottomSheetState();
}

class _WearFilterBottomSheetState extends State<WearFilterBottomSheet> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;


  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(screenName: "wearchart_bottomsheet");

    //WatchOrder currentOrder = widget.wristCheckController.watchboxOrder.value ?? WatchOrder.watchbox;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white38,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15),
      ),
      height: MediaQuery.of(context).size.height*0.65,
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text("Wear Chart Filters",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,),
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.gear),
                  onPressed: (){
                  Get.to(() => ChartOptions());
                  }),
            ],
          ),
          const Divider(thickness: 2,)
          //Header#
          ]
      ),

    );
  }
}
