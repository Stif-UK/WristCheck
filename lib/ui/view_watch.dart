import 'package:flutter/material.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:intl/intl.dart';

class ViewWatch extends StatefulWidget {
  //const ViewWatch({Key? key}) : super(key: key);

  final Watches currentWatch;

  ViewWatch({
    required this.currentWatch});

  @override
  State<ViewWatch> createState() => _ViewWatchState();
}

class _ViewWatchState extends State<ViewWatch> {
  String serialNo = "Not Provided";
  bool editSerial = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.currentWatch.manufacturer} ${widget.currentWatch.model}"),
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
          const SizedBox(height: 10),
          _buildFavouriteRow(widget.currentWatch),
          const SizedBox(height: 10),
          const Text("Serial Number:"),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
              Expanded(
                flex: 8,
                child: TextFormField(
                  initialValue: widget.currentWatch.serialNumber,
                  enabled: editSerial,
                  decoration: InputDecoration(
                    // label: Text("Serial Number:"),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).disabledColor,
                      )
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red
                        )
                    )
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                  child:  InkWell(
                      child: getEditIcon(editSerial),
                    onTap: () => setState(() {
                      editSerial = !editSerial;
                    })
                  )
              )
            ],
          ),
          // const SizedBox(height: 10),
          // Text("Serial Number: ${widget.currentWatch.serialNumber}"),
          const SizedBox(height: 10),
          Text("Status: ${widget.currentWatch.status}"),
          const SizedBox(height: 10),
          widget.currentWatch.purchaseDate != null? Text("Purchased: ${DateFormat.yMMMd().format(widget.currentWatch.purchaseDate!)}"): const Text("Purchase Date: Not Recorded"),
          const SizedBox(height: 10),
          widget.currentWatch.lastServicedDate != null? Text("Last Serviced: ${DateFormat.yMMMd().format(widget.currentWatch.lastServicedDate!)}"): const Text("Last serviced: N/A"),
          const SizedBox(height: 10),
          widget.currentWatch.serviceInterval != 0? Text("Service every ${widget.currentWatch.serviceInterval} years") : const Text("Service interval not recorded"),
          const SizedBox(height: 10),
          widget.currentWatch.nextServiceDue != null? Text("Next service date: ${DateFormat.yMMMd().format(widget.currentWatch.nextServiceDue!)}"): const Text("Next Service date: N/A"),
          const SizedBox(height: 10),
          widget.currentWatch.notes != null? Text("Notes: \n${widget.currentWatch.notes}") : const Text("Notes:")






        ],
      ),)
    );
  }

  String getSerialNumberToDisplay(Watches watch){
    return watch.serialNumber != null || watch.serialNumber == "" ? "Serial Number: ${widget.currentWatch.serialNumber}" : "Serial Number: Not provided";

  }

  Icon getEditIcon(bool editable){
    return !editable ? const Icon(Icons.edit) : const Icon(Icons.save);

  }

  //Favourite selector toggle
  Widget _buildFavouriteRow(Watches watch){
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("Favourite:"),

          Switch(
              value: watch.favourite,
              onChanged: (value){
                setState(
                        (){
                      watch.favourite = value;
                      watch.save();
                    }
                );
              }),
        ]

    );
  }
}
