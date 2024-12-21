import 'package:flutter/material.dart';

class WristCheckConfig{
  /*
  prodBuild can be used to determine if the app is in prod or test mode for builds
  for example, this can be set to false and then checked by the app to show test
  ads rather than using the prod ad units.
   */
  static bool prodBuild = true;

  /*
  getWCColour returns the shade of teal used in the WristTrack logo, to make it easily available throughout the app.
   */
  static Color getWCColour(){
    return const Color(0xff39a5c0);
  }
}