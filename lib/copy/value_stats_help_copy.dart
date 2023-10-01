import 'package:get/get.dart';

class ValueDataHelpDialogs{

  static getCurrentCollectionCostHelp(){
    Get.defaultDialog(
      title: "Current Collection Cost",
      barrierDismissible: true,
      middleText: "This value is the sum of all recorded purchase prices of all watches currently marked as 'In Collection' ",
    );
  }

  static getTotalCollectionSpendHelp(){
    Get.defaultDialog(
      title: "Total Collection Spend",
      barrierDismissible: true,
      middleText: "This value is the sum of all recorded purchase prices of all watches marked as either 'In Collection' or 'Sold'",
    );
  }

  static getTotalSoldValueHelp(){
    Get.defaultDialog(
      title: "Total Sold Value",
      barrierDismissible: true,
      middleText: "This value is the sum of all recorded sale prices of all watches with a status of 'Sold'",
    );
  }

  static getAverageResaleHelp(){
    Get.defaultDialog(
      title: "Average Resale Percentage",
      barrierDismissible: true,
      middleText: "This value is the average percentage returned when selling a watch - it is only calculated for watches with status 'Sold' which have both a purchase and sale price tracked.\n\n"
          "The percentage is calculated using total sale value divided by total purchase cost.",
    );
  }

}