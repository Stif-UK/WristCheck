import 'package:url_launcher/url_launcher.dart';

class GeneralHelper{

  static launchInstagram() async {
    launchUrl(
      Uri.parse('https://www.instagram.com/wristcheck.app/'),
      mode: LaunchMode.externalApplication,
    );
  }

  static Future<bool> dateCompare(DateTime date1, DateTime date2) async{
    bool result = false;
    if(date1.year == date2.year && date1.month == date2.month && date1.day == date2.day){
      result = true;
    }
    return result;
  }
}

