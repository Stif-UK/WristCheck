import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/time_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/moonphase_methods.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';


class MoonPhaseWidget extends StatelessWidget {
  MoonPhaseWidget({super.key});
  final timeController = Get.find<TimeController>();

  @override
  Widget build(BuildContext context) {
    final upcomingPhases = MoonPhaseMethods.getUpcomingMoonPhases(DateTime.now(), context);

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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              MoonPhaseMethods.getMoonPhaseText(DateTime.now(), context),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(width: 6.0),
            Text(
              '(${MoonPhaseMethods.getMoonPhasePercentage(DateTime.now()).toStringAsFixed(1)}%)',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ExpansionTile(
            title: Text(
              'More Info',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            children: [
              ...upcomingPhases.map((phase) {
                return ListTile(
                  leading: Obx(() => MoonPhaseMethods.buildMoonWidget(
                        phase.date,
                        36,
                        detailedMoon: timeController.realisticMoon.value,
                      )),
                  title: Text(
                    phase.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    WristCheckFormatter.getFormattedDateWithDay(phase.date),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }),
              const SizedBox(height: 80.0),
            ],
          ),
        ),
      ],
    );
  }
}
