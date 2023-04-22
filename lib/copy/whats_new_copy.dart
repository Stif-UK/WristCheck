import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/material.dart';

class WhatsNewCopy{

  static String getLatestVersionCopy(){
    return
        "### Version 1.4.0 \n"
        "\n"

        "* WristCheck Pro is here - 'Pay what you like' to remove ads"
            " - See Sidebar > Remove Ads for more details\n\n"
            "* More options for how charts display - see chart settings\n"
            "* Tidy up of app sidebar\n"
            "* Bug fixes";
  }


  static Widget getVersionHistory(BuildContext context){
    return  Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const Markdown(
          physics: ClampingScrollPhysics(),
            data:
            "### Version 1.4 \n"
                "\n"

                "* WristCheck Pro added!\n"
                "* Remove Ads with an in-app purchase\n\n"
                "* Pick chart default order options\n\n"
                "* Bug fix related to saving images with special characters in the watch name"
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
                "\n\n"

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
                "\n\n"

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