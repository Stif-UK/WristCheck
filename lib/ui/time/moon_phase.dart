import 'package:flutter/material.dart';
import 'package:moon_phase_plus/moon_phase_plus.dart';

class MoonPhaseWidget extends StatelessWidget {
  const MoonPhaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text("Current Moon Phase", style: Theme.of(context).textTheme.headlineSmall,),
        ),
        Row(
          children: [
            SizedBox(width: 137.5,),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: MoonWidget(date: DateTime.now(),
              size: 150,
              resolution: 150,),
            ),
          ],
        )
      ],
    );
  }
}
