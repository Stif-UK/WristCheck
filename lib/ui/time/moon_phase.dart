import 'package:flutter/material.dart';

class MoonPhaseWidget extends StatelessWidget {
  const MoonPhaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Moon Phase", style: Theme.of(context).textTheme.headlineMedium,)
      ],
    );
  }
}
