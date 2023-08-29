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


  @override
  Widget build(BuildContext context) {

    WatchOrder currentOrder = widget.wristCheckController.watchboxOrder.value ?? WatchOrder.watchbox;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white38,
        shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
      ),
      height: MediaQuery.of(context).size.height*0.85,
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Header
          Row(
            children: [
              Expanded(
                child: Text("Collection Display Order",
                style: Theme.of(context).textTheme.headlineSmall,),
              ),
              Obx(
              () => IconButton(
                  icon: widget.wristCheckController.watchBoxView.value == WatchBoxView.list? const Icon(Icons.list): const Icon(Icons.grid_view),
                    onPressed: (){
                    widget.wristCheckController.updateWatchBoxView();
                    }),
              )
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
              title: const Text("Alphabetic by manufacturer"),
              value: WatchOrder.alpha_asc,
              groupValue: currentOrder,
              onChanged: (value) async {
                await widget.wristCheckController.updateWatchOrder(value as WatchOrder);
                setState(() {
                });
              }
          ),
          RadioListTile(
            title: const Text("Reverse alphabetic by manufacturer"),
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
