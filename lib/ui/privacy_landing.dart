import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/privacy/initialisation_helper.dart';
import 'package:wristcheck/ui/PrivacyPolicy.dart';

class PrivacyLanding extends StatefulWidget {
  const PrivacyLanding();

  @override
  State<PrivacyLanding> createState() => _PrivacyLandingState();
}

class _PrivacyLandingState extends State<PrivacyLanding> {
  final _initialisationHelper = InitialisationHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy"),
      ),
      body: Column(
        children: [
          ListTile(title: const Text("Privacy Policy"),
          leading: const Icon(Icons.privacy_tip_outlined),
          onTap: (){
            Get.to(() => PrivacyPolicy());
          }),
          const Divider(thickness: 2,),
          ListTile(title: const Text("Privacy Settings"),
          leading: const Icon(Icons.settings),
          onTap: () async{
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            final didChangePreferences =
                await _initialisationHelper.changePrivacyPreferences();
            scaffoldMessenger.showSnackBar(SnackBar(content: Text(
              didChangePreferences? 'Your Privacy choices have been updated': 'An error occurred whilst attempting to update privacy settings - please try again'
            ),));
          },),
          const Divider(thickness: 2,),
        ],
      ),
    );
  }
}
