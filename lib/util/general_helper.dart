import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class GeneralHelper{

  static launchInstagram() async {
    launchUrl(
      Uri.parse('https://www.instagram.com/wristtrack.app/'),
      mode: LaunchMode.externalApplication,
    );
  }
  
  static sendFeedbackEmail() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'feedback@wristtrack.app',
      query: encodeQueryParameters(<String, String>{
        'subject': 'WristTrack Feedback',
      }),
    );

    if (!await launchUrl(emailLaunchUri)) {
      Get.defaultDialog(
        title: "Error",
        content: Text("Failed to launch email application.\n\n"
            "You can manually do this by emailing\n\nfeedback@wristtrack.app\n\n"
            "Thank you.", textAlign: TextAlign.center,)
      );
    }
    ;
  }

  static Future<bool> dateCompare(DateTime date1, DateTime date2) async{
    bool result = false;
    if(date1.year == date2.year && date1.month == date2.month && date1.day == date2.day){
      result = true;
    }
    return result;
  }
}

