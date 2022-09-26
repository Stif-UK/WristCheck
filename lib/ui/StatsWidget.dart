import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/collection_stats.dart';
import 'package:wristcheck/ui/wearStats.dart';

import '../provider/adstate.dart';

class StatsWidget extends StatefulWidget {
  const StatsWidget({Key? key}) : super(key: key);

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
              adUnitId: WristCheckConfig.prodBuild? adState.getTestAds :adState.statsPageBannerAdUnitId,
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
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              //Button 1: Link to Wear Stats
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: (MediaQuery.of(context).size.width)*0.8,
                  height: (MediaQuery.of(context).size.height)*0.15,
                  child: ElevatedButton(
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text("Wear Stats",
                      style: TextStyle(
                        fontSize: 30,
                      ),),
                    ),
                    onPressed: (){ Get.to(() => const WearStats());},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: (MediaQuery.of(context).size.width)*0.8,
                  height: (MediaQuery.of(context).size.height)*0.15,
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
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: const BorderSide(color: Colors.black)
                              )

                          )
                      )
                  ),
                ),
              ),

              //TODO: If adding further buttons, adjust ad size accordingly!
              //Button 3: Link to Watch Stats
              // const SizedBox(height: 20),
              // Align(
              //   alignment: Alignment.center,
              //   child: SizedBox(
              //     width: (MediaQuery.of(context).size.width)*0.8,
              //     height: (MediaQuery.of(context).size.height)*0.15,
              //     child: ElevatedButton(
              //         child: const Padding(
              //           padding: EdgeInsets.all(12.0),
              //           child: Text("Watch Stats",
              //             style: TextStyle(
              //               fontSize: 30,
              //             ),),
              //         ),
              //         onPressed: (){ },
              //         style: ButtonStyle(
              //             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //                 RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(20.0),
              //                     side: const BorderSide(color: Colors.black)
              //                 )
              //
              //             )
              //         )
              //     ),
              //   ),
              // )
              
            ],
          ),
        ),
        purchaseStatus? const SizedBox(height: 0,) : _buildAdSpace(banner, context),
        // banner == null
        //     ? SizedBox(height: MediaQuery.of(context).size.height > 500.0? 250: 100,)
        //     : Container(
        //   height: MediaQuery.of(context).size.height > 500.0? 250: 100,
        //   child: AdWidget(ad: banner!),
        // )
      ],
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



