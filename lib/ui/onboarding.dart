import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/wristcheck_home.dart';

class WristCheckOnboarding extends StatefulWidget {
  const WristCheckOnboarding({Key? key}) : super(key: key);

  @override
  State<WristCheckOnboarding> createState() => _WristCheckOnboardingState();
}

class _WristCheckOnboardingState extends State<WristCheckOnboarding> {
  final pageViewController = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: pageViewController,
          onPageChanged: (index){
            setState(()=> isLastPage = index == 3);
          },
          children: [
            buildPage(
                colour: Theme.of(context).canvasColor,
                urlImage: 'assets/demo/page1_logo.png',
                title: "WristCheck",
                subtitle: "An app for watch enthusiasts. \nSwipe to learn what WristCheck can do..."),
            buildPage(
                colour: Theme.of(context).canvasColor,
                urlImage: Get.isDarkMode? 'assets/demo/watchbox_dark.png':'assets/demo/watchbox_light.png',
                title: "Your Digital Watchbox",
                subtitle: "Record all your watches - quickly search, re-organise or get a random pick"),
            buildPage(
                colour: Theme.of(context).canvasColor,
                urlImage: Get.isDarkMode? 'assets/demo/watch_info_dark.png': 'assets/demo/watch_info_light.png',
                title: "Track The Detail",
                subtitle: "Categorise and capture the particulars of your watches, or add your own notes"),
            buildPage(
                colour: Theme.of(context).canvasColor,
                urlImage: Get.isDarkMode? 'assets/demo/graph_dark.png':'assets/demo/graph_light.png',
                title: "Analyse The Data",
                subtitle: "Get insights into your collection through data and charts"),
          ],
        ),
      ),
      bottomSheet:  isLastPage? Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextButton(
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
              ),
            foregroundColor: Colors.white,
            backgroundColor: getWCColour(),
            minimumSize: const Size.fromHeight(80),
          ),
          child: const Text("Let's go!",
          style: TextStyle(fontSize: 22),),
          onPressed: () async {
            await WristCheckPreferences.setHasSeenDemo(true);
            Get.offAll(WristCheckHome());
          },
        ),
      ) :Container(
        padding: const EdgeInsets.all(10.0),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                child: const Text("SKIP"),
            onPressed: (){
                  pageViewController.jumpToPage(3);
            },),
            Center(
              child: SmoothPageIndicator(
                  controller: pageViewController,
                  effect: SlideEffect(
                    type: SlideType.slideUnder,
                    dotColor: Get.isDarkMode? Colors.white24: Colors.black26,
                    activeDotColor: getWCColour(),
                  ),
                  onDotClicked: (index) => pageViewController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn),
                  count: 4),
            ),
            TextButton(
              child: const Text("NEXT"),
              onPressed: (){
                pageViewController.nextPage(
                    duration: const Duration(microseconds: 500),
                    curve: Curves.easeInOut);
              },),
          ],
        ),
      ),
    );
  }


  Widget buildPage({
    required Color colour,
    required String urlImage,
    required String title,
    required String subtitle
  }) => Container(
    color: colour,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          urlImage,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        const SizedBox(height: 32,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: getWCColour(),
              fontSize: 32,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(height: 24,),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            subtitle,
              textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge
          ),
        )
      ],
    ),
  );

  Color getWCColour(){
    return const Color(0xff39a5c0);
  }
}
