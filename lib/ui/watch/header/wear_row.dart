import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/watch/watch_charts.dart';
import 'package:wristcheck/ui/wear_dates_widget.dart';
import 'package:wristcheck/util/view_watch_helper.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

import 'package:wristcheck/model/enums/watch_status_enum.dart';

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
    if (widget.currentWatch == null) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder<Box<Watches>>(
      valueListenable: Boxes.getWatches().listenable(keys: [widget.currentWatch!.key]),
      builder: (context, box, _) {
        final currentWatch = box.get(widget.currentWatch!.key) ?? widget.currentWatch!;
        return _buildWearRow(currentWatch);
      },
    );
  }

  Widget _buildWearRow(Watches currentWatch){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: currentWatch.status == WatchStatusEnum.inCollection.toDbString() || currentWatch.status == WatchStatusEnum.sold.toDbString() ? Column(
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
                    icon: FaIcon(FontAwesomeIcons.chartBar,
                        color: Colors.white),
                    onPressed: () => Get.to(() => WatchCharts(currentWatch: currentWatch,)),
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
              currentWatch.status == WatchStatusEnum.inCollection.toDbString() || currentWatch.status == WatchStatusEnum.onLoan.toDbString() ? _addWearButton(currentWatch) : const SizedBox(height: 10),
              const SizedBox(height: 10),
              //Show last worn date
              FittedBox(child: _displayLastWearDate(currentWatch)),
              _displayWearCount(currentWatch),
              currentWatch.status == WatchStatusEnum.inCollection.toDbString() ?_displayWearFrequency(currentWatch) : const SizedBox.shrink(),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Expanded(
            flex: 2,
            child: currentWatch.status != WatchStatusEnum.wishlist.toDbString() && currentWatch.status != WatchStatusEnum.preOrder.toDbString() ? Column(
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
                      icon: FaIcon(FontAwesomeIcons.calendarDays,
                        color: Colors.white,),
                      onPressed: (){
                        Get.to(() => WearDatesWidget(currentWatch: currentWatch))!.then((_) => setState(
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

  Widget _displayLastWearDate(Watches currentWatch){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          child: Text(AppLocalizations.of(Get.context!)!.lastWorn(ViewWatchHelper.getLastWearDate(currentWatch)),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          overflow: TextOverflow.ellipsis,),
        ),
      ],
    );
  }

  Widget _displayWearCount(Watches currentWatch){
    var wearCount = currentWatch.wearList.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(Get.context!)!.nWears(wearCount)),
        //Text(WristCheckFormatter.getWearCountText(wearCount))
      ],
    );
  }

  Widget _displayWearFrequency(Watches? watch){
    //If wearlist is empty then exit
    if(watch == null || watch.wearList.length == 0) return const SizedBox.shrink();

    DateTime firstWorn = watch.wearList.first;
    DateTime now = DateTime.now();
    int daysSinceFirstWear = now.difference(firstWorn).inDays + 1; //+1 so the count begins from 1, not 0.
    var wearFrequency = (watch.wearList.length / daysSinceFirstWear)*100;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(Get.context!)!.wearFrequency(wearFrequency.toStringAsFixed(0)))
      ],
    );
  }

  Widget _addWearButton(Watches currentWatch){
    bool canRecordWear = currentWatch.status == WatchStatusEnum.inCollection.toDbString() || currentWatch.status == WatchStatusEnum.onLoan.toDbString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: Text(ViewWatchHelper.getWearButtonText(currentWatch), overflow: TextOverflow.ellipsis,),
          onPressed: () {
            if(canRecordWear) {
              var wearDate = DateTime.now();
              WatchMethods.attemptToRecordWear(
                  currentWatch, wearDate, false).then((_) =>
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
