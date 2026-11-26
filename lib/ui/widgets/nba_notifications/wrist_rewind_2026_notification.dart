import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/ui/widgets/animations/wt_banner_icon.dart';
import 'package:wristcheck/ui/wrist_recap/animated_recap_preview_page.dart';

class WristRewind2026Notification extends StatelessWidget {
  WristRewind2026Notification({super.key, this.iconOverride});
  final wristCheckController = Get.find<WristCheckController>();
  final Widget? iconOverride;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigateAndDismiss,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            // SizedBox to give card height
            SizedBox(
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 4.0, 0.0, 0.0),
                    child: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.xmark),
                      onPressed: () => wristCheckController.dismissWristRewind2026Notification(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 4.0, 8.0),
              child: SizedBox(
                width: 40,
                height: 40,
                child: iconOverride ?? const WTBannerIcon(fallbackIconDimensions: 40),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your 2026 Wrist Rewind is here!',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Click here to see your animated year in review!',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.chevronRight),
              onPressed: _navigateAndDismiss,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateAndDismiss() {
    // Perform navigation BEFORE dismissing the notification.
    // Calling dismissWristRewind2026Notification immediately removes this widget from the tree (via Obx in WristCheckHome/Watchbox),
    // which can interrupt the navigation process or invalidate the context.
    Get.to(() => const AnimatedRecapPreviewPage());
    wristCheckController.dismissWristRewind2026Notification();
  }
}
