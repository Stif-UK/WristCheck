import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:get/get.dart';

class WristCheckCopy {


  static Widget getAlternativeExtractsCopy() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Markdown(
            shrinkWrap: true,
            data: AppLocalizations.of(Get.context!)!.altExtractsGuidance
        ),
      ),
    );
  }

  static Widget getWatchWearChartsUpgradeCopy() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Markdown(
            shrinkWrap: true,
            data: AppLocalizations.of(Get.context!)!.watchChartsUpgradeCopy
        ),
      ),
    );
  }

  static Widget getEmptyWearListWatchChartsCopy() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Markdown(
            shrinkWrap: true,
            data: AppLocalizations.of(Get.context!)!.emptyWearListWatchCharts
        ),
      ),
    );
  }

  static Widget getAccuracyHelpCopy(){
    return Container(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Markdown(
          physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            data: "${AppLocalizations.of(Get.context!)!.accuracyHelpTextIntro}"
                "${AppLocalizations.of(Get.context!)!.accuracyHelpTextBaselines}"
                "${AppLocalizations.of(Get.context!)!.accuracyHelpTextAddAMeasurement}"
                "${AppLocalizations.of(Get.context!)!.accuracyHelpTextDeletingARecord}"
                "${AppLocalizations.of(Get.context!)!.accuracyHelpTextWhenToCapture}"
                "${AppLocalizations.of(Get.context!)!.accuracyHelpTextOutro}"
        ),
      ),
    );
  }

}