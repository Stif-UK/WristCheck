import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/**
 * Global Notification Helper provides methods to support the triggering of a
 * notification banner via Firebase Remote Config by parsing the JSON payload
 * and providing methods to trigger the notificaiton and handle both external
 * URLs and in-app deep links.
 */

class GlobalNotificationHelper {

  static void handleBannerTap(BuildContext context, String actionUrl) async {
    if (actionUrl.isNotEmpty) {
      final Uri? uri = Uri.tryParse(actionUrl);
      if (uri != null) {
        try {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (e) {
          debugPrint('Could not launch $actionUrl: $e');
        }
      }
    }
  }

}