import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/period_review/period_review_body.dart';

class PeriodReviewHome extends StatefulWidget {
  const PeriodReviewHome({super.key});

  @override
  State<PeriodReviewHome> createState() => _PeriodReviewHomeState();
}

class _PeriodReviewHomeState extends State<PeriodReviewHome> {
  final watchBox = Boxes.getAllWatches();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wrist Recap"),
      ),
      body: calculateEnoughData()? PeriodReviewBody() : notEnoughData(),
    );
  }

  /**
   * calculateEnoughData returns true if the user has tracked what they are wearing at least 30 times
   */
  bool calculateEnoughData() {
    bool result = false;
    print("Watchbox length: ${watchBox.length}");
    if(watchBox.length > 0){
      int count = 0;
      for(Watches watch in watchBox){
        count = count + watch.wearList.length;
      }
      if(count > 30){
        result = true;
      }
      print("Enough data count: $count");
      print("Result: $result");
    }
    return result;
  }

  Widget notEnoughData(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 25,),
          const Icon(FontAwesomeIcons.triangleExclamation, size: 40,),
          Text("Not Enough Data", style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center,),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("You haven't tracked enough data to generate a report yet.\n\nKeep logging watches and wear data then try again...",
              style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,),
          )
        ],
      ),
    );
  }
}
