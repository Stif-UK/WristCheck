import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/backup_restore_methods.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';

class ShareBackup extends StatefulWidget {
  ShareBackup({Key? key}) : super(key: key);
  final wristCheckController = Get.put(WristCheckController());

  @override
  State<ShareBackup> createState() => _ShareBackupState();
}

class _ShareBackupState extends State<ShareBackup> {

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
              adUnitId: AdUnits.backupPageBannerAdUnitID,
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
        title: const Text("Backup"),
        actions: [
          IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: (){
                WristCheckDialogs.getBackupHelpDialog();
              } )
        ],
      ),
      body: Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Press the button below to create a copy of the app database (this can take a few seconds!). \n\nOnce created a 'share' pop-up should appear, allowing you to choose where to send the backup file.  ",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.start,),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Backup Database",
                    style: Theme.of(context).textTheme.headlineSmall,),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(FontAwesomeIcons.download),
                    )
                  ],
                ),
                onPressed: (){
                  BackupRestoreMethods.shareBackup();

                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Watch Images can be separately exported.",
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.start,),
            ),
            //Button for image backup
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Backup Watch Images",
                      style: Theme.of(context).textTheme.headlineSmall,),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(FontAwesomeIcons.fileExport),
                    )
                  ],
                ),
                onPressed: () async {
                  await BackupRestoreMethods.imageBackup();

                },
              ),
            ),
            //const Text("stuff"),
            Expanded(child:
            SizedBox()),
            //Insert Ad Widget into tree
            widget.wristCheckController.isAppPro.value? const SizedBox(height: 0,) : AdWidgetHelper.buildSmallAdSpace(banner, context),
            const SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
