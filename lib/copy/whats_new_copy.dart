import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/material.dart';

class WhatsNewCopy{

  static String getLatestVersionCopy(){
    return
        "### Version 1.7.0 \n"
        "\n"

        "* Update to Wear Charts\n"
            "* Additional time filters\n"
            "* New advanced filters\n";

  }


  static Widget getVersionHistory(BuildContext context){
    return  Container(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
          child: const Markdown(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
              data:
                  "## Latest Version:\n"
                      "### Version 1.7.0 \n"
                      "\n"

                      "* Update to Wear Charts\n"
                      "* Additional time filters\n"
                      "* New advanced filters\n"
                      "* Chart now expands if it holds too much data for a single page\n"
                      "* Updated screenshot code to capture full chart if larger than one page\n"
                      "--- \n\n"
                      "### Version 1.6.4 \n"
                      "\n"

                      "* Updated Notifications code to support latest OS versions (you may need to reset your daily notification: See Settings > Daily Reminder)\n"
                      "* New 'Pre-Order' status added to watches allowing a countdown to release\n"
                      "* Option to bulk export watch images added, to simplify moving to a new device\n"
                      "* Implemented Crashlytics logging\n"
                      "* Fixed bug preventing Version History from fully scrolling\n"
                      "--- \n\n"

                      "### Version 1.6 \n"
                      "\n"

                      "* UI overhaul of the watch view!\n"
                      "* Multiple additional data points, including:\n"
                      "* Purchase and sale information\n"
                      "* Watch categories and movement types\n"
                      "* Plus additional Collection Stats & Charts!\n"
                  "--- \n\n"
              "### Version 1.5 \n"
                  "\n"

                  "* UI overhaul of the main watchbox!\n"
                  "* Watch images now show in watchbox view\n"
                  "* Quicker access to search\n"
                  "* Adjust the display order of your collection\n"
                  "* Choose a list or grid view for the UI\n"
                  "* Updates to software libraries and OS target levels\n"
                  "* Bug fixes\n"
                  "--- \n\n"
              "### Version 1.4.1 \n"
                  "\n"

                  "* WristCheck Pro added!\n"
                  "* Remove Ads with an in-app purchase\n\n"
                  "* Pick chart default order options\n\n"
                  "* Bug fix related to saving images with special characters in the watch name\n\n"
                  "--- \n\n"
              "### Version 1.3.0 \n"
                  "\n"

                  "* Caseback images - add a second photo to each watch\n"
                  "* Add images when creating new watch records\n"
                  "* Chart Preferences - set default filters and chart types\n"
                  "* Refactor of code for better image management\n"
                  "* Auto Capialize Watch Names\n"
                  "* Help text improvements for watch wear history view\n"
                  "* Improved placement of image picker (Gallery/Camera) option\n"
                  "* Added 'review app' prompt\n"
                      "--- \n\n"


              "### Version 1.2.0 \n"
                  "\n"

                  "* Implemented ads (Pro version coming soon!)\n"
                  "* Save and share screenshots of wear charts\n"
                  "* Enhancements to daily reminders\n"
                  "* Minor bug fixes and improvements\n\n"

              "### Version 1.1.0 \n"
                  "\n"

                  "* See what's new when the app updates\n"
                  "* Backup & Restore the watch database\n"
                  "* Set up daily wear reminders\n"
                  "* Reference number field added to watch model\n"
                  "* Minor bug fixes and improvements"
                      "--- \n\n"

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