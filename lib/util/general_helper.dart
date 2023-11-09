import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GeneralHelper{

  static launchInstagram() async {
    // var nativeUrl = "instagram://user?username=wristcheck.app";
    // var webUrl = "https://www.instagram.com/wristcheck.app";

    launchUrl(
      Uri.parse('https://www.instagram.com/wristcheck.app/'),
      mode: LaunchMode.externalApplication,
    );
    // try {
    //   await launchUrlString(nativeUrl, mode: LaunchMode.externalApplication);
    // } catch (e) {
    //   print(e);
    //   await launchUrlString(webUrl, mode: LaunchMode.platformDefault);
    // }
  }
}