import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/review_controller.dart';
import 'package:wristcheck/ui/period_review/pages/collection_growth.dart';
import 'package:wristcheck/ui/period_review/pages/tracking_summary.dart';
import 'package:wristcheck/ui/period_review/widgets/review_page.dart';

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
    List<Widget> pageList = _generatePages();

    return Obx(()=>
      Scaffold(
        body: Container(
            padding: const EdgeInsets.only(bottom: 80),
            child: PageView(
              controller: periodPageViewController,
              onPageChanged: (index) => reviewController.updateIsLastPage(index == pageList.length-1),
              children:
              pageList,
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
            child: const Text("Thanks for using WristTrack!",
              style: TextStyle(fontSize: 22),textAlign: TextAlign.center,),
            onPressed: () async {
              Get.back();
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
}

List<Widget> _generatePages() {
  final reviewController = Get.put(ReviewController());
  return [
    //Result 1 - Total wears tracked
    ReviewTrackingSummary(),
    CollectionGrowth(),
    //TODO: Test results where there are less than three watches to report results on
    //Result 2 - Top 3 - position 3
    reviewController.wearsInPeriodWatchList.length > 3? ReviewPage(
        colour: Theme.of(Get.context!).canvasColor,
        title: "The Top Three!",
        subtitle1: "In at number three,\nyour third most worn watch this year was your...",
        watch: reviewController.wearsInPeriodWatchList[2],
        subtitleBig2: "${reviewController.wearsInPeriodWatchList[2].manufacturer} ${reviewController.wearsInPeriodWatchList[2].model}",
        subtitle3: "You wore it ${reviewController.wearsInPeriodWatchList[2].filteredWearList!.length} times",
        subtitle4: "(that's once every ${(reviewController.daysSinceFirstRecordInYear.value / reviewController.wearsInPeriodWatchList[2].filteredWearList!.length).toStringAsFixed(2)} days since you started tracking this year!)"
    ) : ReviewPage(colour: Theme.of(Get.context!).canvasColor, title: "The Top Three!", subtitle1: "You haven't tracked three watches for ${reviewController.reviewYear}!", subtitle2: "So there's nothing to show here, sorry!"),
    //Result 3 - Top 3 - position 2
    reviewController.wearsInPeriodWatchList.length > 2? ReviewPage(
        colour: Theme.of(Get.context!).canvasColor,
        title: "The Runner Up!",
        subtitle1: "In second place,\nyour second most worn watch in ${reviewController.reviewYear} was...",
        watch: reviewController.wearsInPeriodWatchList[1],
        subtitle2: reviewController.wearsInPeriodWatchList[1].frontImagePath == null || reviewController.wearsInPeriodWatchList[1].frontImagePath == ""? "(you haven't saved a picture of this one!)" : null,
        subtitleBig2: "${reviewController.wearsInPeriodWatchList[1].manufacturer} ${reviewController.wearsInPeriodWatchList[1].model}",
        subtitle3: "You tracked it on your wrist ${reviewController.wearsInPeriodWatchList[1].filteredWearList!.length} times"
    ): ReviewPage(colour: Theme.of(Get.context!).canvasColor, title: "Second Place...", subtitle1: "You haven't tracked two watches for ${reviewController.reviewYear}!"),
    //Result 4 - Top 3 - position 1
    ReviewPage(
        colour: Theme.of(Get.context!).canvasColor,
        title: "The Top Dog!",
        subtitle1: "Your most worn watch of ${reviewController.reviewYear} is the...",
        watch: reviewController.wearsInPeriodWatchList[0],
        subtitle2: reviewController.wearsInPeriodWatchList[0].frontImagePath == null || reviewController.wearsInPeriodWatchList[0].frontImagePath == ""? "(you haven't saved a picture of this one!)" : null,
        subtitleBig2: "${reviewController.wearsInPeriodWatchList[0].manufacturer} ${reviewController.wearsInPeriodWatchList[0].model}",
        subtitleBig3: "With ${reviewController.wearsInPeriodWatchList[0].filteredWearList!.length} wears tracked!"
    ),
  ];
}
