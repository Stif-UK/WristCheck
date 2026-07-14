import 'package:flutter/material.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/moonphase_methods.dart';


class MoonPhaseWidget extends StatelessWidget {
  const MoonPhaseWidget({super.key});

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
              child: MoonPhaseMethods.buildMoonWidget(DateTime.now(), 150),
            ),
          ],
        )
      ],
    );
  }
}
