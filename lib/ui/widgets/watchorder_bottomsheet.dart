import 'package:flutter/material.dart';


class WatchOrderBottomSheet extends StatefulWidget {
  const WatchOrderBottomSheet({Key? key}) : super(key: key);

  @override
  State<WatchOrderBottomSheet> createState() => _WatchOrderBottomSheetState();
}

class _WatchOrderBottomSheetState extends State<WatchOrderBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white38,
        shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
      ),
      height: MediaQuery.of(context).size.height*0.85,
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Header
          Text("Collection Display Order",
          style: Theme.of(context).textTheme.headlineSmall,),
        ],
      ),

    );
  }
}
