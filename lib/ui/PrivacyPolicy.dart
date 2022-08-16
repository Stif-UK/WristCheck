import 'package:flutter/material.dart';
import 'package:wristcheck/Copy/PrivacyPolicyCopy.dart';

class PrivacyPolicy extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PrivacyPolicy"),
        leading:  IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back)),
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
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

            Text(PrivacyPolicyCopy.privacyWording),
          ],),
      ),
    );
  }
}