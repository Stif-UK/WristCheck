import 'dart:io' show Platform;

class WristCheckKeys{
  static String getRevenueCatKey(){
    return Platform.isAndroid? "" : "";
  }
}