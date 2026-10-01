import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/**
 * Global Notification Helper provides methods to support the triggering of a
 * notification banner via Firebase Remote Config by parsing the JSON payload
 * and providing methods to trigger the notification and handle both external
 * URLs and in-app deep links.
 */

class GlobalNotificationHelper {

  static void handleBannerTap(BuildContext context, String actionUrl) async {
    if (actionUrl.isEmpty) return;

    // Check if it's an internal deep link (starts with '/' or custom scheme like 'wristcheck://')
    if (actionUrl.startsWith('/') || actionUrl.startsWith('wristcheck://')) {
      String routePath = actionUrl;
      if (actionUrl.startsWith('wristcheck://')) {
        final uri = Uri.tryParse(actionUrl);
        if (uri != null) {
          routePath = '/${uri.pathSegments.join('/')}';
          if (!routePath.startsWith('/')) {
            routePath = '/$routePath';
          }
        }
      }

      try {
        Get.toNamed(routePath);
        return;
      } catch (e) {
        debugPrint('Failed to navigate to route $routePath: $e');
      }
    }

    // Otherwise, handle as external web URL
    final Uri? uri = Uri.tryParse(actionUrl);
    if (uri != null) {
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        debugPrint('Could not launch external URL $actionUrl: $e');
      }
    }
  }

}
