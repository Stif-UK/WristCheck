import 'package:flutter/material.dart';
import 'package:wristcheck/model/extract_methods.dart';

class AlternativeExports extends StatefulWidget {

  @override
  State<AlternativeExports> createState() => _AlternativeExportsState();
}

class _AlternativeExportsState extends State<AlternativeExports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alternative Exports"),
      ),
      body: Column(
        children: [
          //TODO: Implement this as markdown and externalise the text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("A primary function of WristCheck is the ability to track your watch information and give you options to review and interrogate it. \nHowever, the data belongs to you, and there may be things you want to do with it that the app cannot accomodate easily - these alternative export options provide a mechanism to extract your data in CSV format, allowing you to do as you please with it, in your preferred applications (such as Excel or Numbers)."),
          ),
          const Divider(thickness: 2,),
          ElevatedButton(
              child: Text("Simple Extract Test"),
          onPressed: () async {
                await ExtractMethods.generateSimpleExtract();
          }
            ,)
        ],
      ),
    );
  }
}
