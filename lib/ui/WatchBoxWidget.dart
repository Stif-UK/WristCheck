import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';



class WatchBoxWidget extends StatefulWidget {
  const WatchBoxWidget({Key? key}) : super(key: key);


  @override
  State<WatchBoxWidget> createState() => _WatchBoxWidgetState();
}

class _WatchBoxWidgetState extends State<WatchBoxWidget> {

  final watchBox = Boxes.getWatches();
  // final watchBox = Hive.box<Map>("WatchBox");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<Box<Watches>>(valueListenable: watchBox.listenable(),
          builder: (context, box, _){

        return watchBox.isEmpty?Container(
          alignment: Alignment.center,
          child: Text("Your watch-box is currently empty\n\nPress the red button to add watches to your collection\n",
            textAlign: TextAlign.center,),
        ):

         ListView.separated(
            itemCount: watchBox.length,
            itemBuilder: (BuildContext context, int index){
              var watch = watchBox.getAt(index);
              String? _title = "${watch?.manufacturer} ${watch?.model}";
              bool fav = watch?.favourite ?? false;


              return ListTile(
                leading: Icon(Icons.watch),
                title: Text("$_title"),
                trailing:  fav? Icon(Icons.star): Icon(Icons.star_border)
              );
            },
          separatorBuilder: (context, index){
              return Divider();
          },
            );
          }


      )
      
      
      
      // Container(
      //   alignment: Alignment.center,
      //   child: Text("The Watchbox is not empty! Yay!",
      //     textAlign: TextAlign.center,),
      // )

          
    );

  }

}
