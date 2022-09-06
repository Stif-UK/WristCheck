import 'package:flutter/material.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/watchbox/watchbox_parent.dart';
import 'package:wristcheck/ui/StatsWidget.dart';
import 'package:wristcheck/ui/ServicingWidget.dart';
import 'package:wristcheck/ui/add_watch_widget.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wristcheck/ui/watch_home_drawer.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WristCheckHome extends StatefulWidget{

  @override
  _WristCheckHomeState createState() => _WristCheckHomeState();
}

class _WristCheckHomeState extends State<WristCheckHome> {

  int _currentIndex = 0;
  bool _showWhatsNew = false;
  // SharedPreferences? preferences;
  final List<Widget> _children =[
    const WatchBoxParent(),
    const StatsWidget(),
    const ServicingWidget()
  ];



  @override
  void initState() {
    super.initState();
    _returnWhatsNew().then((value) {
      _showWhatsNew = value;
      if(_showWhatsNew){
        WristCheckDialogs.getWhatsNewDialog(context);
        _updateLatestVersion();
      }
    }



    );

    //Within initState we get the instance of shared preferences, and confirm if we need
    //to show a 'what's new' dialog
    //   preferences = WristCheckPreferences.init();

    // _returnWhatsNew().then((val) {
    //     _showWhatsNew = val;
    //     if(_showWhatsNew){
    //       WristCheckDialogs.getWhatsNewDialog(context);
    //     }
    //   }

  }



  @override
  Widget build(BuildContext context) {



    //bool _darkModeToggle = false;

    return Scaffold(


      appBar: AppBar(
        title: const Text("WristCheck"),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () { Scaffold.of(context).openDrawer(); },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
        }),

      ),


      body: _children[_currentIndex],
      drawer: const WatchHomeDrawer(),



      //hide FAB except on collection screen
      floatingActionButton: _currentIndex == 0 ? FloatingActionButton(
        child: const Icon(Icons.add_rounded),
        backgroundColor: Colors.red,
        onPressed: (){Get.to(() => const AddWatch());},
      ): null,

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,





      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon:  Icon(Icons.watch),
            label: "Collection",
          ),
          BottomNavigationBarItem(
            icon:  Icon(Icons.bar_chart),
            label: "Stats",
          ),
          BottomNavigationBarItem(
            icon:  Icon(Icons.manage_history),
            label: "Service",
          )
        ],
        
      ),
    );

  }


  @override
  void dispose() {
    //close all Hive boxes when the homescreen is disposed.
    Hive.close();
    super.dispose();
  }

  void onSettingsPressed() {
  }

  void _onTabTapped(int index) {
    setState(() {
       _currentIndex = index;
    });
  }


}

Future<bool> _returnWhatsNew() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String currentVersion = packageInfo.version.toString();
  String? latestAppVersion = WristCheckPreferences.getLatestVersion();
  return latestAppVersion == null? true : _isVersionGreaterThan(currentVersion, latestAppVersion);

}

bool _isVersionGreaterThan(String currentVersion, String latestAppVersion){
  List<String> lastV = latestAppVersion.split(".");
  List<String> newV = currentVersion.split(".");
  bool a = false;
  for (var i = 0 ; i <= 2; i++){
    a = int.parse(newV[i]) > int.parse(lastV[i]);
    if(int.parse(newV[i]) != int.parse(lastV[i])) break;
  }
  return a;
}

_updateLatestVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String currentVersion = packageInfo.version.toString();
  WristCheckPreferences.setLatestVersion(currentVersion);

}