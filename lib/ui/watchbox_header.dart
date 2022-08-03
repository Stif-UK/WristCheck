import 'package:flutter/material.dart';

class WatchBoxHeader extends StatefulWidget {
  const WatchBoxHeader({Key? key}) : super(key: key);

  @override
  State<WatchBoxHeader> createState() => _WatchBoxHeaderState();
}

class _WatchBoxHeaderState extends State<WatchBoxHeader> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Filter"),
      leading: Icon(Icons.filter_alt),
      children:[
        ListTile(
          title: Text("Clear filters"),
          trailing: Icon(Icons.filter_alt_off),
          onTap: (){},
        ),
        ListTile(
          title: Text("Show Wishlist"),
          trailing: Icon(Icons.cake_outlined),
          onTap:(){}
        ),
        ListTile(
            title: Text("Show Sold"),
            trailing: Icon(Icons.attach_money),
            onTap:(){}
        )
      ]
    );
  }
}

