import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/time_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/moonphase_methods.dart';


class MoonPhaseWidget extends StatelessWidget {
  MoonPhaseWidget({super.key});
  final timeController = Get.find<TimeController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(AppLocalizations.of(context)!.moonPhase, style: Theme.of(context).textTheme.headlineSmall,),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Obx(() => MoonPhaseMethods.buildMoonWidget(
                    DateTime.now(),
                    150,
                    detailedMoon: timeController.realisticMoon.value,
                  )),
            ),
          ],
        ),
        Text(
          MoonPhaseMethods.getMoonPhaseText(DateTime.now(), context),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
