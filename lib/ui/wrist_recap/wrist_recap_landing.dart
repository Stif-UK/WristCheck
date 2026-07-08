import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_home.dart';

import '../period_review/period_review_home.dart';

class WristRecapLanding extends StatelessWidget {
  const WristRecapLanding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wrist Recap'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text("Monthly Wrist Recap"),
              onPressed: (){
                  DateTime now = DateTime.now();
                  DateTime lastMonth = DateTime(now.year, now.month-1);
                  Get.to(()=> WristRecapHome(month: lastMonth.month, year: lastMonth.year));
              },),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text("Annual Wrist Recap"),
                onPressed: ()=> Get.to(()=>const PeriodReviewHome()),
                ),
            )
          ],
        ),
      ),
    );
  }
}
