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
          Text("Favourite: ${currentWatch.favourite}"),
          SizedBox(height: 10),
          currentWatch.serialNumber != null? Text("Serial Number: ${currentWatch.serialNumber}") : Text("Serial Number: Not provided"),
          SizedBox(height: 10),
          Text("Status: ${currentWatch.status}"),
          SizedBox(height: 10),
          currentWatch.purchaseDate != null? Text("Purchased: ${DateFormat.yMMMd().format(currentWatch.purchaseDate!)}"): Text("Purchase Date: Not Recorded"),
          SizedBox(height: 10),
          currentWatch.lastServicedDate != null? Text("Last Serviced: ${DateFormat.yMMMd().format(currentWatch.lastServicedDate!)}"): Text("Last serviced: N/A"),
          SizedBox(height: 10),
          currentWatch.serviceInterval != 0? Text("Service every ${currentWatch.serviceInterval} years") : Text("Service interval not recorded"),
          SizedBox(height: 10),
          currentWatch.nextServiceDue != null? Text("Next service date: ${DateFormat.yMMMd().format(currentWatch.nextServiceDue!)}"): Text("Next Service date: N/A"),
          SizedBox(height: 10),
          currentWatch.notes != null? Text("Notes: \n${currentWatch.notes}") : Text("Notes:")






        ],
      ),)
    );
  }
}
