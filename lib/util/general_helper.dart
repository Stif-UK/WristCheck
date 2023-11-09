import 'package:url_launcher/url_launcher.dart';

class GeneralHelper{

  static launchInstagram() async {
    launchUrl(
      Uri.parse('https://www.instagram.com/wristcheck.app/'),
      mode: LaunchMode.externalApplication,
    );
  }
}