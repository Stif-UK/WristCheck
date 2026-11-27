import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/collection_stats.dart';
import 'package:wristcheck/ui/wear_stats_v2.dart';
import 'package:wristcheck/model/enums/wrist_recap_enums.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_home.dart';

import '../provider/adstate.dart';

class StatsWidget extends StatefulWidget {
  StatsWidget({Key? key}) : super(key: key);
  final wristCheckController = Get.put(WristCheckController());

  static const double smallScreenHeightThreshold = 750.0;

  static AdSize adSizeForScreenHeight(double screenHeight) {
    return screenHeight >= smallScreenHeightThreshold
        ? AdSize.mediumRectangle
        : AdSize.banner;
  }

  @override
  State<StatsWidget> createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
  BannerAd? banner;
  AdSize? _loadedAdSize;
  bool purchaseStatus = WristCheckPreferences.getAppPurchasedStatus() ?? false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!purchaseStatus) {
      final AdSize targetSize =
          StatsWidget.adSizeForScreenHeight(MediaQuery.sizeOf(context).height);
      if (_loadedAdSize == targetSize) return;
      _loadedAdSize = targetSize;

      final adState = Provider.of<AdState>(context);
      adState.initialization.then((status) {
        if (!mounted || _loadedAdSize != targetSize) return;
        final previousBanner = banner;
        final newBanner = BannerAd(
          //Check config to confirm if this is a prod or test app build
          adUnitId: WristCheckConfig.prodBuild == false
              ? adState.getTestAds
              : AdUnits.statsPageBannerAdUnitId,
          //If the device screen is large enough display a larger ad on this screen
          size: targetSize,
          request: const AdRequest(),
          listener: adState.adListener,
        )..load();
        setState(() {
          banner = newBanner;
        });
        if (previousBanner != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            previousBanner.dispose();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  //Button 1: Link to Wear Stats
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: SizedBox(
                        height: (MediaQuery.sizeOf(context).height) * 0.1,
                        child: ElevatedButton(
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: FittedBox(
                              child: Text(AppLocalizations.of(context)!.wearStatsButton, textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25, overflow: TextOverflow.fade,
                              ),),
                            ),
                          ),
                          onPressed: (){ Get.to(() => WearStatsV2());},
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                        side: const BorderSide(color: Colors.black)
                                    )

                )
                )
                ),
                      ),
                    ),
                    ),


                  //Button 2: Link to Collection Stats
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: SizedBox(
                        height: (MediaQuery.sizeOf(context).height) * 0.1,
                        child: ElevatedButton(
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: FittedBox(
                                child: Text(AppLocalizations.of(context)!.collectionStatsButton, textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25, overflow: TextOverflow.fade,
                                  ),),
                              ),
                            ),
                            onPressed: (){
                              Get.to(()=>const CollectionStats());
                            },
                            style: ButtonStyle(
                                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                        side: const BorderSide(color: Colors.black)
                                    )
                                )
                            )
                        ),
                      ),
                    ),
                  ),

                  //Button 3: Annual report
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: SizedBox(
                        height: (MediaQuery.sizeOf(context).height) * 0.1,
                        child: ElevatedButton(
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: FittedBox(
                                child: Text("Wrist Recap",
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),),
                              ),
                            ),
                            onPressed: (){
                              //Default to opening WristRecap at last month
                              DateTime now = DateTime.now();
                              DateTime lastMonth = DateTime(now.year, now.month-1);
                              Get.to(()=> WristRecapHome(month: lastMonth.month, year: lastMonth.year, selectedOption: WristRecapEnums.monthly));
                            },
                            style: ButtonStyle(
                                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                        side: const BorderSide(color: Colors.black)
                                    )
                                )
                            )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          widget.wristCheckController.isAppPro.value || widget.wristCheckController.isDrawerOpen.value? const SizedBox(height: 0,) : _buildAdSpace(banner, context),
          const SizedBox(height: 100,)
        ],
      ),
    );

  }
}

Widget _buildAdSpace(BannerAd? banner, BuildContext context) {
  final double targetHeight = banner?.size.height.toDouble() ??
      StatsWidget.adSizeForScreenHeight(MediaQuery.sizeOf(context).height)
          .height
          .toDouble();
  return banner == null
      ? SizedBox(
          key: const Key('stats_ad_placeholder'),
          height: targetHeight,
        )
      : SizedBox(
          key: const Key('stats_ad_container'),
          height: targetHeight,
          child: AdWidget(ad: banner),
        );
}



