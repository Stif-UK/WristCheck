import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';


class LanguageController extends GetxController{
  final language = Locale(WristCheckPreferences.getLanguage()).obs;

  updateLocalePref(Locale value){
    WristCheckPreferences.setLanguage(value.toLanguageTag());
    language(value);
    Get.updateLocale(value);
  }


}
