import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:wristcheck/Copy/PrivacyPolicyCopy.dart';
import 'package:flutter_markdown/flutter_markdown.dart';


class PrivacyPolicy extends StatelessWidget{
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;


  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(screenName: "privacy_policy");
    return Scaffold(
      appBar: AppBar(
        title: const Text("PrivacyPolicy"),
        leading:  IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back)),
      ),
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: Text("Version: ${PrivacyPolicyCopy.versionNumber} ",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: Text("Date: ${PrivacyPolicyCopy.policyDate}"),
            ),
            const Divider(thickness: 2.0,),

            Expanded(
                child: Markdown(data: PrivacyPolicyCopy.privacyWording,)
            ),
          ],),
      ),
    );
  }
}