import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/watch/watch_charts.dart';
import 'package:wristcheck/ui/wear_dates_widget.dart';
import 'package:wristcheck/util/view_watch_helper.dart';

class WearRow extends StatefulWidget {
  WearRow({super.key,
    required this.currentWatch,
  });

  final watchViewController = Get.put(WatchViewController());
  final Watches? currentWatch;
  //final Color? primary;

  @override
  State<WearRow> createState() => _WearRowState();
}

class _WearRowState extends State<WearRow> {
  @override
  Widget build(BuildContext context) {
    //Default canRecordWear value
    widget.watchViewController.updateCanRecordWear(false);

    //Set to true only for watches in the collection
    if (widget.watchViewController.watchViewState.value == WatchViewEnum.view) {
      widget.watchViewController.canRecordWear(widget.currentWatch!.status == "In Collection");
    }

    return _buildWearRow();
  }

  Widget _buildWearRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: widget.currentWatch?.status == "In Collection" || widget.currentWatch?.status == "Sold" ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).buttonTheme.colorScheme?.primary,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(FontAwesomeIcons.chartBar,
                        color: Colors.white),
                    onPressed: () => Get.to(() => WatchCharts(currentWatch: widget.currentWatch!,)),
                  ),
                ),
              )
            ],
          ) : SizedBox(height: 0,),
        ),
        Expanded(
          flex:6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.currentWatch!.status == "In Collection"? _addWearButton() : const SizedBox(height: 10),
              const SizedBox(height: 10),
              //Show last worn date
              _displayLastWearDate(),
              _displayWearCount(),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Expanded(
            flex: 2,
            child: widget.currentWatch?.status != "Wishlist" && widget.currentWatch?.status != "Pre-Order" ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).buttonTheme.colorScheme?.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(FontAwesomeIcons.calendarDays,
                        color: Colors.white,),
                      onPressed: (){
                        Get.to(() => WearDatesWidget(currentWatch: widget.currentWatch!))!.then((_) => setState(
                                (){}
                                    //TODO: how to refresh last worn date?
                        ));
                      },
                    ),
                  ),
                )
              ],
            ) : SizedBox(height: 0,)
        )
      ],
    );
  }

  Widget _displayLastWearDate(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Last worn: ${ViewWatchHelper.getLastWearDate(widget.currentWatch!)}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),),
      ],
    );
  }

  Widget _displayWearCount(){
    var wearCount = widget.currentWatch!.wearList.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        wearCount == 1? const Text("Worn 1 time"): Text("Worn: $wearCount times",
        ),
      ],
    );
  }

  Widget _addWearButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: Text(ViewWatchHelper.getWearButtonText(widget.currentWatch!)),
          onPressed: () {
            if(widget.watchViewController.canRecordWear.value) {
              var wearDate = DateTime.now();
              WatchMethods.attemptToRecordWear(
                  widget.currentWatch!, wearDate, false).then((_) =>
              {
                setState(() {})
              });
            } else { null; }
          },
        ),
      ],
    );
  }
}
