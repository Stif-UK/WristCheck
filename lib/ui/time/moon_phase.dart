import 'package:flutter/material.dart';
import 'package:moon_phase_plus/moon_phase_plus.dart';

class MoonPhaseWidget extends StatelessWidget {
  const MoonPhaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,

      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text("Current Moon Phase", style: Theme.of(context).textTheme.headlineSmall,),
        ),
        SizedBox(height: 10,),
        MoonWidget(date: DateTime.now(),
        size: 100,
        resolution: 150,)
      ],
    );
  }
}
