import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/dynamic_copy_helper.dart';
import 'package:wristcheck/model/enums/collection_view.dart';
import 'package:wristcheck/model/enums/watchbox_ordering.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/widgets/shrink_on_scroll_item.dart';
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
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Watches> unsortedList = Boxes.getWatchesByFilter(widget.collectionValue);
    List<Watches> filteredList = Boxes.sortWatchBox(unsortedList, widget.wristCheckController.watchboxOrder.value!);

    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    if (screenWidth >= 1200) {
      crossAxisCount = 5;
    } else if (screenWidth >= 900) {
      crossAxisCount = 4;
    } else if (screenWidth >= 600) {
      crossAxisCount = 3;
    }


    return ValueListenableBuilder<Box<Watches>>(
        valueListenable: watchBox.listenable(),
        builder: (context, box, _){


          return filteredList.isEmpty?Container(
            alignment: Alignment.center,
            child: DynamicCopyHelper.getEmptyBoxCopy(widget.collectionValue, context)
          ):

          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 110.0),
              itemCount: filteredList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.67,
                ),
                itemBuilder: (BuildContext context, int index){
                  var currentWatch = filteredList.elementAt(index);
                  return ShrinkOnScrollItem(
                    scrollController: _scrollController,
                    maxShrink: 0.30,
                    maxHorizontalShift: 20.0,
                    columnIndex: index % crossAxisCount,
                    totalColumns: crossAxisCount,
                    child: WristTrackGridTab(
                      currentWatch: currentWatch,
                      collectionValue: widget.collectionValue,
                    ),
                  );
                })
          );
        }


    );
  }
}


