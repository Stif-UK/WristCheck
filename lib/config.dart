import 'package:flutter/material.dart';

class WristCheckConfig{
  /*
  prodBuild can be used to determine if the app is in prod or test mode for builds
  for example, this can be set to false and then checked by the app to show test
  ads rather than using the prod ad units.
   */
  static bool prodBuild = true;
  /*
  To enable quickly and safely toggling between ad supported and Pro views in dev, this boolean can be toggled.
  When True the app acts as a prod app, acknowledging the set purchase status. If false the app is in a constant 'pro' state.
   */
  static bool acknowledgePurchase = true;

  /*
  Feature Flags: Setting to false disables the features for potential build/testing across multiple releases
   */
  static bool enableCSVUploads = false; //CSV Uploading
  static bool enableMultiDateWatchCalendar = true; //Multi-date picker on watch calendar view
  static bool enableLanguagePicker = true; //Language selection in Settings


  /*
  getWCColour returns the shade of teal used in the WristTrack logo, to make it easily available throughout the app.
   */
  static Color getWCColour(){
    return const Color(0xff39a5c0);
  }
}