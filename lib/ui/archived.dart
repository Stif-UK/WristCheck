import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/view_watch.dart';
import 'package:wristcheck/model/watches.dart';

class Archived extends StatelessWidget {
  Archived({Key? key}) : super(key: key);

  var watchBox = Boxes.getWatches();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Archived Watches"),
        actions: [
          IconButton(
              icon: const Icon(Icons.help_outline),
            onPressed: (){} )
        ],

      ),
        body: ValueListenableBuilder<Box<Watches>>(
            valueListenable: watchBox.listenable(),
            builder: (context, box, _){
              List<Watches> wishList = Boxes.getArchivedWatches();



              return wishList.isEmpty?Container(
                alignment: Alignment.center,
                child: const Text("Your Archive is currently empty",
                  textAlign: TextAlign.center,),
              ):

              ListView.separated(
                itemCount: wishList.length,
                itemBuilder: (BuildContext context, int index){
                  var watch = wishList.elementAt(index);
                  String? _title = "${watch.manufacturer} ${watch.model}";
                  String? _status = "${watch.status}";


                  return ListTile(
                    leading: const Icon(Icons.watch),
                    title: Text(_title),
                    subtitle: Text(_status),
                    onTap: () => Get.to(() => ViewWatch(currentWatch: watch,)),
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
