import 'package:flutter/material.dart';

class LocationOptions extends StatelessWidget {
  const LocationOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Localisation Options"),
        //TODO: Implement some help text
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Placeholder")
        ],
      ),
    );
  }
}
