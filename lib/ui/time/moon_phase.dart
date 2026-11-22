import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/time_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/moonphase_methods.dart';
import 'package:wristcheck/ui/widgets/wrist_track_bottom_nav_bar.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';


class MoonPhaseWidget extends StatelessWidget {
  MoonPhaseWidget({super.key, this.expandUpcomingPhases});

  final bool? expandUpcomingPhases;
  final timeController = Get.find<TimeController>();

  @override
  Widget build(BuildContext context) {
    final bool showAllPhasesInline =
        expandUpcomingPhases ?? WristTrackBottomNavBar.isLargeScreen(context);

    return Obx(() {
      final date = timeController.currentDateTime.value;
      final upcomingPhases = MoonPhaseMethods.getUpcomingMoonPhases(date, context);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              AppLocalizations.of(context)!.moonPhase,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: MoonPhaseMethods.buildMoonWidget(
                  date,
                  150,
                  detailedMoon: timeController.realisticMoon.value,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6.0,
              children: [
                Text(
                  MoonPhaseMethods.getMoonPhaseText(date, context),
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  '(${MoonPhaseMethods.getMoonPhasePercentage(date).toStringAsFixed(1)}%)',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '${MoonPhaseMethods.getDaysSinceLastNewMoon(date)} days since last new moon',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: showAllPhasesInline
                ? _buildInlineUpcomingPhases(context, upcomingPhases)
                : ExpansionTile(
                    title: Text(
                      AppLocalizations.of(context)!.upcomingPhases,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    children: [
                      ...upcomingPhases.map((phase) {
                        return ListTile(
                          leading: MoonPhaseMethods.buildMoonWidget(
                            phase.date,
                            36,
                            detailedMoon: timeController.realisticMoon.value,
                          ),
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
                    ],
                  ),
          ),
        ],
      );
    });
  }

  Widget _buildInlineUpcomingPhases(
    BuildContext context,
    List<UpcomingMoonPhase> upcomingPhases,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.upcomingPhases,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8.0),
        Center(
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: upcomingPhases.map((phase) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MoonPhaseMethods.buildMoonWidget(
                        phase.date,
                        36,
                        detailedMoon: timeController.realisticMoon.value,
                      ),
                      const SizedBox(width: 12.0),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              phase.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              WristCheckFormatter.getFormattedDateWithDay(phase.date),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
