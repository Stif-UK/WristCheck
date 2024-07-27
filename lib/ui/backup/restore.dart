import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'dart:io';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/backup_restore_methods.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';

class Restore extends StatefulWidget {
  const Restore({Key? key}) : super(key: key);

  @override
  State<Restore> createState() => _RestoreState();
}

class _RestoreState extends State<Restore> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  File? _backupFile;
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
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.restorePageBannerAdUnitID,
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
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "restore");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restore Database"),
        actions: [
          IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: (){
                //ToDo: Update help information
                WristCheckDialogs.getBackupHelpDialog();
              } )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20,),
                  Text("Please select backup file", style: Theme.of(context).textTheme.bodyLarge,),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    child: Column(
                      children: [
                        Padding(
                          padding: _textPadding(),
                          child: const Text("Select Backup File"),
                        ),
                        Padding(
                          padding: _imagePadding(),
                          child: const Icon(FontAwesomeIcons.fileCircleCheck),
                        )
                      ],
                    ),
                  onPressed: () async{
                      await analytics.logEvent(name: "pick_backup_to_restore");
                      await BackupRestoreMethods.pickBackupFile().then((value) {
                        setState(() {
                          _backupFile = value;
                        });

                      });
                  },
                  ),
                  const SizedBox(height: 20,),
                  _backupFile != null? Text("File selected: $_backupFile. \n\nReady to load"): const Text(""),
                  const Divider(thickness: 2,),
                  const SizedBox(height: 20,),
                  _backupFile == null? const SizedBox(height: 20,): ElevatedButton(
                      child: Column(
                        children: [
                          Padding(
                            padding: _textPadding(),
                            child: const Text("Restore from Backup"),
                          ),
                          Padding(
                            padding: _imagePadding(),
                            child: const Icon(FontAwesomeIcons.fileImport),
                          )
                        ],
                      ),
                      onPressed: () async {
                        await analytics.logEvent(name: "initiate_restore");
                        WristCheckDialogs.getConfirmRestoreDialog(_backupFile!);
                      }
                   ),
                  const SizedBox(height: 20,),
                  _backupFile == null? const SizedBox(height: 0,): const Divider(thickness: 2,),
                  // ElevatedButton(
                  //     child: Column(
                  //       children: [
                  //         Padding(
                  //           padding: _textPadding(),
                  //           child: const Text("Restore Images"),
                  //         ),
                  //         Padding(
                  //           padding: _imagePadding(),
                  //           child: const Icon(FontAwesomeIcons.fileImage),
                  //         )
                  //       ],
                  //     ),
                  // onPressed: (){
                  //       //BackupRestoreMethods.restoreImages();
                  // },)
                ],
              ),
            ),
          ),
          purchaseStatus? const SizedBox(height: 0,) : AdWidgetHelper.buildSmallAdSpace(banner, context),
          const SizedBox(height: 50,)
        ],
      ),
    );
  }

  EdgeInsets _imagePadding(){
    return const EdgeInsets.fromLTRB(0,0,0,10);
  }

  EdgeInsets _textPadding(){
    return const EdgeInsets.all(8.0);
  }


}
