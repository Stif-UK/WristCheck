import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/controllers/review_controller.dart';
import 'package:wristcheck/model/enums/review_state.dart';

class PeriodReviewLanding extends StatelessWidget {
  PeriodReviewLanding({super.key});
  final reviewController = Get.put(ReviewController());
  final double padInsets = 20.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(padInsets),
            child: Text("Welcome to the WristTrack Wrist Recap!\n\n"
                "Here you can generate an annual summary of your collection and wear habits.\n\n",
            style: Theme.of(context).textTheme.bodyLarge,),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Select a Year:", style: Theme.of(context).textTheme.bodyLarge),
                ),
                Obx(()=> DropdownButton(
                    value: reviewController.reviewYear.value,
                    items: reviewController.yearList.map((int year) {
                      return DropdownMenuItem<int>(
                          value: year,
                          child: Text(year.toString()));
                    }).toList(),
                    onChanged: (int? newYear){
                      if(newYear != null){
                        reviewController.updateReviewYear(newYear);
                      }
                    }
                ),
                ),
              ],
            ),
          ),

          ElevatedButton(child: Text("Generate Wrist Recap"),
          onPressed: () {
            //Disable the button if no year is selected
            reviewController.reviewYear.value == null? null :
            reviewController.updateReviewState(ReviewState.loading);
          },),
          const SizedBox(height: 50,),
          Padding(
            padding: EdgeInsets.all(padInsets),
            child: Text("Note: This feature is currently in BETA and will be enhanced over time - please consider it a work in progress!\n\n"
                "Results can currently only be generated for years with at least 30 days of tracked wear.\n\n"
                "Please feel free to reach out with feedback!",
              style: Theme.of(context).textTheme.bodyMedium,),
          )
        ],
      ),
    );
  }
}
