import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:wristcheck/copy/aboutapp_copy.dart';
import 'package:wristcheck/copy/whats_new_copy.dart';

class AboutApp extends StatelessWidget{

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;


  @override
  Widget build(BuildContext context) {
  analytics.setAnalyticsCollectionEnabled(true);
  analytics.setCurrentScreen(screenName: "about_app");

    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        leading:  IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back)),
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpansionTile(title: const Text("About WristCheck"),
            onExpansionChanged: (bool) async {
              await analytics.logEvent(name: "about_wc_expanded",
              parameters: {
                "opened": bool.toString()
              });
            },
            children: [
              AboutAppCopy.getAboutWristCheckCopy(),
            ],),
            ExpansionTile(title: const Text("About StifDEV"),
              onExpansionChanged: (bool) async {
                await analytics.logEvent(name: "about_stifdev_expanded",
                    parameters: {
                      "opened": bool.toString()
                    });
              },
            children: [
              AboutAppCopy.getAboutDeveloperCopy(),
            ],),
            ExpansionTile(title: const Text("Acknowledgements"),
              onExpansionChanged: (bool) async {
                await analytics.logEvent(name: "ack_expanded",
                    parameters: {
                      "opened": bool.toString()
                    });
              },
            children: [
              AboutAppCopy.getAcknowledgementCopy(),

            ],),
            ExpansionTile(title: const Text("Version History"),
              onExpansionChanged: (bool) async {
                await analytics.logEvent(name: "version_history_expanded",
                    parameters: {
                      "opened": bool.toString()
                    });
              },
              children: [
                WhatsNewCopy.getVersionHistory(context),

              ],)
          ],
        ),
      ),

    );
  }

}