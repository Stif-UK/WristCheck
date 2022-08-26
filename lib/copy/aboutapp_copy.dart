import 'package:flutter/material.dart';

class AboutAppCopy{


  static Widget getAboutWristCheckCopy(){
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: Text("WristCheck is a digital watch box application.\n\n"
          "It provides the ability to track your current (and sold) watches, as well as to build a wishlist of those which you might like to purchase in the future.\n\n"
          "You can use it to track service schedules for your mechanical watches and draw graphs of what you're wearing most.\n\n"
          "Think it's missing something? Drop the developer a message or review via your favourite app store!"
          ),
    );
  }

  static Widget getAboutDeveloperCopy(){
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: Text("Who or what is a StifDEV? \n"
          "\nStifDEV is simply the name I use to release my applications, essentially a 'nom de plume'. There's a long, and not very interesting, story behind the name,"
          "but in short I'm just a guy who likes to play around with code in my spare time.\n"
          "\nWith a busy full time job and young children my time to do so is limited, but hopefully I've managed to build an application that others will get some value from - if you do like the app, please consider leaving a review to let me know!"
      ),
    );
  }

  static Widget getAcknowledgementCopy(){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: const [
          Text("This application is build with the use of the following libraries:",
          style: TextStyle(fontWeight: FontWeight.bold),),
          Divider(thickness: 2),
          Text("GetX has been used for state management and page routing. "
              "\nAvailable at pub.dev/packages/get \n"
              "Distributed under the MIT Licence."),
          Divider(thickness: 2),
          Text("Hive has been utilised to provide the database underpinning the application."
              "\nAvailable at pub.dev/packages/hive \n"
              "Distributed under the Apache 2.0 Licence."),
          Divider(thickness: 2),
          Text("Jiffy has been used to perform date based calculations."
              "\nAvailable at pub.dev/packages/jiffy \n"
              "Distributed under the MIT Licence."),
          Divider(thickness: 2),
          Text("Syncfusion Charts have been used to draw charts."
              "\nAvailable at pub.dev/packages/syncfusion_flutter_charts \n"
              "Distributed and used under the Syncfusion Community Licence."),
          Divider(thickness: 2)
        ],
      ),
    );


  }
}

