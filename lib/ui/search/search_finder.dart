import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/provider/db_provider.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/enums/watch_status_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/watch/watchview.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';
import 'package:wristcheck/util/images_util.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';



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
                  ? Center(
                child: Text(
                  AppLocalizations.of(context)!.noResultsFound,
                ),
              )
                  : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  // passing as a custom list
                  final Watches watchesListItem = results[index];

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        Get.to(() => WatchView(currentWatch: watchesListItem,));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            _getWatchImage(watchesListItem),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${watchesListItem.toString()}",
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    WatchStatusEnumExtension.fromDbString(watchesListItem.status).toLocalizedString(context),
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                      ),
                    ),
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

  Widget _getWatchImage(Watches watch) {
    bool showImage = watch.frontImagePath != null && watch.frontImagePath != "";

    return showImage
        ? FutureBuilder(
            future: ImagesUtil.getImage(watch, watch.primaryImageIndex ?? 0),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError || !snapshot.hasData) {
                  return _getEmptyIcon(context);
                }
                final data = snapshot.data as File;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    data,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                );
              }
              return Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(child: CircularProgressIndicator()),
              );
            },
          )
        : _getEmptyIcon(context);
  }

  Widget _getEmptyIcon(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).disabledColor.withOpacity(0.2)),
      ),
      child: Icon(
        Icons.watch,
        size: 40,
        color: Theme.of(context).disabledColor,
      ),
    );
  }
}
