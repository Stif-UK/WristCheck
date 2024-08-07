import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/watchbox_ordering.dart';
import 'package:get/get.dart';
import 'package:wristcheck/model/enums/watchbox_view.dart';


class WatchOrderBottomSheet extends StatefulWidget {
  WatchOrderBottomSheet({Key? key}) : super(key: key);
  final wristCheckController = Get.put(WristCheckController());

  @override
  State<WatchOrderBottomSheet> createState() => _WatchOrderBottomSheetState();
}

class _WatchOrderBottomSheetState extends State<WatchOrderBottomSheet> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;


  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "order_sheet");

    WatchOrder currentOrder = widget.wristCheckController.watchboxOrder.value ?? WatchOrder.watchbox;
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
          //Header#
          Obx(
                ()=> Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.list),
                ),
                const Text("List"),
                Switch(
                  value: widget.wristCheckController.watchBoxView.value == WatchBoxView.grid,
                  onChanged: (value) async {
                    analytics.logEvent(name: "view_set",
                        parameters: {
                      "is_grid": value.toString()
                        });
                    widget.wristCheckController.updateWatchBoxView();
                  },
                ),
                const Text("Grid"),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.grid_view),
                )
              ],
            ),
          ),

          Row(
            children: [
              Expanded(
                child: Text("Display Order:",
                style: Theme.of(context).textTheme.headlineSmall,),
              ),

            ],
          ),
          const SizedBox(height: 20,),

          RadioListTile(
            title: const Text("In order of entry"),
              value: WatchOrder.watchbox,
              groupValue: currentOrder,
              onChanged: (value) async {
              await widget.wristCheckController.updateWatchOrder(value as WatchOrder);
                  setState(() {
                  });
              }
          ),
          RadioListTile(
              title: const Text("In reverse order of entry"),
              value: WatchOrder.reverse,
              groupValue: currentOrder,
              onChanged: (value) async {
                  await widget.wristCheckController.updateWatchOrder(value as WatchOrder);
                  setState(() {
                  });
              }
          ),
          RadioListTile(
              title: const Text("A-Z by manufacturer"),
              value: WatchOrder.alpha_asc,
              groupValue: currentOrder,
              onChanged: (value) async {
                await widget.wristCheckController.updateWatchOrder(value as WatchOrder);
                setState(() {
                });
              }
          ),
          RadioListTile(
            title: const Text("Z-A by manufacturer"),
            value: WatchOrder.alpha_desc,
            groupValue: currentOrder,
            onChanged: (value) async {
              await widget.wristCheckController.updateWatchOrder(value as WatchOrder);
              setState(() {
              });
            }
          ),
          RadioListTile(
              title: const Text("Order by most worn"),
              value: WatchOrder.mostworn,
              groupValue: currentOrder,
              onChanged: (value) async {
                await widget.wristCheckController.updateWatchOrder(value as WatchOrder);
                setState(() {
                });
              }
          ),
          RadioListTile(
              title: const Text("Order by last worn date"),
              value: WatchOrder.lastworn,
              groupValue: currentOrder,
              onChanged: (value) async {
                await widget.wristCheckController.updateWatchOrder(value as WatchOrder);
                setState(() {
                });
              }
          )
        ],
      ),

    );
  }
}
