import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/review_controller.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/images_util.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class PeriodReviewResults extends StatefulWidget {
  PeriodReviewResults({super.key});

  @override
  State<PeriodReviewResults> createState() => _PeriodReviewResultsState();
}

class _PeriodReviewResultsState extends State<PeriodReviewResults> {
  final reviewController = Get.put(ReviewController());
  final periodPageViewController = PageController();

  @override
  void dispose() {
    periodPageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Scaffold(
        body: Container(
            padding: const EdgeInsets.only(bottom: 80),
            child: PageView(
              controller: periodPageViewController,
              //TODO: Need to programmatically understand the final index? If hard coding must update in line with pages built
              onPageChanged: (index) => reviewController.updateIsLastPage(index == 4),
              children: [
                //Result 1 - Total wears tracked
                buildPage(
                    colour: Theme.of(context).canvasColor,
                    title: "Wears Tracked",
                    subtitle1:"In ${reviewController.reviewYear.value} you tracked what was on your wrist",
                    subtitleBig1: "${reviewController.wearsInPeriod.value} times",
                    subtitle2: "(that's ${(reviewController.wearsInPeriod.value/365).toStringAsFixed(2)} times per day since the first entry on ${WristCheckFormatter.getFormattedDate(reviewController.firstWearInYear.value)}!)",
                ),

                //TODO: Handle case where less than three watches tracked!
                //Result 2 - Top 3 - position 3
                buildPage(
                    colour: Theme.of(context).canvasColor,
                    title: "The top three!",
                    subtitle1: "In at number three,\nyour third most worn watch this year was your...",
                    watch: reviewController.wearsInPeriodWatchList[2],
                    subtitleBig2: "${reviewController.wearsInPeriodWatchList[2].manufacturer} ${reviewController.wearsInPeriodWatchList[2].model}",
                    subtitle3: "You wore it ${reviewController.wearsInPeriodWatchList[2].filteredWearList!.length} times"
                ),
                //TODO: Handle case where less than two watches tracked!
                //Result 3 - Top 3 - position 2
                buildPage(
                    colour: Theme.of(context).canvasColor,
                    title: "The Runner Up!",
                    subtitle1: "In second place,\nyour second most worn watch in ${reviewController.reviewYear} was...",
                    watch: reviewController.wearsInPeriodWatchList[1],
                    subtitle2: reviewController.wearsInPeriodWatchList[1].frontImagePath == null || reviewController.wearsInPeriodWatchList[1].frontImagePath == ""? "(you haven't saved a picture of this one!)" : null,
                    subtitleBig2: "${reviewController.wearsInPeriodWatchList[1].manufacturer} ${reviewController.wearsInPeriodWatchList[1].model}",
                    subtitle3: "You tracked it on your wrist ${reviewController.wearsInPeriodWatchList[1].filteredWearList!.length} times"
                ),
                //Result 4 - Top 3 - position 1
                buildPage(
                    colour: Theme.of(context).canvasColor,
                    title: "The Top Dog!",
                    subtitle1: "Your most worn watch of ${reviewController.reviewYear} is the...",
                    watch: reviewController.wearsInPeriodWatchList[0],
                    subtitle2: reviewController.wearsInPeriodWatchList[0].frontImagePath == null || reviewController.wearsInPeriodWatchList[0].frontImagePath == ""? "(you haven't saved a picture of this one!)" : null,
                    subtitleBig2: "${reviewController.wearsInPeriodWatchList[0].manufacturer} ${reviewController.wearsInPeriodWatchList[0].model}",
                    subtitleBig3: "With ${reviewController.wearsInPeriodWatchList[0].filteredWearList!.length} wears tracked!"
                ),
              ],
            ),
          ),
        bottomSheet:  reviewController.isLastPage.value? Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
              ),
              foregroundColor: Colors.white,
              backgroundColor: WristCheckConfig.getWCColour(),
              minimumSize: const Size.fromHeight(80),
            ),
            child: const Text("Let's go!",
              style: TextStyle(fontSize: 22),),
            onPressed: () async {
              //TODO: Remove buttons
            },
          ),
        ) :Container(
          padding: const EdgeInsets.all(10.0),
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextButton(
                  child: const Text("BACK"),
                  onPressed: (){
                    periodPageViewController.previousPage(
                        duration: const Duration(microseconds: 500),
                        curve: Curves.easeInOut);
                  },),
              ),
              Center(
                child: SmoothPageIndicator(
                    controller: periodPageViewController,
                    effect: SlideEffect(
                      type: SlideType.slideUnder,
                      dotColor: Get.isDarkMode? Colors.white24: Colors.black26,
                      activeDotColor: WristCheckConfig.getWCColour(),
                    ),
                    onDotClicked: (index) => periodPageViewController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn),
                    count: 4),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextButton(
                  child: const Text("NEXT"),
                  onPressed: (){
                    periodPageViewController.nextPage(
                        duration: const Duration(microseconds: 500),
                        curve: Curves.easeInOut);
                  },),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getEmptyIcon(context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(125.0),
      child: Image.asset('assets/icon/drawerheader.png', width: 200,),
    );
  }

  Widget buildPage({
    required Color colour, //Background colour for the page
    Watches? watch, //A watch - utilise with getImage Future
    required String title, //
    required String subtitle1,
    String? subtitleBig1,
    String? subtitle2,
    String? subtitleBig2,
    String? subtitle3,
    String? subtitleBig3
  }) => Container(
    color: colour,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 32,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: WristCheckConfig.getWCColour(),
                fontSize: 32,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(height: 24,),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
              subtitle1,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge
          ),
        ),
        subtitleBig1 != null? Container(
          padding: const EdgeInsets.all(20.0),
          child: Text(
              subtitleBig1,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall
          ),
        ) : const SizedBox(height: 0,),
        //If we have an image, use a Futurebuilder to return it
        watch != null?
        FutureBuilder(
            future: ImagesUtil.getImage(watch, true),
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
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(125.0),
                      child: Image.file(data, width: 250,),
                    ),
                  );
                }
              }
              return _getEmptyIcon(context);
            } //builder
        ) : const SizedBox(height: 0,),
        subtitle2 != null? Container(
          padding: const EdgeInsets.all(20.0),
          child: Text(
              subtitle2,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge
          ),
        ) : const SizedBox(height: 0,),
        subtitleBig2 != null? Container(
          padding: const EdgeInsets.all(20.0),
          child: Text(
              subtitleBig2,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall
          ),
        ) : const SizedBox(height: 0,),
        subtitle3 != null? Container(
          padding: const EdgeInsets.all(10.0),
          child: Text(
              subtitle3,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge
          ),
        ) : const SizedBox(height: 0,),
        subtitleBig3 != null? Container(
          padding: const EdgeInsets.all(10.0),
          child: Text(
              subtitleBig3,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall
          ),
        ) : const SizedBox(height: 0,),
      ],
    ),
  );
}
