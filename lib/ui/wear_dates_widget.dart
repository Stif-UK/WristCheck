import 'package:flutter/material.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:wristcheck/copy/snackbars.dart';

class WearDatesWidget extends StatefulWidget {
  // const WearDatesWidget({Key? key} ) : super(key: key);

  final Watches currentWatch;

  const WearDatesWidget({
    Key? key,
    required this.currentWatch});

  @override
  State<WearDatesWidget> createState() => _WearDatesWidgetState();
}

class _WearDatesWidgetState extends State<WearDatesWidget> {
  @override
  Widget build(BuildContext context) {
    var wearList = widget.currentWatch.wearList;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.currentWatch.manufacturer} ${widget.currentWatch.model}"),
        actions:  [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
                child: const Icon(Icons.add),
            onTap: () async {
                  DateTime? historicDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100));
                  //if cancelled then date == null
                  if(historicDate == null) return;
                  widget.currentWatch.wearList.add(historicDate);
                  widget.currentWatch.save();
                    setState(() {

                    });
                  },
            ),
          ),
        ],
      ),
      body: wearList.isNotEmpty? ListView.builder(
        itemCount: wearList.length,
        prototypeItem: ListTile(
          title: Text(wearList.first.toString()),
        ),
        itemBuilder: (context, index) {
          final item = wearList[index].toString();
          var date = wearList[index];
          return Dismissible(
            
            key: Key(item),
            onDismissed: (direction) {
              // Remove the item from the data source.
              setState(() {
                wearList.removeAt(index);
                widget.currentWatch.save();
              });

              // Then show a snackbar.
              //ToDo: Add snackbar on deletion of date
              WristCheckSnackBars.removeWearSnackbar(widget.currentWatch, date);

            },
            // Show a red background as the item is swiped away.
            background: Container(
              alignment: Alignment.center,color: Colors.red,
            child: const Text("Deleting"),),
            child: ListTile(
              leading: Icon(Icons.calendar_today_outlined),
              title: Text(WristCheckFormatter.getFormattedDate(wearList[index])),
            ),
          );
        },
      ):
      Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: const Text("No wear dates are tracked yet for this watch\n\nSelect the 'Wear this watch today' button on the watch info screen to add dates.\n",
          textAlign: TextAlign.center,),
      )
    );


      

  }
}
