import 'package:flutter/material.dart';
import 'package:wristcheck/copy/aboutapp_copy.dart';

class AboutApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
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
            children: [
              AboutAppCopy.getAboutWristCheckCopy(),
            ],),
            const ExpansionTile(title: Text("About StifDEV")),
            ExpansionTile(title: const Text("Acknowledgements"),
            children: [
              AboutAppCopy.getAcknowledgementCopy(),

            ],)
          ],
        ),
      ),

    );
  }

}