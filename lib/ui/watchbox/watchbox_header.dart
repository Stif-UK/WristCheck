import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/wishlist.dart';
import 'package:wristcheck/ui/sold.dart';
import 'package:wristcheck/ui/favourites.dart';
import 'package:wristcheck/ui/search_widget.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/ui/view_watch.dart';
import 'dart:math';


class WatchBoxHeader extends StatefulWidget {
  const WatchBoxHeader({Key? key}) : super(key: key);

  @override
  State<WatchBoxHeader> createState() => _WatchBoxHeaderState();
}

class _WatchBoxHeaderState extends State<WatchBoxHeader> {

  final watchList = Boxes.getCollectionWatches(false);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text("Filters & Search"),
      leading: const Icon(Icons.filter_alt),
      children:[
        ListTile(
            title: const Text("Search Collection"),
            trailing: const Icon(Icons.search),
            onTap:() {
    showSearch(
    context: context,
    delegate: SearchWidget(),
    );
    },
        ),
        ListTile(
            title: const Text("Random Watch"),
            trailing: const Icon(Icons.lightbulb_outline),
            onTap:(){
              //get size of collection
              var collectionSize = watchList.length;
              //generate a random number in that range
              Random ran = Random();
              int randomNo = ran.nextInt(collectionSize);
              Get.to(() => ViewWatch(currentWatch: watchList[randomNo]));
            }
        ),

        ListTile(
            title: const Text("Show Favourites"),
            trailing: const Icon(Icons.star),
            onTap:(){
              Get.to(() => Favourites());
            }
        ),
        ListTile(
          title: const Text("Show Wishlist"),
          trailing: const Icon(Icons.cake_outlined),
          onTap:(){
            Get.to(() => Wishlist());
          }
        ),
        ListTile(
            title: const Text("Show Sold"),
            trailing: const Icon(Icons.attach_money),
            onTap:(){
              Get.to(() => SoldView());
            }
        )
      ]
    );
  }
}

