import 'package:flutter/material.dart';
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

class Backup extends StatefulWidget {
  const Backup({Key? key}) : super(key: key);

  @override
  State<Backup> createState() => _BackupState();
}

class _BackupState extends State<Backup> {
  String? _backupLocation;
  bool _backupComplete = false;
  bool _loadedLocation = false;
  bool _loadedBackup = false;
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
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.backupPageBannerAdUnitID,
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
        title: const Text("Backup Database"),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(

                    children: [
                      const SizedBox(
                        height: 20,
                      ),

                      //Section 1: Select Backup Location - no other sections are displayed until a backup location is selected.
                      const Text("Please Select Backup Location"),
                      const SizedBox(height: 20,),

                      //If Platform is Android give some guidance on backup location to minimise errors
                      Platform.isAndroid? const Text("Backup location must be a sub-folder of the Android OS 'Documents' folder",
                          textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),) : const Text(""),
                      const SizedBox(height: 20,),
                      ElevatedButton(
                          child: const Text("Select Backup Location"),
                          onPressed: () async {
                            await BackupRestoreMethods.pickBackupLocation().then((val) {
                              setState(() {
                                _backupLocation = val;
                              });
                            });
                          }, ),

                       //Only show icon if backup location is set, getSuccessIcon returns a loading spinner for a short time, then a tick
                      _backupLocation == null? const SizedBox(height: 40,) : getSuccessIconLocation(_loadedLocation),

                      const Divider(height: 15,
                        thickness: 2,),

                      //Section 2: Backup. Only displays if the backup location is selected and the 'tick' icon has had time to load
                      _backupLocation == null || _loadedLocation == false? const SizedBox(height: 20,): Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Backup Database",style: TextStyle(fontSize: 30,),),
                              ),
                              onPressed: () async {
                                setState(() {
                                  _backupComplete = true;
                                });

                                Future.delayed(const Duration(seconds: 2),() async {
                                  await BackupRestoreMethods.backupWatchBox(_backupLocation!).then((_){
                                    setState((
                                        ) {
                                      _loadedBackup = true;
                                    });
                                  }

                                  ).onError((error, stackTrace) => WristCheckDialogs.getBackupFailedDialog(error.toString()));
                                } );




                              }, ),
                          ),
                          _backupComplete? getSuccessIconBackup(_loadedBackup): const SizedBox(height: 40,),
                          const Divider(height: 15,
                            thickness: 2,),
                        ],
                      ),




                    ],
                  ),
                ),
                const Expanded(
                    flex:2,
                    child: Icon(Icons.file_download, size: 70,)),
              ],
            ),
          ),
          purchaseStatus? const SizedBox(height: 0,) : AdWidgetHelper.buildSmallAdSpace(banner, context),
          const SizedBox(height: 50,)
        ],
      ),
    );
  }

  Widget getSuccessIconLocation(bool loaded){
    Future.delayed(const Duration(seconds: 2), () {

        setState(() {
          _loadedLocation = true;
        });

    }
      );
    return loaded? const Icon(Icons.done, color: Colors.green,size: 40,): const CircularProgressIndicator();

  }

  Widget getSuccessIconBackup(bool loaded){
    // Future.delayed(const Duration(seconds: 2), () {
    //
    //   setState(() {
    //     _loadedBackup = true;
    //   });
    //
    // }
    // );
    return loaded? const Icon(Icons.done, color: Colors.green,size: 40,): const CircularProgressIndicator();

  }

}




