import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class RemoveAdsCopy{

  static getPageTitle(){
    return const Text("Remove Ads");
  }

  static getPageTitleSupporter(){
    return const Text("Support WristTrack");
  }


  static getRemoveAdsMainCopy(BuildContext context){
    return Container(
      child: Markdown(
          shrinkWrap: true,
          styleSheet: MarkdownStyleSheet(p: Theme.of(context).textTheme.bodyLarge),
          data:
          "The core features of **WristTrack** are free, supported by small ads throughout the app.\n\n"
              "However, you can remove these ads by picking a price for the app below - all options will upgrade the app to **WristTrack Pro**.\n\n"
              "**WristTrack Pro** also unlocks:\n\n"
              "* The option to set a second daily reminder\n"
              "* Individual watch charts showing wear stats by months and weekdays.\n"
              "* A Cost Per Wear chart for your collection. "

      ),
    );
  }

  static getSupporterMainCopy(BuildContext context){
    return Text(
      "Thank you for supporting WristTrack!\n\n"
          "Your support means a lot and makes it possible for me to continue to develop WristTrack and other apps like it.\n\n"
          "If you're enjoying the app please consider telling your friends about it or leave a review to let me know what you like about the app and what else you'd like to see added to it!\n\n"
          "If you'd like to continue to support WristTrack additional donations can be made at any time.",
      style: Theme.of(context).textTheme.bodyLarge,);
  }



  static getButtonLabel(){
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: Text("Show Payment Options"),
    );
  }

  static getButtonLabelSupporter(){
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: Text("Donate Again"),
    );
  }
}