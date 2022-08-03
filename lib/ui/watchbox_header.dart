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
      leading: Icon(Icons.filter_alt)
    );
  }
}

