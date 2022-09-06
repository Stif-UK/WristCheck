import 'package:flutter/material.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:wristcheck/copy/snackbars.dart';
import 'package:wristcheck/model/watch_methods.dart';

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
bool _locked = true;

  @override
  Widget build(BuildContext context) {
    var wearList = widget.currentWatch.wearList;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.currentWatch.manufacturer} ${widget.currentWatch.model}"),
        actions:  [
          //Show lock icon - page cannot be edited if locked (default state)
          InkWell(child: _locked? const Icon(Icons.lock) :  const Icon(Icons.lock_open),
          onTap: (){
            setState(() {
            _locked = !_locked;
            });
            },),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
                child: const Icon(Icons.add,),
            //If page is 'locked' the 'add' button does nothing
            onTap: _locked? null: () async {
                  DateTime? historicDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100));
                  //if cancelled then date == null
                  if(historicDate == null) return;
                  WatchMethods.attemptToRecordWear(widget.currentWatch, historicDate, false);

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
            //If page is locked then dates cannot be dismissed, else require a right to left swipe
            direction: _locked? DismissDirection.none : DismissDirection.endToStart,

            onDismissed: (direction) {
              setState(() {
                wearList.removeAt(index);
                widget.currentWatch.save();
                // Then show a snackbar.
                WristCheckSnackBars.removeWearSnackbar(widget.currentWatch, date);
              });

            },
            // Show a red background as the item is swiped away.
            background: Container(
              alignment: Alignment.center,color: Colors.red,
            child: const Text("Deleting"),),
            child: ListTile(
              leading: const Icon(Icons.calendar_today_outlined),
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
