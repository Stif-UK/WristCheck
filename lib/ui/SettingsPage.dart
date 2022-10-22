import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/archived.dart';
import 'package:wristcheck/copy/snackbars.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wristcheck/ui/backup/backup_restore.dart';
import 'package:wristcheck/ui/chart_options.dart';
import 'package:wristcheck/ui/notifications.dart';




class SettingsPage extends StatefulWidget{




@override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final watchBox = Boxes.getWatches();
  String _buildVersion = "Not Determined";
  int _clickCount = 0;


  @override
  void initState() {
    super.initState();
    _getBuildVersion().then((val) {
      setState(() {
        _buildVersion = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading:  IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                    title: const Text("Daily Reminder"),
                    leading: const Icon(Icons.notifications_active_outlined),
                    onTap: (){
                      Get.to(()=> const Notifications());
                    }
                ),
                const Divider(thickness: 2,),
                ListTile(
                    title: const Text("Chart Options"),
                    leading: const Icon(Icons.bar_chart_outlined),
                    onTap: (){
                      Get.to(()=> const ChartOptions());
                    }
                ),
                const Divider(thickness: 2,),
                ListTile(
                  title: const Text("Show Archived Watches"),
                    leading: const Icon(Icons.archive_outlined),
                  onTap: (){
                    Get.to(()=> const Archived());
                  }
                ),
                const Divider(thickness: 2,),
                ListTile(
                    title: const Text("Backup / Restore Database"),
                    leading: const Icon(Icons.save_alt),
                    onTap: (){
                      Get.to(()=> const BackupRestore());
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
                        middleText: "Pressing OK will delete all watch data, including your wishlist\n \n THIS CANNOT BE UNDONE",
                        textConfirm: "OK",
                        textCancel: "Cancel",
                        onConfirm: (){
                          //On pressing ok, call the .clear() method on the watchbox
                          watchBox.clear();
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

          GestureDetector(
            onTap: (){
              _clickCount = _clickCount+1;
              if(_clickCount > 5){
                int? _openCount = WristCheckPreferences.getOpenCount() ?? 0;
                int? _wearCount = WristCheckPreferences.getWearCount() ?? 0;
                DateTime? refDate = WristCheckPreferences.getReferenceDate();
                WristCheckDialogs.getHiddenStats(_openCount, _wearCount, refDate);
              }
            },
            child: SizedBox(
              height: 50,
              child: Text("App Version: $_buildVersion")
            ),
          )
        ],
      ),


    );
  }

  Future<String> _getBuildVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;

  }

}
