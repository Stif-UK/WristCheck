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
          physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            data:
            "Track your watches accuracy by creating checkpoints - "
                "WristTrack can then compare the change in the time on your watch"
                " to the change in time from the atomic clock and calculate if it is gaining or losing time\n\n"
                "**Baselines**\n\n"
                "When you set a checkpoint as a baseline, all following measurements"
                " will be compared to it. You should set a new baseline any time you have manually adjusted your watch since the last baseline.\n\n"
                "If you have no records saved, the first result is always tagged as a baseline record.\n\n"
                "**Capturing a Measurement**\n\n"
                "To capture a data point, set the time value under 'add checkpoint' "
                "to match your watch is going to be (it defaults to a minute ahead) and then press the '00 seconds' button when the seconds hand reaches twelve o'clock. "
                "Alternatively, set the time to match your watch and use the '15/30/45 seconds' buttons when the seconds hand passes those to capture the timestamp.\n\n "
                "The times captured will then appear in the 'Records' section below, along with an accuracy calculated since the last baseline record (no accuracy value shows for baselines).\n\n"
                "**Deleting a Record**\n\n"
                "If you capture a record in error, it can be deleted by swiping it away from right to left in the 'Records' list.\n\n"
                "**When to capture records**\n\n"
                "The longer you track the watch from the baseline measurement, the more accurate the results are likely to be "
                "(as the small delays when pressing buttons become less prominent). As a guide, it's useful to leave 12-24 hours between measurements.\n\n"
                "_*You can re-open this information box at any time by pressing the question mark in the top right of the page*_\n\n "

        ),
      ),
    );
  }

}