import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/review_controller.dart';
import 'package:wristcheck/util/images_util.dart';

class PeriodReviewResults extends StatelessWidget {
  PeriodReviewResults({super.key});
  final reviewController = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //First Result - total count for year
        Obx(()=> Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(title: Text("In ${reviewController.reviewYear} you tracked what you were wearing ${reviewController.wearsInPeriod.value} times"),),
        )),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: const Divider(thickness: 2,),
        ),
        //Second Result - Most worn watch
        Obx(()=> Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(leading: FutureBuilder(
              future: ImagesUtil.getImage(reviewController.wearsInPeriodWatchList[0], true),
              builder: (context, snapshot) {
                //start
                if (snapshot.connectionState == ConnectionState.done) {
                  // If we got an error
                  if (snapshot.hasError) {
                    return const CircularProgressIndicator();
                    // if we got our data
                  } else if (snapshot.hasData) {
                    // Extracting data from snapshot object
                    final data = snapshot.data as File;
                    return ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 75,
                        maxHeight: 75,
                        minWidth: 75,
                        maxWidth: 75,
                      ),
                      child: Image.file(data),
                    );

                  }
                }
                return _getEmptyIcon(context);
              } //builder
          ),
            title: Text("Your top worn watch was your ${reviewController.wearsInPeriodWatchList[0].manufacturer} ${reviewController.wearsInPeriodWatchList[0].model}"),
          subtitle: Text("You wore it ${reviewController.wearsInPeriodWatchList[0].filteredWearList!.length} times"),),
        )),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: const Divider(thickness: 2,),
        )
      ],
    );
  }

  //TODO: Refactor out into ImagesUtil class - this returns a simple icon where no watch image is saved
  Widget _getEmptyIcon(context) {
    return Container(
        width: 75,
        height: 75,
        decoration: BoxDecoration(
            border: Border.all(color: Theme
                .of(context)
                .disabledColor)
        ),
        child: const Icon(Icons.watch));

  }
}
