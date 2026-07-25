import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/ui/remove_ads.dart';

class GoProNotification extends StatelessWidget {
  GoProNotification({super.key});
  final wristCheckController = Get.find<WristCheckController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateAndDismiss(),
      child: Card(
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
                      onPressed: () => wristCheckController.dismissGoProNotification(DateTime.now()),),
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
                      //TODO: Refine this text
                      child: Text("Enjoying WristTrack? Why not upgrade to Pro for even more!", style: Theme.of(context).textTheme.bodyLarge,),
                    ),
                    const SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Unlock premium features and support the development of WristTrack.",
                        style: Theme.of(context).textTheme.bodyMedium,),
                    ),
                    Obx(() => wristCheckController.goProShowMore.value ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("WristTrack donations are used to continually improve the app and allow me to add more powerful features without a recurring subscription model."),
                    ): const SizedBox.shrink()),
                    Obx(() => TextButton(
                      child: wristCheckController.goProShowMore.value ? Text("Show less", ) : Text("Show more"),
                      onPressed: wristCheckController.toggleGoProShowMore,
                    ),
                    )
                  ],
                ),
              ),
            ),
            IconButton(
                icon: FaIcon(FontAwesomeIcons.chevronRight),
                onPressed: () => _navigateAndDismiss()
                ),
          ],
        ),

      ),
    );
  }

  _navigateAndDismiss(){
    var now = DateTime.now();
    Get.to(() => RemoveAds());
    wristCheckController.dismissGoProNotification(now);

  }
}
