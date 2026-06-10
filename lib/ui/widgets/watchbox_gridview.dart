import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/dynamic_copy_helper.dart';
import 'package:wristcheck/model/enums/collection_view.dart';
import 'package:wristcheck/model/enums/watchbox_ordering.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/widgets/wrist_track_grid_tab.dart';

class WatchboxGridView extends StatefulWidget {
  WatchboxGridView({
    Key? key,
    required this.collectionValue, required this.watchOrder}) : super(key: key);
  final CollectionView collectionValue;
  final WatchOrder watchOrder;
  final wristCheckController = Get.put(WristCheckController());




  @override
  State<WatchboxGridView> createState() => _WatchboxGridViewState();
}

class _WatchboxGridViewState extends State<WatchboxGridView> {
  final watchBox = Boxes.getWatches();




  @override
  Widget build(BuildContext context) {
    List<Watches> unsortedList = Boxes.getWatchesByFilter(widget.collectionValue);
    List<Watches> filteredList = Boxes.sortWatchBox(unsortedList, widget.wristCheckController.watchboxOrder.value!);


    return ValueListenableBuilder<Box<Watches>>(
        valueListenable: watchBox.listenable(),
        builder: (context, box, _){


          return filteredList.isEmpty?Container(
            alignment: Alignment.center,
            child: DynamicCopyHelper.getEmptyBoxCopy(widget.collectionValue, context)
          ):

          Expanded(
            child: GridView.builder(
              itemCount: filteredList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                ),
                itemBuilder: (BuildContext context, int index){
                  var currentWatch = filteredList.elementAt(index);
                  return WristTrackGridTab(
                    currentWatch: currentWatch,
                    collectionValue: widget.collectionValue,
                  );
                })
          );
        }


    );
  }
}

