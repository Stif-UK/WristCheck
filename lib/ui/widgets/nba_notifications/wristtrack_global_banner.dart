import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/ui/widgets/icons/wt_static_icon.dart';
import 'package:wristcheck/util/global_notification_helper.dart';

class WristtrackGlobalBanner extends StatelessWidget {
  WristtrackGlobalBanner({super.key});
  final wristCheckController = Get.find<WristCheckController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (wristCheckController.globalBannerDismissible.value)
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
                        onPressed: () => wristCheckController.dismissGlobalBannerNotification(
                          wristCheckController.globalBannerId.value,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 4.0, 8.0),
              child: SizedBox(
                width: 40,
                height: 40,
                child: _buildBannerIcon(),
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
                      child: Text(
                        wristCheckController.globalBannerTitle.value,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        wristCheckController.globalBannerMessage.value,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Obx(() => wristCheckController.globalBannerExpanded.value
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(wristCheckController.globalBannerExtendedMessage.value),
                          )
                        : const SizedBox.shrink()),
                    if (wristCheckController.globalBannerShowMore.value)
                      Obx(
                        () => TextButton(
                          child: Text(
                            wristCheckController.globalBannerExpanded.value
                                ? (AppLocalizations.of(context)?.showLess ?? 'Show Less')
                                : (AppLocalizations.of(context)?.showMore ?? 'Show More'),
                          ),
                          onPressed: wristCheckController.toggleGlobalBannerShowMore,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.chevronRight),
              onPressed: () => _handleTap(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerIcon() {
    String type = wristCheckController.globalBannerType.value.toLowerCase();
    switch (type) {
      case 'warning':
        return const Center(
          child: FaIcon(
            FontAwesomeIcons.triangleExclamation,
            color: Colors.red,
            size: 24,
          ),
        );
      case 'info':
        return const Center(
          child: FaIcon(
            FontAwesomeIcons.circleInfo,
            color: Colors.blue,
            size: 24,
          ),
        );
      case 'announcement':
      default:
        return const WtStaticIcon(dimensions: 40);
    }
  }

  void _handleTap(BuildContext context) {
    String actionUrl = wristCheckController.globalBannerActionUrl.value;
    if (actionUrl.isNotEmpty) {
      GlobalNotificationHelper.handleBannerTap(context, actionUrl);
    }
    wristCheckController.dismissGlobalBannerNotification(wristCheckController.globalBannerId.value);
  }
}
