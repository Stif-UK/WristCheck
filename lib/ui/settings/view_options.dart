import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/enums/watchbox_ordering.dart';
import 'package:wristcheck/model/enums/watchbox_view.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';
import 'package:wristcheck/util/list_tile_helper.dart';

class ViewOptions extends StatefulWidget {
  final wristCheckController = Get.put(WristCheckController());


  @override
  State<ViewOptions> createState() => _ViewOptionsState();
}

class _ViewOptionsState extends State<ViewOptions> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  BannerAd? banner;
  bool purchaseStatus = WristCheckPreferences.getAppPurchasedStatus() ?? false;

  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!purchaseStatus)
    {
      final adState = Provider.of<AdState>(context);
      adState.initialization.then((status) {
        setState(() {
          banner = BannerAd(
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.viewOptionsAdUnitID,
              //If the device screen is large enough display a larger ad on this screen
              size: AdSize.largeBanner,
              request: const AdRequest(),
              listener: adState.adListener)
            ..load();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "view_options");
    WatchOrder currentOrder = widget.wristCheckController.watchboxOrder.value ?? WatchOrder.watchbox;
    int homePage = WristCheckPreferences.getHomePageIndex();


    return Scaffold(
      appBar: AppBar(
        title: const Text("View Options"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                            analytics.logEvent(name: "homepage_updated",
                                parameters: {
                                  "homepage" : "collection"
                                });
                            WristCheckPreferences.setHomePageIndex(value);
                            setState(() {});
                          }
                      ),
                      RadioListTile(
                          title: const Text("Calendar View"),
                          value: 2,
                          groupValue: homePage,
                          onChanged:<int>(value) {
                            analytics.logEvent(name: "homepage_updated",
                                parameters: {
                                  "homepage" : "calendar_view"
                                });
                            WristCheckPreferences.setHomePageIndex(value);
                            setState(() {});
                          }
                      ),
                      RadioListTile(
                          title: const Text("Time Setting"),
                          value: 3,
                          groupValue: homePage,
                          onChanged:<int>(value) {
                            analytics.logEvent(name: "homepage_updated",
                                parameters: {
                                  "homepage" : "time_setting"
                                });
                             WristCheckPreferences.setHomePageIndex(value);
                             setState(() {});
                          }
                      )
              
                    ],
                  ),
                  const Divider(thickness: 2,),
                  ExpansionTile(
                    title: Text("Calendar Options", style: Theme.of(context).textTheme.headlineSmall),
                  leading: const Icon(FontAwesomeIcons.calendarWeek),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("First day of the week: ", style: Theme.of(context).textTheme.bodyLarge,),
                        ),
                        Obx(()=> DropdownButton(
                            value: widget.wristCheckController.firstDayOfWeek.value,
                              items: dayDropdownItems,
                              onChanged: (int? value) {
                                widget.wristCheckController.updateFirstDayOfWeek(
                                    value!);
                              }
                                    ),
                        ),
                      ],
                    )
                  ],)
                ],
              ),
            ),
          ),
          purchaseStatus? const SizedBox(height: 0,) : AdWidgetHelper.buildLargeAdSpace(banner, context),
          purchaseStatus? const SizedBox(height: 0,) : const SizedBox(height: 40,)
        ],
      ),
    );
  }
  List<DropdownMenuItem<int>> get dayDropdownItems{
    List<DropdownMenuItem<int>> menuItems = [
      DropdownMenuItem(child: Text("Monday"),value: 1),
      DropdownMenuItem(child: Text("Tuesday"),value: 2),
      DropdownMenuItem(child: Text("Wednesday"),value: 3),
      DropdownMenuItem(child: Text("Thursday"),value: 4),
      DropdownMenuItem(child: Text("Friday"),value: 5),
      DropdownMenuItem(child: Text("Saturday"),value: 6),
      DropdownMenuItem(child: Text("Sunday"),value: 7),
    ];
    return menuItems;
  }
}
