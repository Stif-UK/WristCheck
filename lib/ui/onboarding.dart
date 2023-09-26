import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';

class WristCheckOnboarding extends StatefulWidget {
  const WristCheckOnboarding({Key? key}) : super(key: key);

  @override
  State<WristCheckOnboarding> createState() => _WristCheckOnboardingState();
}

class _WristCheckOnboardingState extends State<WristCheckOnboarding> {
  final pageViewController = PageController();

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
          children: [
            buildPage(
                colour: Theme.of(context).canvasColor,
                urlImage: 'assets/demo/page1_logo.png',
                title: "Welcome to WristCheck!",
                subtitle: "An app for wristwatch enthusiasts.\n\nSwipe to learn what WristCheck can do!"),
            buildPage(
                colour: Theme.of(context).canvasColor,
                urlImage: Get.isDarkMode? 'assets/demo/watch_info_dark.png': 'assets/demo/watch_info_light.png',
                title: "Track Watch Information",
                subtitle: "Save details of your watches - WristCheck can record your serial numbers, purchase and sale information, any notes you want to keep...\n\n...and much more!"),
            Container(
              color: Colors.green,
              child: const Center(child: Text("Page 3")),
            ),
          ],
        ),
      ),
      bottomSheet:  Container(
        padding: const EdgeInsets.all(10.0),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                child: const Text("SKIP"),
            onPressed: (){
                  pageViewController.jumpToPage(2);
            },),
            Center(
              child: SmoothPageIndicator(
                  controller: pageViewController,
                  effect: SlideEffect(
                    type: SlideType.slideUnder,
                    dotColor: Get.isDarkMode? Colors.white24: Colors.black26,
                    activeDotColor: Color(0xff39a5c0),
                  ),
                  onDotClicked: (index) => pageViewController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn),
                  count: 3),
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
        const SizedBox(height: 40,),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xff39a5c0),
            fontSize: 32,
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 24,),
        Container(
          padding: const EdgeInsets.symmetric(),
          child: Text(
            subtitle,
              textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge
          ),
        )
      ],
    ),
  );
}
