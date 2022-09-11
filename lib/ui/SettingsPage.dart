import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/archived.dart';
import 'package:wristcheck/copy/snackbars.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wristcheck/ui/backup/backup_restore.dart';




class SettingsPage extends StatefulWidget{




@override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool _darkModeToggle = false;
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
                SwitchListTile(
                  title: const Text("Dark Mode"),
                  secondary: const Icon(Icons.dark_mode_rounded),
                  value: _darkModeToggle,
                  onChanged: (bool value){
                    Get.changeTheme(
                        Get.isDarkMode ? ThemeData.light() : ThemeData.dark()
                    );
                    setState(() {
                      _darkModeToggle = value;

                    });

                  },
                ),
                const Divider(thickness: 2,),
                 ListTile(
                  title: const Text("Show Archived Watches"),
                    leading: const Icon(Icons.archive_outlined),
                  onTap: (){
                    Get.to(()=> Archived());
                  }
                ),
                const Divider(thickness: 2,),
                ListTile(
                    title: const Text("Backup / Restore Database"),
                    leading: const Icon(Icons.save_alt),
                    onTap: (){
                      Get.to(()=> BackupRestore());
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
                WristCheckDialogs.getHiddenStats(_openCount, _wearCount);
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
