import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/material.dart';

class WhatsNewCopy{

  static String getLatestVersionCopy(){
    return
        "### Version 1.12.1 \n"
        "\n"

            "* Added CHF and HUF currencies\n"
            "* Implemented Wrist Recap annual summary feature [BETA - please share feedback and suggestions!]\n"
            "* (Pro) Added ability to track watch dimension data\n"
            "* (Pro) Additional collection charts and wear chart filters as above\n"
            "* (Pro) Added Moon Phase info to time setting tab\n"
            "* v1.12.1: Bug fix for 'This Month' wear chart label bug\n"
            "* Additional Bug fixes & Improvements";

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
                      "### Version 1.12.1 \n"
                      "\n"

                      "* Added CHF and HUF currencies\n"
                      "* Implemented Wrist Recap annual summary feature [BETA]\n"
                      "* (Pro) Added ability to track watch dimension data\n"
                      "* (Pro) Additional collection charts and wear chart filters as above\n"
                      "* (Pro) Added Moon Phase info to time setting tab\n"
                      "* v1.12.1: Bug fix for 'This Month' wear chart label bug\n"
                      "* Updates to core libraries\n"
                      "* Updates to target latest OS versions\n"
                      "* Wear button now changes when watch worn that day\n"
                      "* Feedback email link added to sidebar\n"
                      "---\n\n"
                      "### Version 1.11 \n"
                      "\n"

                      "* New 'Retired' status added to tracking\n"
                      "* Ability to choose first day of week for calendar view added\n"
                      "* Can now filter wear charts 'since last purchase'\n"
                      "* Dark/Light theme can now be selected manually, in addition to system default\n"
                      "* (Pro) Improvements to the day and month watch charts\n"
                      "* Code refactor of watch pages and tabs to allow future expansion\n"
                      "* New UI for 'what's new' screen\n"
                      "* Watch Picker on calendar view now returns watches in same order as watch box view selection \n"
                      "---\n\n"


                      "### Version 1.10.3 \n"
                      "\n"

                      "* Default chart ordering now matches watchbox ordering\n"
                      "* Added Ability to delete wear info from the Calendar view\n"
                      "* Pro: New Cost Per Wear chart in Collection stats\n\n"
                      "* Bug fix: Watch charts and calendar links hidden for watches not in collections\n"
                      "* Bug fix: Warranty & Service view help text duplication issue bug fixed\n"
                      "* Improvement: In date list view, delete dates by swiping left\n"
                      "* Improvement: Updated Android Gradle build tooling versions and updated Firebase library versions"
                      "---\n\n"

                      "### Version 1.10.1 \n"
                      "\n"

                      "* New Time Setting page\n"
                      "* Added ability to pick which screen appears first in the app\n"
                      "* Update to RevenueCat SDK version to comply with latest platform billing standards\n"
                      "* Update to target OS versions in line with store policies\n"
                      "* Update to Flutter version and associated updates to app build config\n"
                      "* Further rebranding updates to correct text with old app title\n"
                      "* Bug fix - Add Watch button was not hiding when changing main tabs\n"
                      "---\n\n"

                      "### Version 1.9.1 \n"
                      "\n"

                      "* App rebranding from WristCheck to WristTrack\n"
                      "---\n\n"
                      "### Version 1.9.0 \n"
                      "\n"

                      "* Added CSV data extract options\n"
                      "* Calendar view added to each watch record\n"
                      "* (Pro) Ability to set a 2nd daily reminder\n"
                      "* (Pro) Watch weekday & month wear charts\n"
                      "---\n\n"
                      "### Version 1.8.0 \n"
                      "\n"

                      "* Added a new calendar view\n"
                      "* Added warranty expiry data point\n"
                      "* Updated servicing and warranty end date schedule\n"
                      "* Bug fix: Cost per wear now takes into account sold price\n"
                      "--- \n\n"
                      "### Version 1.7.2 \n"
                      "\n"

                      "* Implemented GDPR consent dialog for European users\n"
                      "* Setup configurable ad privacy options for all users\n"
                      "--- \n\n"
                      "### Version 1.7.1 \n"
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