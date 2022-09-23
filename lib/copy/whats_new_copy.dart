import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/material.dart';

class WhatsNewCopy{

  static String getLatestVersionCopy(){
    return "Wristcheck just updated!\n"
        "### Version 1.1.0 \n"
        "\n"

        "* See what's new when the app updates\n"
        "* Backup & Restore the watch database\n"
        "* Set up daily wear reminders\n"
        "* Reference number field added to watch model\n"
        "* Minor bug fixes and improvements";
  }


  static Widget getVersionHistory(BuildContext context){
    return  Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const Markdown(
          physics: ClampingScrollPhysics(),
            data:
            "### Version 1.1.0 \n"
                "\n"

                "* See what's new when the app updates\n"
                "* Backup & Restore the watch database\n"
                "* Set up daily wear reminders\n"
                "* Reference number field added to watch model\n"
                "* Minor bug fixes and improvements"
                "\n"

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