import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AccuracyHelpBottomsheet extends StatelessWidget {
  const AccuracyHelpBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white38,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
        ),
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(15),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            //Header#
              Row(
                children: [
                  Expanded(child: Text("Watch Accuracy", style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,)),
                  IconButton(icon: Icon(FontAwesomeIcons.x),
                  onPressed: Get.back,)
                ],
              ),
              const Divider(thickness: 2,),

            ]),);

  }
}
