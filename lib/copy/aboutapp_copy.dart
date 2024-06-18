import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AboutAppCopy{


  static Widget getAboutWristCheckCopy(){
    return Container(
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Markdown(
          shrinkWrap: true,
            data: "**WristTrack is a digital watch box application.**\n\n"
                "It allows you to track your watch collection and generate charts and data insights.\n\n"
                "*Key features:*\n"
                "* Create watch records to record key details.\n"
                "* Capture the value of bought and sold watches.\n"
                "* Record what watches you're wearing and generate charts to understand your wear patterns.\n"
                "* Save a wishlist of watches you'd like to buy.\n"
                "* Track watch pre-orders and generate a countdown to release.\n\n"
            "Think it's missing something? Drop the developer a message or review via your favourite app store!"
            ),
      ),
    );
  }

  static Widget getAboutDeveloperCopy(){
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: Text("When I'm not working a busy full time job, or spending time with my young kids, I like to build apps as a hobby.\n\n"
          "I'm a watch nerd so when I struggled to find an app that would replace the spreadsheet I was using to track my collection and what I was wearing, I decided to build my own!\n\n"
          "If you'd like to know more you can follow me on Instagram where I post watch shots and app development updates as 'wristcheck.app'\n"
      ),
    );
  }

  static Widget getAcknowledgementCopy(){
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: [
          Text("This application is build with the use of the following libraries and services:",
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
          Divider(thickness: 2),
          Text("Syncfusion Calendar has been used to implement calendar and schedule views."
              "\nAvailable at pub.dev/packages/syncfusion_flutter_calendar \n"
              "Distributed and used under the Syncfusion Community Licence."),
          Divider(thickness: 2),
          Text("Font Awesome Icons have been used throughout the app."
              "\nAvailable at fontawesome.com \n"
              "Distributed and used under the CC BY 4.0 licence."),
          Divider(thickness: 2),
          Text("Image_Cropper library has been used to allow cropping images uploaded to the app"
              "\nAvailable at pub.dev/packages/image_cropper  \n"
              "Distributed under the BSD-3-clause licence."),
          Divider(thickness: 2),
          Text("App Icons were generated for all platforms with the help of easyappicon.com"
              "\nUsing assets created by Umar Irshad available from iconfinder.com"),
          Divider(thickness: 2),
          Text("With thanks to the users and contributors of the Christopher Ward Forum."
              "\nTheir input and support was invaluable to the development of this application.",
            style: TextStyle(fontWeight: FontWeight.bold),),
          Divider(thickness: 2)
        ],
      ),
    );


  }
}

