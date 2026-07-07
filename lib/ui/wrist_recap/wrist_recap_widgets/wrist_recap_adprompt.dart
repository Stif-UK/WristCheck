import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/controllers/wrist_recap_controllers/wrist_recap_monthly_controller.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/remove_ads.dart';

class WristRecapAdprompt extends StatelessWidget {
  WristRecapAdprompt({super.key});
  final recapController = Get.put(WristRecapMonthlyController());

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              //give the Card fixed height
              const SizedBox(height: 80,),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 4.0, 8.0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image:  AssetImage('assets/icon/drawerheader.png'),
                        fit: BoxFit.contain
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Thanks for using WristTrack", style: Theme.of(context).textTheme.bodyLarge,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Please consider clicking the play button to watch an optional short ad to support the app", softWrap: true,),
                    ),
                    Obx(() => recapController.expandAdCard.value
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("WristTrack relies on donations and ad revenue to thrive. Watching an ad means a lot to me, and is hopefully only a small inconvenience to you.", softWrap: true,),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Alternatively, why not consider unlocking WristTrack Pro with a donation. Click the icon to learn more", softWrap: true,),
                              ),
                              IconButton(
                                icon: Image.asset('assets/customicons/pro_icon.png', scale: 1.0, height: 80.0, width: 80.0, color: Theme.of(context).hintColor),
                                onPressed: () => Get.to(RemoveAds()),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    ),

                    Obx(() => TextButton(
                        child: Text(recapController.expandAdCard.value? "Show Less" : "Show more"),
                        onPressed: recapController.toggleAdCard,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesomeIcons.rectangleAd),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesomeIcons.play),
              ),
            ],
          ),
        )
    );
  }
}
