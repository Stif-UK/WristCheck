import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/controllers/accuracy_controller.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/accuracy_enums/rate_unit.dart';
import 'package:wristcheck/model/measurement.dart';
import 'package:wristcheck/model/measurement_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/Accuracy.dart';
import 'package:wristcheck/util/accuracty_helper.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class AccuracyRow extends StatelessWidget {
  AccuracyRow({super.key,
     this.currentWatch});

  final watchViewController = Get.put(WatchViewController());
  final accuracyController = Get.put(AccuracyController());
  final Watches? currentWatch;

  @override
  Widget build(BuildContext context) {
    //populate the required controller data
    accuracyController.updateLastMeasurement(MeasurementMethods.getLatestMeasurementForWatch(currentWatch!));
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 8.0, 0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: FittedBox(
            fit: BoxFit.scaleDown,
              child: Text(AppLocalizations.of(Get.context!)!.accuracyRowTitle, textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyLarge,))),
          Expanded(flex: 3, child: Obx(()=> Text(_getAccuracyResult(), style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.start,))),
          ElevatedButton(
              child: Icon(FontAwesomeIcons.plus),
          onPressed: ()=> Get.to(()=> Accuracy(currentWatch: currentWatch!,)),)
        ],
      ),
    );
  }

  //TODO: These two methods need to be tidied up into a single method to return the result text
  String _getAccuracyResult() {
    Measurement? latest;
    String returnText = AppLocalizations.of(Get.context!)!.noRecordsTracked;
    //Get latest accuracy record for the watch
    if(accuracyController.lastMeasurement.value != null){
      returnText = accuracyController.lastMeasurement.value?.baseLine == null ? AppLocalizations.of(Get.context!)!.measurementInProgress : _getRateText(accuracyController.lastMeasurement.value!, RateUnit.day);
    };

    return returnText;
  }

  String _getRateText(Measurement latest, RateUnit suffix) {

    if(latest.baseLine){
      return AppLocalizations.of(Get.context!)!.measurementInProgress;
    }
    String rate = AppLocalizations.of(Get.context!)!.noRateFound;
    String prefix = "";
    if(latest.rawAccuracy != null){
      rate = AccuracyHelper.getScaledRate(latest.rawAccuracy!, suffix).toStringAsFixed(1);
      if(latest.rawAccuracy! >= 0) prefix = "+";
    }


    String units = AppLocalizations.of(Get.context!)!.secondsPerUnit(WristCheckFormatter.getAccuracyPeriodText(suffix));
    return "$prefix$rate $units";
  }
}
