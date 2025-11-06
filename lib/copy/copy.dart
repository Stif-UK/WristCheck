import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class WristCheckCopy {


  static Widget getAlternativeExtractsCopy() {
    return Container(
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Markdown(
            shrinkWrap: true,
            data: "**Alternative Data Extracts**\n\n"
                "These options allow your watch and wear data to be extracted from **WristTrack**\n\n"
                "They are meant to free your data, rather than as a backup _(see the Backup/Restore options if you are simply looking to move data from one device to another)._\n\n"
                "The simple extract provides a list of all watch data, including wear count and notes **(one row per watch)**\n\n"
                "The detailed extract provides a line of data for each **tracked wear date** and only includes watches which have been tracked as worn.**(multiple rows per watch)**\n\n"
                "This raw data is output in CSV format, allowing easy import into your favourite spreadsheet application."
        ),
      ),
    );
  }

  static Widget getWatchWearChartsUpgradeCopy() {
    return Container(
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Markdown(
            shrinkWrap: true,
            data: "**Watch Wear Charts**\n\n"
                "Watch charts are a **WristTrack Pro** feature.\n\n"
                "They allow you to view charts breaking down which months and days this watch has been worn.\n\n"
                "Want to know more about **WristTrack Pro**? Click the button below..."
        ),
      ),
    );
  }

  static Widget getEmptyWearListWatchChartsCopy() {
    return Container(
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Markdown(
            shrinkWrap: true,
            data:
                "You haven't tracked any wear dates for this watch yet.\n\n"
                "Track data by clicking 'wear today' on the watch page, or add dates via the calendar view. \n\n"
                    "Once tracked charts will show here breaking down your records by month and weekday."
        ),
      ),
    );
  }

  static Widget getAccuracyHelpCopy(){
    return Container(
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Markdown(
            shrinkWrap: true,
            data:
            "Track your watches accuracy by creating checkpoints - "
                "WristTrack can then compare the change in the time on your watch,"
                " to the change in time from the atomic clock and calculate if it is gaining or losing time\n\n"
                "**Baselines**\n\n"
                "When you set a checkpoint as a baseline, all following measurements"
                " will be compared to it. You should set a new baseline any time you have manually adjusted your watch since the last baseline."
                "If you have no records saved, the first result is always tagged as a baseline record.\n\n"
                "**Capturing a measurement**\n\n"
                "lorem ipsum"
        ),
      ),
    );
  }

}