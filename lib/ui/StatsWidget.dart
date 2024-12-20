import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/collection_stats.dart';
import 'package:wristcheck/ui/period_review/period_review_home.dart';
import 'package:wristcheck/ui/wear_stats_v2.dart';

import '../provider/adstate.dart';

class StatsWidget extends StatefulWidget {
  StatsWidget({Key? key}) : super(key: key);
  final wristCheckController = Get.put(WristCheckController());


  @override
  State<StatsWidget> createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
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
            //Check config to confirm if this is a prod or test app build
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.statsPageBannerAdUnitId,
              //If the device screen is large enough display a larger ad on this screen
              size: MediaQuery.of(context).size.height > 500.0
                  ? AdSize.mediumRectangle
                  : AdSize.largeBanner,
              request: const AdRequest(),
              listener: adState.adListener)
            ..load();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                //Button 1: Link to Wear Stats
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width)*0.8,
                    height: (MediaQuery.of(context).size.height)*0.1,
                    child: ElevatedButton(
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text("Wear Stats",
                        style: TextStyle(
                          fontSize: 30,
                        ),),
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


                //Button 2: Link to Collection Stats
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width)*0.8,
                    height: (MediaQuery.of(context).size.height)*0.1,
                    child: ElevatedButton(
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text("Collection Stats",
                            style: TextStyle(
                              fontSize: 30,
                            ),),
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

                //Button 3: Annual report
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width)*0.8,
                    height: (MediaQuery.of(context).size.height)*0.1,
                    child: ElevatedButton(
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text("Wrist Recap",
                            style: TextStyle(
                              fontSize: 30,
                            ),),
                        ),
                        onPressed: (){
                          Get.to(()=>const PeriodReviewHome());
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
              ],
            ),
          ),
          widget.wristCheckController.isAppPro.value || widget.wristCheckController.isDrawerOpen.value? const SizedBox(height: 0,) : _buildAdSpace(banner, context),
        ],
      ),
    );

  }
}

Widget _buildAdSpace(BannerAd? banner, BuildContext context){
  return banner == null
      ? SizedBox(height: MediaQuery.of(context).size.height > 500.0? 250: 100,)
      : Container(
    height: MediaQuery.of(context).size.height > 500.0? 250: 100,
    child: AdWidget(ad: banner!),
  );
}



