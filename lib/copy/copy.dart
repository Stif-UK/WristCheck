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
                "These options allow your watch and wear data to be extracted from **WristCheck**\n\n"
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
                "Watch charts are a **WristCheck Pro** feature.\n\n"
                "They allow you to view charts breaking down which months and days this watch has been worn.\n\n"
                "Want to know more abou **WristCheck Pro**? Click the button below..."
        ),
      ),
    );
  }

}