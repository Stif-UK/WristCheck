import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/watchbox_ordering.dart';
import 'package:wristcheck/model/enums/watchbox_view.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/util/list_tile_helper.dart';

class ViewOptions extends StatefulWidget {
  final wristCheckController = Get.put(WristCheckController());


  @override
  State<ViewOptions> createState() => _ViewOptionsState();
}

class _ViewOptionsState extends State<ViewOptions> {
  @override
  Widget build(BuildContext context) {
    WatchOrder currentOrder = widget.wristCheckController.watchboxOrder.value ?? WatchOrder.watchbox;
    int homePage = WristCheckPreferences.getHomePageIndex();


    return Scaffold(
      appBar: AppBar(
        title: const Text("View Options"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ExpansionTile(
                leading: const Icon(Icons.watch),
                title: Text("Collection Display", style: Theme.of(context).textTheme.headlineSmall,),
                children: [
                  Obx(()=> RadioListTile(
                        title: const Text("Show collection as list"),
                        secondary: const Icon(FontAwesomeIcons.list),
                        value: WatchBoxView.list,
                        groupValue: widget.wristCheckController.watchBoxView.value,
                        onChanged: (value) async => await widget.wristCheckController.updateWatchBoxView()
                    ),
                  ),
                  Obx(()=> RadioListTile(
                      title: const Text("Show collection as grid"),
                      secondary: const Icon(FontAwesomeIcons.grip),
                      value: WatchBoxView.grid,
                        groupValue: widget.wristCheckController.watchBoxView.value,
                        onChanged: (value) async => await widget.wristCheckController.updateWatchBoxView()
                    ),
                  ),

                ],
              ),
            const Divider(thickness: 2,),
            Obx(()=> ExpansionTile(
                leading: ListTileHelper.getWatchOrderIcon(widget.wristCheckController.watchboxOrder.value),
                title: Text("Collection ordering", style: Theme.of(context).textTheme.headlineSmall,),
              children: [
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
            ),
            const Divider(thickness: 2,),
            ExpansionTile(
              leading: const Icon(FontAwesomeIcons.houseChimney),
              title: Text("Start Page", style: Theme.of(context).textTheme.headlineSmall,),
              children: [
                RadioListTile(
                    title: const Text("Watch Collection"),
                    value: 0,
                    groupValue: homePage,
                    onChanged:<int>(value) {
                      WristCheckPreferences.setHomePageIndex(value);
                      setState(() {});
                    }
                ),
                RadioListTile(
                    title: const Text("Calendar View"),
                    value: 2,
                    groupValue: homePage,
                    onChanged:<int>(value) {
                      WristCheckPreferences.setHomePageIndex(value);
                      setState(() {});
                    }
                ),
                RadioListTile(
                    title: const Text("Time Setting"),
                    value: 3,
                    groupValue: homePage,
                    onChanged:<int>(value) {
                       WristCheckPreferences.setHomePageIndex(value);
                       setState(() {});
                    }
                )

              ],
            ),
            const Divider(thickness: 2,)
          ],
        ),
      ),
    );
  }
}
