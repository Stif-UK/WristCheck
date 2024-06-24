import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:wristcheck/api/purchase_api.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/SettingsPage.dart';
import 'package:wristcheck/ui/calendar/calendarhome.dart';
import 'package:wristcheck/ui/calendar/schedule_view.dart';
import 'package:wristcheck/ui/watch/watchview.dart';
import 'package:wristcheck/ui/watchbox.dart';
import 'package:wristcheck/ui/StatsWidget.dart';
import 'package:wristcheck/ui/ServicingWidget.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wristcheck/ui/watch_home_drawer.dart';
import 'package:wristcheck/ui/time_setting.dart';
import 'package:wristcheck/util/startup_checks_util.dart';


class WristCheckHome extends StatefulWidget{
  final wristCheckController = Get.put(WristCheckController());


  @override
  _WristCheckHomeState createState() => _WristCheckHomeState();
}

class _WristCheckHomeState extends State<WristCheckHome> {

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  int _currentIndex = 0;
  final List<Widget> _children =[
    Watchbox(),
    StatsWidget(),
    CalendarHome(),
    TimeSetting(),
  ];



  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
    //Check for a version update and show a dialog if a new version has been released
    StartupChecksUtil.runStartupChecks(context);

    //If app is pro, check entitlement is still valid - check once per week
    if(WristCheckPreferences.getAppPurchasedStatus() == true){
      final lastChecked = WristCheckPreferences.getLastEntitlementCheckDate();
      if(lastChecked == null){
        PurchaseApi.checkEntitlements();
      } else {
        final date2 = DateTime.now();
        final difference = date2.difference(lastChecked).inDays;
        if(difference > 6){
          PurchaseApi.checkEntitlements();
        }
      }

    }
  }



  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(screenName: "watchbox_home");
    //If platform is iOS, request tracking permission for ads
    if(Platform.isIOS) {
      AppTrackingTransparency.requestTrackingAuthorization();
    }


    //bool _darkModeToggle = false;

    return Scaffold(


      appBar: AppBar(
        title: Obx(() => getHeaderText()),
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
      drawer: WatchHomeDrawer(),
      onDrawerChanged: (isOpen){
        widget.wristCheckController.updateIsDrawerOpen(isOpen);
      },

      //hide FAB except on collection screen
      floatingActionButton: _currentIndex == 0 ? FloatingActionButton(
        child: const Icon(Icons.add_rounded),
        backgroundColor: Colors.red,
        //onPressed: (){Get.to(() => const AddWatch());},
        onPressed: () async {
          await analytics.logEvent(name: "add_watch_fab_pressed");
          Get.to(() => WatchView());},
      ): null,

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,





      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
            icon:  Icon(Icons.calendar_month_sharp),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.clock),
            label: "Time"
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
      analytics.logEvent(name: "homepage_bottom_nav",
      parameters: {
        "page_name" : _children[index].toString(),
        "page_index": index
      });
       _currentIndex = index;
    });
  }

  getHeaderText(){
    return widget.wristCheckController.isAppPro.value? const Text("WristTrack Pro") : const Text("WristTrack");
  }



}

