import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:get/get.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/ui/backup/share_backup.dart';
import 'package:wristcheck/ui/backup/restore.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';
import '../../provider/adstate.dart';

class BackupRestore extends StatefulWidget {
  const BackupRestore({Key? key}) : super(key: key);

  @override
  State<BackupRestore> createState() => _BackupRestoreState();
}

class _BackupRestoreState extends State<BackupRestore> {
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
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.wishlistPageBannerAdUnitId,
              //If the device screen is large enough display a larger ad on this screen
              size: MediaQuery.of(context).size.height > 560.0
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
    analytics.logScreenView(screenName: "backup_restore_landing");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Backup / Restore"),
        actions: [
          IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: (){
                WristCheckDialogs.getBackupHelpDialog();
              } )
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 30,),
                SizedBox(
                  width: (MediaQuery.of(context).size.width)*0.8,
                  height: (MediaQuery.of(context).size.height)*0.15,
                  child: ElevatedButton(
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text("Backup",
                          style: TextStyle(
                            fontSize: 30,
                          ),),
                      ),
                      onPressed: (){
                        Get.to(() => ShareBackup());
                        //Platform.isIOS? Get.to(()=> const ShareBackup()) :Get.to(() => const Backup());
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
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width)*0.8,
                    height: (MediaQuery.of(context).size.height)*0.15,
                    child: ElevatedButton(
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text("Restore",
                            style: TextStyle(
                              fontSize: 30,
                            ),),
                        ),
                        onPressed: (){
                          Get.to(() => const Restore());
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
          purchaseStatus? const SizedBox(height: 0,) : AdWidgetHelper.buildRectangleSpace(banner, context),
          const SizedBox(height: 50,)
        ],
      ),

    );
  }
}
