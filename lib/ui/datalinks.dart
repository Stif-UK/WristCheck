import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/snackbars.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/ui/backup/alternative_exports.dart';
import 'package:wristcheck/ui/backup/backup_restore.dart';
import 'package:wristcheck/util/images_util.dart';

class DataLinks extends StatefulWidget {
  final wristCheckController = Get.put(WristCheckController());


  @override
  State<DataLinks> createState() => _DataLinksState();
}


class _DataLinksState extends State<DataLinks> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final watchBox = Boxes.getWatches();
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
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.datalinksAdUnitID,
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
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "app_data");

    return Scaffold(
      appBar: AppBar(
        title: const Text("App Data"),
      ),
      body: Column(
        children: [
          Expanded(
          child: ListView(
                  children: [
                    ListTile(
                        title: const Text("Backup / Restore Database"),
                        leading: const Icon(Icons.save_alt),
                        onTap: (){
                          Get.to(()=> const BackupRestore());
                        }
                    ),
                    const Divider(thickness: 2,),
                    ListTile(
                        title: const Text("Alternative Exports"),
                        leading: const Icon(FontAwesomeIcons.fileExport),
                        onTap: (){
                          Get.to(()=> AlternativeExports());
                        }
                    ),
                    const Divider(thickness: 2,),
                    ListTile(
                        title:const Text("Delete collection"),
                        leading: const Icon(Icons.warning),
                        trailing: OutlinedButton(
                            child: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: (){
                              Get.defaultDialog(
                                  title: "Warning",
                                  middleText: "Pressing OK will delete all watch data, including your wishlist and all saved images\n \n THIS CANNOT BE UNDONE",
                                  textConfirm: "OK",
                                  textCancel: "Cancel",
                                  onConfirm: (){
                                    _deleteCollection();
                                    Get.back();
                                    WristCheckSnackBars.collectionDeletedSnackbar();
                                  }

                              );
                            }
                        )
                    ),
                    const Divider(thickness: 2,),
                  ],
          ),
          ),
          widget.wristCheckController.isAppPro.value? const SizedBox(height: 0,) : _buildAdSpace(banner, context),
          SizedBox(height: 50,)

        ],
      )
    );
  }

  void _deleteCollection(){
    ImagesUtil.deleteAllImages();
    watchBox.clear();
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
