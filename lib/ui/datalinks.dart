import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class DataLinks extends StatefulWidget {

  @override
  State<DataLinks> createState() => _DataLinksState();
}


class _DataLinksState extends State<DataLinks> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;


  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(screenName: "app_data");

    return Scaffold(
      appBar: AppBar(
        title: Text("App Data"),
      ),
    );
  }
}
