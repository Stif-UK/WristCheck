import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ViewOptions extends StatefulWidget {

  @override
  State<ViewOptions> createState() => _ViewOptionsState();
}

class _ViewOptionsState extends State<ViewOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Options"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ExpansionTile(
              leading: Icon(Icons.watch),
              title: Text("WatchBox Display"),
            )
          ],
        ),
      ),
    );
  }
}
