import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/enums/collection_view.dart';
import 'package:wristcheck/model/enums/watchbox_view.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/ui/decoration/formfield_decoration.dart';
import 'package:wristcheck/ui/search_widget.dart';
import 'package:wristcheck/ui/widgets/watchbox_gridview.dart';
import 'package:wristcheck/ui/widgets/watchbox_listview.dart';
import 'package:wristcheck/ui/widgets/watchorder_bottomsheet.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';
import 'package:wristcheck/util/list_tile_helper.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class Watchbox extends StatefulWidget {
  Watchbox({Key? key}) : super(key: key);
  final wristCheckController = Get.put(WristCheckController());




  @override
  State<Watchbox> createState() => _WatchBoxState();
}



class _WatchBoxState extends State<Watchbox> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  final items = CollectionView.values;
  CollectionView? collectionValue = CollectionView.all;

  BannerAd? banner;
  bool purchaseStatus = WristCheckPreferences.getAppPurchasedStatus() ?? false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!purchaseStatus)
    {
      final adState = Provider.of<AdState>(context);
      adState.initialization.then((status) {
        setState(() {
          banner = BannerAd(
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.watchboxBannerAdUnitID,
              //If the device screen is large enough display a larger ad on this screen
              size: AdSize.banner,
              request: const AdRequest(),
              listener: adState.adListener)
            ..load();
        });
      });
    }
  }


  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  final watchBox = Boxes.getWatches();

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "watchbox");

    return Obx( ()=> Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Insert Ad Widget into tree
          widget.wristCheckController.isAppPro.value || widget.wristCheckController.isDrawerOpen.value? const SizedBox(height: 0,) : AdWidgetHelper.buildSmallAdSpace(banner, context),
          //Create drop down and search button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Obx(
                  ()=> Container(

                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).disabledColor,
                          width: 2
                        ),
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                    child: IconButton(
                      icon: ListTileHelper.getWatchOrderIcon(widget.wristCheckController.watchboxOrder.value),
                      onPressed: (){
                        showModalBottomSheet(
                          isScrollControlled: true,
                            context: context,
                            builder: (context){
                              return WatchOrderBottomSheet();
                            }
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).disabledColor,
                            width: 2
                        ),
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropdownButtonHideUnderline(
                          child: DropdownButton<CollectionView>(
                            dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
                            items: items.map(buildMenuItem).toList(),
                            value: collectionValue,
                            onChanged: (value) async {
                              analytics.logEvent(name: "change_watchbox_view",
                              parameters: {
                                "view" : collectionValue.toString()
                              });
                              setState(() {
                                collectionValue = value;
                              });
                            },),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).disabledColor,
                          width: 2
                      ),
                      shape: BoxShape.rectangle,
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                  child: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      analytics.logEvent(name: "search_called");
                      showSearch(
                        context: context,
                        delegate: SearchWidget(),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          //Implement the watchbox view
          //Obx(()=> WatchboxListView(collectionValue: collectionValue!, watchOrder: widget.wristCheckController.watchboxOrder.value!))
          ValueListenableBuilder(
            valueListenable: watchBox.listenable(),
            builder: (context, box, _) {
              return Obx(() =>
              widget.wristCheckController.watchBoxView.value ==
                  WatchBoxView.list ?
              WatchboxListView(collectionValue: collectionValue!,
                  watchOrder: widget.wristCheckController.watchboxOrder.value!)
                  : WatchboxGridView(collectionValue: collectionValue!,
                  watchOrder: widget.wristCheckController.watchboxOrder.value!));

            }
    )

        ]

    ),
    );
  }

  DropdownMenuItem<CollectionView> buildMenuItem(CollectionView item) => DropdownMenuItem(
      value: item,
      child: Text(
        WristCheckFormatter.getCollectionText(item),
        style: Theme.of(context).textTheme.headlineSmall,
      )

  );
}
