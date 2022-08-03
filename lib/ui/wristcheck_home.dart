import 'package:flutter/material.dart';
import 'package:wristcheck/ui/AboutApp.dart';
import 'package:wristcheck/ui/PrivacyPolicy.dart';
import 'package:wristcheck/ui/SettingsPage.dart';
import 'package:wristcheck/ui/WatchBoxWidget.dart';
import 'package:wristcheck/ui/StatsWidget.dart';
import 'package:wristcheck/ui/ServicingWidget.dart';
import 'package:wristcheck/ui/add_watch_widget.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


class WristCheckHome extends StatefulWidget{

  @override
  _WristCheckHomeState createState() => _WristCheckHomeState();
}

class _WristCheckHomeState extends State<WristCheckHome> {

  int _currentIndex = 0;
  final List<Widget> _children =[
    WatchBoxWidget(),
    StatsWidget(),
    ServicingWidget()
  ];



  @override
  Widget build(BuildContext context) {


    //bool _darkModeToggle = false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
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
      drawer:  Drawer(
        backgroundColor: Theme.of(context).backgroundColor,
        child: ListView(
          children:  [
            DrawerHeader(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,

            children: [

              Container(
                alignment: Alignment.topLeft,
                child: const Text("WristCheck",
                textAlign: TextAlign.center,
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: 20.0

                ),),
              ),

              Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 20.0,), onPressed: () { Navigator.of(context).pop(); },
                ),
              ),
            ],
            )
            ),

            Divider(),
             ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: (){
                Get.to(() => SettingsPage());

              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.warning_amber_rounded),
              title: const Text("Privacy Policy"),
              onTap: (){
                Get.to(() => PrivacyPolicy());
              },
            ),
            Divider(),
             ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About"),
              onTap: (){
                Get.to(() => AboutApp());
              },
            ),

            Divider(),

          ],

        ),
      ),


      //hide FAB except on collection screen
      floatingActionButton: _currentIndex == 0 ? FloatingActionButton(
        child: Icon(Icons.add_chart),
        backgroundColor: Colors.red,
        onPressed: (){Get.to(() => AddWatch());},

        //     (){Get.snackbar(
        //   "ADD WATCH",//title
        //   "Add watches here!",//content text
        // icon: Icon(Icons.watch),
        // snackPosition: SnackPosition.BOTTOM);
        //   },

      ): null,

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,





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
    print("Hive box closed");
  }

  void onSettingsPressed() {
  }

  void _onTabTapped(int index) {
    setState(() {
       _currentIndex = index;
    });
  }
}