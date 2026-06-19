import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/watchbox_ordering.dart';
import 'package:get/get.dart';
import 'package:wristcheck/model/enums/watchbox_view.dart';
import 'package:wristcheck/ui/search_widget.dart';


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
      height: MediaQuery.of(context).size.height*0.85,
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Header#
          Row(
            children: [
              Obx(
                    ()=> Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
                        child: Icon(Icons.list),
                      ),
                      Text(AppLocalizations.of(context)!.listViewTitle),
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
                      Text(AppLocalizations.of(context)!.gridViewTitle),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.grid_view),
                      )
                                        ],
                                      ),
                    ),
              ),
              IconButton(
                  icon: Icon(FontAwesomeIcons.magnifyingGlass),
                  onPressed: () async {
            analytics.logEvent(name: "search_called");
            showSearch(
              context: context,
              delegate: SearchWidget(),
            );
          },
        )
            ],
          ),
          const Divider(thickness: 2,),

          Row(
            children: [
              Expanded(
                child: Text(AppLocalizations.of(context)!.displayOrderTitle,
                style: Theme.of(context).textTheme.headlineSmall,),
              ),

            ],
          ),
          const SizedBox(height: 20,),

          RadioListTile(
            title: Text(AppLocalizations.of(context)!.inOrderOfEntry),
              value: WatchOrder.watchbox,
              groupValue: currentOrder,
              onChanged: (value) async {
              await widget.wristCheckController.updateWatchOrder(value as WatchOrder);
                  setState(() {
                  });
              }
          ),
          RadioListTile(
              title: Text(AppLocalizations.of(context)!.inReverseOrderOfEntry),
              value: WatchOrder.reverse,
              groupValue: currentOrder,
              onChanged: (value) async {
                  await widget.wristCheckController.updateWatchOrder(value as WatchOrder);
                  setState(() {
                  });
              }
          ),
          RadioListTile(
              title: Text(AppLocalizations.of(context)!.azByManufacturer),
              value: WatchOrder.alpha_asc,
              groupValue: currentOrder,
              onChanged: (value) async {
                await widget.wristCheckController.updateWatchOrder(value as WatchOrder);
                setState(() {
                });
              }
          ),
          RadioListTile(
            title: Text(AppLocalizations.of(context)!.zaByManufacturer),
            value: WatchOrder.alpha_desc,
            groupValue: currentOrder,
            onChanged: (value) async {
              await widget.wristCheckController.updateWatchOrder(value as WatchOrder);
              setState(() {
              });
            }
          ),
          RadioListTile(
              title: Text(AppLocalizations.of(context)!.orderByMostWorn),
              value: WatchOrder.mostworn,
              groupValue: currentOrder,
              onChanged: (value) async {
                await widget.wristCheckController.updateWatchOrder(value as WatchOrder);
                setState(() {
                });
              }
          ),
          RadioListTile(
              title: Text(AppLocalizations.of(context)!.orderByLastWornDate),
              value: WatchOrder.lastworn,
              groupValue: currentOrder,
              onChanged: (value) async {
                await widget.wristCheckController.updateWatchOrder(value as WatchOrder);
                setState(() {
                });
              }
          ),
          const Divider(thickness: 2,),
          Obx(()=> SwitchListTile(
              title: Text(AppLocalizations.of(context)!.showLastWornDateOption),
                value: widget.wristCheckController.showLastWornDate.value,
                onChanged: (bool)=> widget.wristCheckController.updateShowLastWornDate(bool)),
          ),
          Obx(()=> SwitchListTile(
              title: Text(AppLocalizations.of(context)!.showWearCountOption),
              value: widget.wristCheckController.showWearCount.value,
              onChanged: (bool)=> widget.wristCheckController.updateShowWearCount(bool)),
          )
        ],
      ),

    );
  }
}
