import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/material.dart';

class WhatsNewCopy{

  static String getLatestVersionCopy(){
    return "Wristcheck just updated!\n"
        "### Version 1.0.0 \n"
        "\n"

        "* Create Watch box\n"
        "* Create Wish list\n"
        "* Capture dates watches worn\n"
        "* Draw cool graphs";
  }

  // static String getVersionHistory(){
  //   return "### Version 1.0.0 \n"
  //       "\n"
  //
  //       "* Create Watch box\n"
  //       "* Create Wish list\n"
  //       "* Capture dates watches worn\n"
  //       "* Draw cool graphs";
  // }

  static Widget getVersionHistory(BuildContext context){
    return  Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const Markdown(
          physics: ClampingScrollPhysics(),
            data:
        "### Version 1.0.0 \n"
            "\n"

            "* Create Watch box\n"
            "* Create Wish list\n"
            "* Capture dates watches worn\n"
            "* Draw cool graphs\n"

        ),
      ),
    );
  }
}