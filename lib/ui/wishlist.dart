import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/view_watch.dart';
import 'package:wristcheck/model/watches.dart';

class Wishlist extends StatelessWidget {
  Wishlist({Key? key}) : super(key: key);

  var watchBox = Boxes.getWatches();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wishlist"),

      ),
        body: ValueListenableBuilder<Box<Watches>>(
            valueListenable: watchBox.listenable(),
            builder: (context, box, _){
              List<Watches> wishList = Boxes.getWishlistWatches();



              return wishList.isEmpty?Container(
                alignment: Alignment.center,
                child: const Text("Your wishlist is currently empty\n \n Add watches to populate your wishlist",
                  textAlign: TextAlign.center,),
              ):

              ListView.separated(
                itemCount: wishList.length,
                itemBuilder: (BuildContext context, int index){
                  var watch = wishList.elementAt(index);
                  String? _title = "${watch.manufacturer} ${watch.model}";
                  bool fav = watch.favourite; // ?? false;
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
