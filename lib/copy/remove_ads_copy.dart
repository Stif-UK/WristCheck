import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class RemoveAdsCopy{

  static getPageTitle(){
    return const Text("Remove Ads");
  }

  static getPageTitleSupporter(){
    return const Text("Support WristCheck");
  }

  // static getRemoveAdsMainCopy(BuildContext context){
  //   return Text(
  //     "The core features of WristCheck are free, supported by small ads throughout the app"
  //         "\n\nHowever if you would like to support the app development and remove ads, you can click below to see in-app purchase "
  //         "options."
  //         "\n\nPaying doesn't unlock any additional functionality (everything is free!) it simply removes ads and hopefully gives you a warm feeling that you're"
  //         " supporting someone that finds their fun creating little apps that others can (hopefully) enjoy!",
  //     style: Theme.of(context).textTheme.bodyLarge,);
  // }

  static getRemoveAdsMainCopy(BuildContext context){
    return Container(
      child: Markdown(
          shrinkWrap: true,
          styleSheet: MarkdownStyleSheet(p: Theme.of(context).textTheme.bodyLarge),
          data:
          "The core features of **WristCheck** are free, supported by small ads throughout the app.\n\n"
              "However, you can remove these ads by picking a price for the app below - all options will upgrade the app to **WristCheck Pro**.\n\n"
              "**WristCheck Pro** also unlocks:\n\n"
              "* The option to set a second daily reminder\n"
              "* Individual watch charts showing wear stats by months and weekdays. "

      ),
    );
  }

  static getSupporterMainCopy(BuildContext context){
    return Text(
      "Thank you for supporting WristCheck!\n\n"
          "Your support means a lot and makes it possible for me to continue to develop WristCheck and other apps like it.\n\n"
          "If you're enjoying the app please consider telling your friends about it or leave a review to let me know what you like about the app and what else you'd like to see added to it!\n\n"
          "If you'd like to continue to support WristCheck additional donations can be made at any time.",
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