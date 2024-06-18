import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/copy/aboutapp_copy.dart';
import 'package:wristcheck/copy/whats_new_copy.dart';
import 'package:url_launcher/url_launcher.dart';

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
            ListTile(
              leading: Icon(FontAwesomeIcons.earthAmericas),
              title: Text("Visit www.wristcheck.app"),
              trailing: Icon(FontAwesomeIcons.arrowUpRightFromSquare),
              onTap: () async {
                _launchURL();
              },
            ),
            const Divider(thickness: 2,),
            ExpansionTile(title: const Text("About WristTrack"),
            leading: Icon(FontAwesomeIcons.clock),
            onExpansionChanged: (bool) async {
              await analytics.logEvent(name: "about_wc_expanded",
              parameters: {
                "opened": bool.toString()
              });
            },
            children: [
              AboutAppCopy.getAboutWristCheckCopy(),
            ],),
            const Divider(thickness: 2,),
            ExpansionTile(title: const Text("About the Developer"),
              leading: Icon(FontAwesomeIcons.code),
              onExpansionChanged: (bool) async {
                await analytics.logEvent(name: "about_stifdev_expanded",
                    parameters: {
                      "opened": bool.toString()
                    });
              },
            children: [
              AboutAppCopy.getAboutDeveloperCopy(),
            ],),
            const Divider(thickness: 2,),
            ExpansionTile(title: const Text("Acknowledgements"),
              leading: Icon(FontAwesomeIcons.award),
              onExpansionChanged: (bool) async {
                await analytics.logEvent(name: "ack_expanded",
                    parameters: {
                      "opened": bool.toString()
                    });
              },
            children: [
              AboutAppCopy.getAcknowledgementCopy(),

            ],),
            const Divider(thickness: 2,),
            ExpansionTile(title: const Text("Version History"),
              leading: Icon(FontAwesomeIcons.clockRotateLeft),
              onExpansionChanged: (bool) async {
                await analytics.logEvent(name: "version_history_expanded",
                    parameters: {
                      "opened": bool.toString()
                    });
              },
              children: [
                WhatsNewCopy.getVersionHistory(context),

              ],),
            const Divider(thickness: 2,),
          ],
        ),
      ),

    );
  }
  void _launchURL() async {
    final Uri url = Uri.parse('https://www.wristcheck.app');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}

