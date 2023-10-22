import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/ui/SettingsPage.dart';
import 'package:wristcheck/ui/PrivacyPolicy.dart';
import 'package:wristcheck/ui/AboutApp.dart';
import 'package:wristcheck/ui/remove_ads.dart';

class WatchHomeDrawer extends StatelessWidget {
  WatchHomeDrawer({Key? key}) : super(key: key);
  final wristCheckController = Get.put(WristCheckController());
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    final InAppReview inAppReview = InAppReview.instance;
    analytics.setAnalyticsCollectionEnabled(true);
    analytics.setCurrentScreen(screenName: "watch_home_drawer");

    return Drawer(
      child: ListView(
        children:  [
          DrawerHeader(child: IconButton(
            splashColor: Colors.transparent,
            icon: const Icon(Icons.watch, size: 40.0),
            onPressed: () async {

            },

          )),

          const Divider(thickness: 2,),
          ListTile(
            trailing: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: (){
              Get.to(() => SettingsPage());

            },
          ),
          const Divider(thickness: 2,),
          ListTile(
            trailing: const Icon(Icons.warning_amber_rounded),
            title: const Text("Privacy Policy"),
            onTap: (){
              Get.to(() => PrivacyPolicy());
            },
          ),
          const Divider(thickness: 2,),
          ListTile(
              trailing: const Icon(Icons.ad_units_outlined),
            title: wristCheckController.isAppPro.value? const Text("Support WristCheck"):  const Text("Remove Ads"),
            onTap: (){
              Get.to(() => RemoveAds());
            }
          ),
          const Divider(thickness: 2,),
          ListTile(
            trailing: const Icon(Icons.rate_review_outlined),
              title: const Text("Leave an app review"),
            onTap: () async {
              await analytics.logEvent(name: "manual_app_review");
              inAppReview.openStoreListing(
                  appStoreId: "1642718252"
              );
            },
          ),
          const Divider(thickness: 2,),
          ListTile(
            trailing: const Icon(Icons.info),
            title: const Text("About"),
            onTap: (){
              Get.to(() => AboutApp());
            },
          ),

          const Divider(thickness: 2,),

        ],

      ),);
  }
}
