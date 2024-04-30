import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/ui/SettingsPage.dart';
import 'package:wristcheck/ui/PrivacyPolicy.dart';
import 'package:wristcheck/ui/AboutApp.dart';
import 'package:wristcheck/ui/privacy_landing.dart';
import 'package:wristcheck/ui/remove_ads.dart';
import 'package:wristcheck/util/general_helper.dart';

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
          DrawerHeader(child:
                Container(
                width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image:  AssetImage('assets/icon/drawerheader.png'),
                        fit: BoxFit.contain
                    ),
                  ),
                )
                    ),

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
            trailing: const Icon(Icons.data_array),
            title: const Text("App Data"),
            onTap: (){
              //Get.to(() => SettingsPage());
            },
          ),
          const Divider(thickness: 2,),
          ListTile(
            trailing: const Icon(Icons.warning_amber_rounded),
            title: const Text("Privacy"),
            onTap: (){
              Get.to(() => PrivacyLanding());
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
          ListTile(
            trailing: const Icon(FontAwesomeIcons.instagram),
            title: const Text("Follow WristCheck"),
            onTap: () async {
              analytics.logEvent(name: "social_link_clicked",
                  parameters: {
                    "social_link" : "instagram"
                  });
              await GeneralHelper.launchInstagram();
            },
          ),
          const Divider(thickness: 2,)

        ],

      ),);
  }
}
