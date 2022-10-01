import 'package:flutter/material.dart';
import 'package:wristcheck/copy/dialogs.dart';

class RemoveAds extends StatelessWidget {
  const RemoveAds({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Remove Ads"),
        actions:  [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: (){
              WristCheckDialogs.getRemoveAdsDialog();
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          SizedBox(height: 100,),
          Center(
            child: Text("Coming Soon",
              style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),),
          ),
          SizedBox(height: 50,),
          Center(
            child: Text(
                "Thank you for your interest in supporting WristCheck\n\n"
                "A pro upgrade is in the works to allow the removal of ads and will be available soon via a future update!\n\n",
            textAlign: TextAlign.center,),
          )
        ],
      ),
    );
  }
}
