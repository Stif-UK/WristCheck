import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/view_watch.dart';
import 'package:wristcheck/model/watches.dart';

class Favourites extends StatelessWidget {
  Favourites({Key? key}) : super(key: key);

  var watchBox = Boxes.getWatches();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Favourites"),

        ),
        body: ValueListenableBuilder<Box<Watches>>(
            valueListenable: watchBox.listenable(),
            builder: (context, box, _){
              List<Watches> favourites = Boxes.getFavouriteWatches();



              return favourites.isEmpty?Container(
                alignment: Alignment.center,
                child: const Text("Your watchbox has no favourites\n \n Mark watches as favourite to display in this filter",
                  textAlign: TextAlign.center,),
              ):

              ListView.separated(
                itemCount: favourites.length,
                itemBuilder: (BuildContext context, int index){
                  var watch = favourites.elementAt(index);
                  String? _title = "${watch.manufacturer} ${watch.model}";
                  bool fav = watch.favourite; // ?? false;
                  String? _status = "${watch.status}";


                  return ListTile(
                    leading: Icon(Icons.watch),
                    title: Text("$_title"),
                    subtitle: Text("$_status"),
                    trailing:  fav? Icon(Icons.star): Icon(Icons.star_border),
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
