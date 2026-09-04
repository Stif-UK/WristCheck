import 'package:get/get.dart';
import 'package:wristcheck/l10n/app_localizations.dart';

class ValueDataHelpDialogs{

  static getCurrentCollectionCostHelp(){
    Get.defaultDialog(
      title: AppLocalizations.of(Get.context!)!.currentCollectionCostHelpTitle,
      barrierDismissible: true,
      middleText: AppLocalizations.of(Get.context!)!.currentCollectionCostHelpText,
    );
  }

  static getTotalCollectionSpendHelp(){
    Get.defaultDialog(
      title: AppLocalizations.of(Get.context!)!.totalCollectionSpendHelpTitle,
      barrierDismissible: true,
      middleText: AppLocalizations.of(Get.context!)!.totalCollectionSpendHelpText,
    );
  }

  static getTotalSoldValueHelp(){
    Get.defaultDialog(
      title: AppLocalizations.of(Get.context!)!.totalSoldValueHelpTitle,
      barrierDismissible: true,
      middleText: AppLocalizations.of(Get.context!)!.totalSoldValueHelpText,
    );
  }

  static getAverageResaleHelp(){
    Get.defaultDialog(
      title: AppLocalizations.of(Get.context!)!.averageResaleHelpTitle,
      barrierDismissible: true,
      middleText: AppLocalizations.of(Get.context!)!.averageResaleHelpText,
    );
  }

}