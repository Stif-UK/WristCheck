import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/copy.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/extract_methods.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';

class AlternativeExports extends StatefulWidget {
  final wristCheckController = Get.put(WristCheckController());


  @override
  State<AlternativeExports> createState() => _AlternativeExportsState();
}

class _AlternativeExportsState extends State<AlternativeExports> {
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
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.extractsAdUnitID,
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Alternative Exports"),
      ),
      body: Column(
        children: [
          widget.wristCheckController.isAppPro.value? const SizedBox(height: 0,) : AdWidgetHelper.buildSmallAdSpace(banner, context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Copy.getAlternativeExtractsCopy(),
                  ),
                  ElevatedButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Generate Simple Extract"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(FontAwesomeIcons.fileCsv),
                          )
                        ],
                      ),
                  onPressed: () async {
                        await ExtractMethods.generateSimpleExtract();
                  }
                    ,),
                  const SizedBox(height: 20,),
                  ElevatedButton(child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Generate Complex Extract"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(FontAwesomeIcons.fileExport),
                      )
                    ],
                  ),
                    onPressed: () async {
                    await ExtractMethods.generateComplexExtract();
                    },
                  )
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}

