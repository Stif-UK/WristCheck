import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/ui/remove_ads.dart';

class DonationNotification extends StatelessWidget {
  DonationNotification({super.key});
  final wristCheckController = Get.put(WristCheckController());

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          //SizedBox to give card height
          SizedBox(height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 4.0, 0.0, 0.0),
                  child: IconButton(icon: FaIcon(FontAwesomeIcons.xmark),
                    onPressed: () => wristCheckController.dismissDonationNotification(DateTime.now()),),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("You donated to WristTrack ${wristCheckController.daysSinceLastDonation.value} days ago, thank you!", style: Theme.of(context).textTheme.bodyLarge,),
                  ),
                  const SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("If the app still provides value, please consider supporting again",
                      style: Theme.of(context).textTheme.bodyMedium,),
                  ),
                  Obx(() => wristCheckController.donationShowMore.value ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("WristTrack donations are used to continually improve the app and allow me to add more powerful features without a recurring subscription model.\n\nIf you dismiss this prompt you won't see it again for another year."),
                  ): const SizedBox.shrink()),
                  Obx(() => TextButton(
                      child: wristCheckController.donationShowMore.value ? Text("Show less", ) : Text("Show more"),
                      onPressed: wristCheckController.toggleDonationShowMore,
                    ),
                  )
                ],
              ),
            ),
          ),
          IconButton(
              icon: FaIcon(FontAwesomeIcons.chevronRight),
              onPressed: () {
                var now = DateTime.now();
                var lastMonth = DateTime(now.year, now.month - 1);
                wristCheckController.dismissRecapNotification(now);
                Get.to(() => RemoveAds());
              }),
        ],
      ),

    );
  }
}
