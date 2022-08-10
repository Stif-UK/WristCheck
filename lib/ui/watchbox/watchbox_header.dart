import 'package:flutter/material.dart';
import 'package:wristcheck/controllers/filter_controller.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/wishlist.dart';
import 'package:wristcheck/ui/sold.dart';
import 'package:wristcheck/ui/favourites.dart';
import 'package:wristcheck/ui/search_widget.dart';


class WatchBoxHeader extends StatefulWidget {
  const WatchBoxHeader({Key? key}) : super(key: key);

  @override
  State<WatchBoxHeader> createState() => _WatchBoxHeaderState();
}

class _WatchBoxHeaderState extends State<WatchBoxHeader> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Filters & Search"),
      leading: Icon(Icons.filter_alt),
      children:[
        ListTile(
            title: Text("Search Collection"),
            trailing: Icon(Icons.search),
            onTap:() {
    showSearch(
    context: context,
    delegate: SearchWidget(),
    );
    },
        ),
        ListTile(
            title: Text("Show Favourites"),
            trailing: Icon(Icons.star),
            onTap:(){
              Get.to(() => Favourites());
            }
        ),
        ListTile(
          title: Text("Show Wishlist"),
          trailing: Icon(Icons.cake_outlined),
          onTap:(){
            Get.to(() => Wishlist());
          }
        ),
        ListTile(
            title: Text("Show Sold"),
            trailing: Icon(Icons.attach_money),
            onTap:(){
              Get.to(() => SoldView());
            }
        )
      ]
    );
  }
}

