import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/model/enums/rate_unit.dart';
import 'package:wristcheck/model/measurement.dart';
import 'package:wristcheck/model/measurement_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/Accuracy.dart';
import 'package:wristcheck/util/accuracty_helper.dart';

class AccuracyRow extends StatelessWidget {
  AccuracyRow({super.key,
     this.currentWatch});

  final watchViewController = Get.put(WatchViewController());
  final Watches? currentWatch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 8.0, 0, 8.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text("Accuracy:", style: Theme.of(context).textTheme.bodyLarge,)),
          Expanded(flex: 3, child: Text(_getAccuracyResult(), style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.start,)),
          ElevatedButton(
              child: Icon(FontAwesomeIcons.plus),
          onPressed: ()=> Get.to(()=> Accuracy(currentWatch: currentWatch!,)),)
        ],
      ),
    );
  }

  String _getAccuracyResult() {
    Measurement? latest;
    String returnText = "No records tracked";
    //Get latest accuracy record for the watch
    if(currentWatch!=null) {
      latest = MeasurementMethods.getLatestMeasurementForWatch(currentWatch!);
    };
    if(latest != null){
      //TODO: Handle case where rawAccuracy is null to prevent getScaledRate failing
      //TODO: Add units text
      returnText = latest.baseLine? "Measurement in progress..." : _getRateText(latest, RateUnit.day);
    };

    return returnText;
  }

  String _getRateText(Measurement latest, RateUnit suffix) {

    String rate = "No rate found";
    String prefix = "";
    if(latest.rawAccuracy != null){
      rate = AccuracyHelper.getScaledRate(latest.rawAccuracy!, suffix).toStringAsFixed(1);
      if(latest.rawAccuracy! >= 0) prefix = "+";
    }


    String units = "seconds/${suffix.name}";
    return "$prefix$rate $units";
  }
}
