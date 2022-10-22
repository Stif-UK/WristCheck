import 'package:flutter/material.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/ui/SettingsPage.dart';
import 'package:wristcheck/ui/watchbox/watchbox_parent.dart';
import 'package:wristcheck/ui/StatsWidget.dart';
import 'package:wristcheck/ui/ServicingWidget.dart';
import 'package:wristcheck/ui/add_watch_widget.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wristcheck/ui/watch_home_drawer.dart';
import 'package:wristcheck/util/startup_checks_util.dart';


class WristCheckHome extends StatefulWidget{

  @override
  _WristCheckHomeState createState() => _WristCheckHomeState();
}

class _WristCheckHomeState extends State<WristCheckHome> {

  int _currentIndex = 0;
  final List<Widget> _children =[
    const WatchBoxParent(),
    const StatsWidget(),
    const ServicingWidget()
  ];



  @override
  void initState() {
    super.initState();
    //Check for a version update and show a dialog if a new version has been released
    StartupChecksUtil.runStartupChecks(context);
  }



  @override
  Widget build(BuildContext context) {



    //bool _darkModeToggle = false;

    return Scaffold(


      appBar: AppBar(
        title: const Text("WristCheck"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: (){Get.to(() => SettingsPage());},
          )
        ],
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
