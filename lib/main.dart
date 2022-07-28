import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wristcheck/ui/wristcheck_home.dart';
import 'package:wristcheck/theme/theme_constants.dart';
import 'package:get/get.dart';

void main() {
  runApp(
      GetMaterialApp(
          title: 'WristCheck',

        theme: lightTheme ,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        //ThemeMode.light,
        //ThemeMode.system,

        home:  WristCheckHome(),
      )

  );
  //Make the app full-screen
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}