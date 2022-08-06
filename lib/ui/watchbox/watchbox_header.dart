import 'package:flutter/material.dart';
import 'package:wristcheck/controllers/filter_controller.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/wishlist.dart';
import 'package:wristcheck/ui/sold.dart';

class WatchBoxHeader extends StatefulWidget {
  const WatchBoxHeader({Key? key}) : super(key: key);

  @override
  State<WatchBoxHeader> createState() => _WatchBoxHeaderState();
}

class _WatchBoxHeaderState extends State<WatchBoxHeader> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Additional Lists"),
      leading: Icon(Icons.filter_alt),
      children:[
        ListTile(
          title: Text("Show Wishlist"),
          trailing: Icon(Icons.cake_outlined),
          onTap:(){
            Get.to(Wishlist());
          }
        ),
        ListTile(
            title: Text("Show Sold"),
            trailing: Icon(Icons.attach_money),
            onTap:(){
              Get.to(SoldView());
            }
        )
      ]
    );
  }
}

