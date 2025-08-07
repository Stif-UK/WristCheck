import 'package:flutter/material.dart';
import 'package:wristcheck/model/watches.dart';

class ImageUpdateBottomsheet extends StatelessWidget {
  ImageUpdateBottomsheet({super.key, required this.index, required this.watch});
  final int index;
  final Watches watch;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white38,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15),
      ),
      height: MediaQuery.of(context).size.height*0.4,
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Header#


          Row(
            children: [
              Expanded(
                child: Text("Update Image ${index + 1} for ${watch.toString()}",
                  style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,),
              ),

            ],
          ),
          const SizedBox(height: 20,),
          Text("Test"),

        ],
      ),

    );
  }
}
