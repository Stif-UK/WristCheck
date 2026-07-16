import 'package:flutter/material.dart';

class WristRecapBottomsheet extends StatelessWidget {
  const WristRecapBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white38,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
        ),
        height: MediaQuery.of(context).size.height*0.85,
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Wrist Recap Settings", style: Theme.of(context).textTheme.headlineSmall,),
            const Divider(thickness: 2,),
            ],
            )
        );
        }

}
