import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/ui/watchbox/WatchBoxWidget.dart';
import 'package:wristcheck/ui/watchbox/watchbox_header.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';

class WatchBoxParent extends StatefulWidget {
  WatchBoxParent({Key? key}) : super(key: key);
  final wristCheckController = Get.put(WristCheckController());




  @override
  State<WatchBoxParent> createState() => _WatchBoxParentState();
}



class _WatchBoxParentState extends State<WatchBoxParent> {

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
  Widget build(BuildContext context) {
    return Obx( ()=> Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          widget.wristCheckController.isAppPro.value? const SizedBox(height: 0,) : AdWidgetHelper.buildSmallAdSpace(banner, context),
          const WatchBoxHeader(),

          const Expanded(
              child: WatchBoxWidget())
        ]

      ),
    );
  }
}
