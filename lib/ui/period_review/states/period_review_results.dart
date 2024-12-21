import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/review_controller.dart';
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
              onPageChanged: (index) => reviewController.updateIsLastPage(index == 1),
              children: [
                buildPage(
                    colour: Theme.of(context).canvasColor,
                    title: "Wears Tracked",
                    subtitleBig1: "${reviewController.wearsInPeriod.value} times",
                    subtitle2: "(that's ${(reviewController.wearsInPeriod.value/365).toStringAsFixed(2)} times per day since the first entry on ${WristCheckFormatter.getFormattedDate(reviewController.firstWearInYear.value)}!)",
                    subtitle1:"In ${reviewController.reviewYear.value} you tracked what was on your wrist"),

                buildPage(
                    colour: Theme.of(context).canvasColor,
                    title: "Your number one!",
                    subtitle1: "An app for watch enthusiasts. \nSwipe to learn what WristTrack can do..."),

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



    // return Column(
    //   children: [
    //     //First Result - total count for year
    //     Obx(()=> Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: ListTile(title: Text("In ${reviewController.reviewYear} you tracked what you were wearing ${reviewController.wearsInPeriod.value} times"),),
    //     )),
    //     Padding(
    //       padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    //       child: const Divider(thickness: 2,),
    //     ),
    //     //Second Result - Most worn watch
    //     Obx(()=> Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: ListTile(leading: FutureBuilder(
    //           future: ImagesUtil.getImage(reviewController.wearsInPeriodWatchList[0], true),
    //           builder: (context, snapshot) {
    //             //start
    //             if (snapshot.connectionState == ConnectionState.done) {
    //               // If we got an error
    //               if (snapshot.hasError) {
    //                 return const CircularProgressIndicator();
    //                 // if we got our data
    //               } else if (snapshot.hasData) {
    //                 // Extracting data from snapshot object
    //                 final data = snapshot.data as File;
    //                 return ConstrainedBox(
    //                   constraints: const BoxConstraints(
    //                     minHeight: 75,
    //                     maxHeight: 75,
    //                     minWidth: 75,
    //                     maxWidth: 75,
    //                   ),
    //                   child: Image.file(data),
    //                 );
    //
    //               }
    //             }
    //             return _getEmptyIcon(context);
    //           } //builder
    //       ),
    //         title: Text("Your top worn watch was your ${reviewController.wearsInPeriodWatchList[0].manufacturer} ${reviewController.wearsInPeriodWatchList[0].model}"),
    //       subtitle: Text("You wore it ${reviewController.wearsInPeriodWatchList[0].filteredWearList!.length} times"),),
    //     )),
    //     Padding(
    //       padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    //       child: const Divider(thickness: 2,),
    //     )
    //   ],
    // );
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

  Widget buildPage({
    required Color colour, //Background colour for the page
    //required String urlImage, //Path for the image - utilise with getImage Future
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
        // Image.asset(
        //   urlImage,
        //   fit: BoxFit.cover,
        //   width: double.infinity,
        // ),
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
          padding: const EdgeInsets.all(20.0),
          child: Text(
              subtitle3,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge
          ),
        ) : const SizedBox(height: 0,),
        subtitleBig3 != null? Container(
          padding: const EdgeInsets.all(20.0),
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
