import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/view_watch.dart';
import 'package:wristcheck/model/watches.dart';

class SoldView extends StatelessWidget {
  SoldView({Key? key}) : super(key: key);

  var watchBox = Boxes.getWatches();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sold Watches"),

      ),
        body: ValueListenableBuilder<Box<Watches>>(
            valueListenable: watchBox.listenable(),
            builder: (context, box, _){
              List<Watches> soldList = Boxes.getSoldWatches();



              return soldList.isEmpty?Container(
                alignment: Alignment.center,
                child: const Text("No sold watches tracked\n \n Mark watches as 'sold' to populate this list",
                  textAlign: TextAlign.center,),
              ):

              ListView.separated(
                itemCount: soldList.length,
                itemBuilder: (BuildContext context, int index){
                  var watch = soldList.elementAt(index);
                  String? _title = "${watch.manufacturer} ${watch.model}";
                  bool fav = watch.favourite; // ?? false;
                  String? _status = "${watch.status}";


                  return ListTile(
                    leading: const Icon(Icons.watch),
                    title: Text(_title),
                    subtitle: Text(_status),
                    onTap: () => Get.to(ViewWatch(currentWatch: watch,)),
                  );
                },
                separatorBuilder: (context, index){
                  return const Divider();
                },
              );
            }


        )
    );
  }
}
