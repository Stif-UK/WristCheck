import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/timeline_controller.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/ui/more_menu/timeline/timeline_body.dart';
import 'package:wristcheck/ui/more_menu/timeline/timeline_settings_bottomsheet.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';

class WristCheckTimeline extends StatefulWidget {
  WristCheckTimeline({super.key});

  final timelineController = Get.put(TimelineController());
  final wristcheckController = Get.put(WristCheckController());

  @override
  State<WristCheckTimeline> createState() => _WristCheckTimelineState();
}

class _WristCheckTimelineState extends State<WristCheckTimeline> {
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
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.timelineAdUnitID,
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
    analytics.logScreenView(screenName: "timeline");

    return Scaffold(
      appBar: AppBar(
        title: Text("Timeline"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: Icon(FontAwesomeIcons.gear),
            onPressed: (){
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context){
                      return TimelineSettingsBottomSheet();
                    }
                );
              },
            ),
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Insert Ad Widget into tree
          widget.wristcheckController.isAppPro.value || widget.wristcheckController.isDrawerOpen.value? const SizedBox(height: 0,) : AdWidgetHelper.buildSmallAdSpace(banner, context),
          Obx(() => Expanded(
            flex: 9,
            child: TimelineBody(
                orderAscending: widget.timelineController.timelineOrderAscending.value,
                showPurchases: widget.timelineController.showPurchases.value,
                showSold: widget.timelineController.showSales.value,
                showServiced: widget.timelineController.showLastServiced.value,
                showWarranty: widget.timelineController.showWarrantyEnd.value,
              ),
          ),
          ),
        ],
      )
    );
  }
}
