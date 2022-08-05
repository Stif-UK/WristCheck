import 'package:flutter/material.dart';
import 'package:wristcheck/controllers/filter_controller.dart';
import 'package:get/get.dart';

class WatchBoxHeader extends StatefulWidget {
  const WatchBoxHeader({Key? key}) : super(key: key);

  @override
  State<WatchBoxHeader> createState() => _WatchBoxHeaderState();
}

final FilterController filterController = Get.put(FilterController());

class _WatchBoxHeaderState extends State<WatchBoxHeader> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Obx(() => Text("Filter: ${filterController.filterName}")),
      leading: Icon(Icons.filter_alt),
      children:[
        ListTile(
          title: Text("Clear filters"),
          trailing: Icon(Icons.filter_alt_off),
          onTap: (){
            filterController.updateFilterName("Show All");

          },
        ),
        ListTile(
            title: Text("Show Collection"),
            trailing: Icon(Icons.watch),
            onTap:(){
              filterController.updateFilterName("In Collection");
            }
        ),
        ListTile(
          title: Text("Show Wishlist"),
          trailing: Icon(Icons.cake_outlined),
          onTap:(){
            filterController.updateFilterName("Wishlist");
          }
        ),
        ListTile(
            title: Text("Show Sold"),
            trailing: Icon(Icons.attach_money),
            onTap:(){
              filterController.updateFilterName("Sold");
            }
        )
      ]
    );
  }
}

