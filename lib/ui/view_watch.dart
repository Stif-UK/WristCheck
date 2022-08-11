import 'package:flutter/material.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:intl/intl.dart';

class ViewWatch extends StatelessWidget {
  //const ViewWatch({Key? key}) : super(key: key);

  final Watches currentWatch;
  ViewWatch({
    required this.currentWatch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${currentWatch.manufacturer} ${currentWatch.model}"),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(20.0),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Manufacturer: ${currentWatch.manufacturer}"),
          SizedBox(height: 10),
          Text("Model: ${currentWatch.model}"),
          SizedBox(height: 10),
          Text("Serial Number: ${currentWatch.serialNumber}"),
          SizedBox(height: 10),
          Text("Status: ${currentWatch.status}"),
          SizedBox(height: 10),
          currentWatch.purchaseDate != null? Text("Purchase Date: ${DateFormat.yMMMd().format(currentWatch.purchaseDate!)}"): Text("Purchase Date: Not Recorded")




        ],
      ),)
    );
  }
}
