import 'package:flutter/material.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/view_watch_helper.dart';
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
  bool canEditSerialNo = false;
  bool canEditNotes = false;
  final GlobalKey<FormState> _editKey = GlobalKey<FormState>();


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
        padding: const EdgeInsets.all(10.0),
        //margin: const EdgeInsets.all(10.0),
        child: Form(
          key: _editKey,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFavouriteRow(widget.currentWatch),
            const Text("Serial Number:"),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 8,
                  child: TextFormField(
                    initialValue: widget.currentWatch.serialNumber,
                    enabled: canEditSerialNo,
                    onSaved: (String? value){
                      value != null? serialNo = value : serialNo = "Not Provided";
                    } ,
                        //() => widget.currentWatch.serialNumber = ,
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
                        child: ViewWatchHelper.getEditIcon(canEditSerialNo),
                      onTap: () => setState(() {
                        //if the field isn't empty, trigger it's save() method which sets the instance variable serialNo
                        _editKey.currentState != null? _editKey.currentState!.save(): print("state is null");
                        //if save is hit, we then trigger the update on the database only if it has changed
                        if(canEditSerialNo && widget.currentWatch.serialNumber != serialNo) {
                          print("updating serial number");
                          widget.currentWatch.serialNumber = serialNo;
                          widget.currentWatch.save();
                        }
                        canEditSerialNo = !canEditSerialNo;
                      })
                    )
                )
              ],
            ),
            // const SizedBox(height: 10),
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
            widget.currentWatch.notes != null? Text("Notes: \n${widget.currentWatch.notes}") : const Text("Notes:"),
            const SizedBox(height: 10),
            const Text("Notes:"),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 8,
                  child: TextFormField(
                    initialValue: widget.currentWatch.serialNumber,
                    enabled: canEditSerialNo,
                    onSaved: (String? value){
                      value != null? serialNo = value : serialNo = "Not Provided";
                    } ,
                    //() => widget.currentWatch.serialNumber = ,
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
                        child: ViewWatchHelper.getEditIcon(canEditSerialNo),
                        onTap: () => setState(() {
                          //if the field isn't empty, trigger it's save() method which sets the instance variable serialNo
                          _editKey.currentState != null? _editKey.currentState!.save(): print("state is null");
                          //if save is hit, we then trigger the update on the database only if it has changed
                          if(canEditSerialNo && widget.currentWatch.serialNumber != serialNo) {
                            print("updating serial number");
                            widget.currentWatch.serialNumber = serialNo;
                            widget.currentWatch.save();
                          }
                          canEditSerialNo = !canEditSerialNo;
                        })
                    )
                )
              ],
            ),

          ],
      ),
        ),)
    );
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
