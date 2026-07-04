import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              onPressed: (){},),
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
