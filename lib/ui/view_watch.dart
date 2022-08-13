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
        actions: const [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.edit),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.all(20.0),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Manufacturer: ${currentWatch.manufacturer}"),
          const SizedBox(height: 10),
          Text("Model: ${currentWatch.model}"),
          const SizedBox(height: 10),
          Text("Favourite: ${currentWatch.favourite}"),
          const SizedBox(height: 10),
          currentWatch.serialNumber != null? Text("Serial Number: ${currentWatch.serialNumber}") : const Text("Serial Number: Not provided"),
          const SizedBox(height: 10),
          Text("Status: ${currentWatch.status}"),
          const SizedBox(height: 10),
          currentWatch.purchaseDate != null? Text("Purchased: ${DateFormat.yMMMd().format(currentWatch.purchaseDate!)}"): const Text("Purchase Date: Not Recorded"),
          const SizedBox(height: 10),
          currentWatch.lastServicedDate != null? Text("Last Serviced: ${DateFormat.yMMMd().format(currentWatch.lastServicedDate!)}"): const Text("Last serviced: N/A"),
          const SizedBox(height: 10),
          currentWatch.serviceInterval != 0? Text("Service every ${currentWatch.serviceInterval} years") : const Text("Service interval not recorded"),
          const SizedBox(height: 10),
          currentWatch.nextServiceDue != null? Text("Next service date: ${DateFormat.yMMMd().format(currentWatch.nextServiceDue!)}"): const Text("Next Service date: N/A"),
          const SizedBox(height: 10),
          currentWatch.notes != null? Text("Notes: \n${currentWatch.notes}") : const Text("Notes:")






        ],
      ),)
    );
  }
}
