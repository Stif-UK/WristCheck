import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/provider/db_provider.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/watch/watchview.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';



class SearchFinder extends StatefulWidget {
  final String query;

  const SearchFinder({Key? key, required this.query}) : super(key: key);

  @override
  State<SearchFinder> createState() => _SearchFinderState();
}

class _SearchFinderState extends State<SearchFinder> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

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
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.searchPageBannerAdUnitId,
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
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "search");
    DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context);
    return Column(
      children: [
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: Boxes.getWatches().listenable(),
            builder: (context, Box<Watches> watchBox, _) {
              ///* this is where we filter data
              var results = widget.query.isEmpty
                  ? watchBox.values.toList() // whole list
                  : watchBox.values
                  .where((c) => c.model.toLowerCase().contains(widget.query) || c.manufacturer.toLowerCase().contains(widget.query))
                  .toList();

              return results.isEmpty
                  ? const Center(
                child: Text(
                  'No results found !',
                ),
              )
                  : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  // passing as a custom list
                  final Watches watchesListItem = results[index];

                  return ListTile(
                    onTap: () {
                      Get.to(() => WatchView(currentWatch: watchesListItem,));
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${watchesListItem.manufacturer} ${watchesListItem.model}",
                          textScaleFactor: 1.1,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          watchesListItem.status!,
                          textScaleFactor: 0.9,
                          style: const TextStyle(fontStyle: FontStyle.italic),

                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        purchaseStatus? const SizedBox(height: 0,) : AdWidgetHelper.buildLargeAdSpace(banner, context),
        const SizedBox(height: 50,)
      ],
    );
  }
}