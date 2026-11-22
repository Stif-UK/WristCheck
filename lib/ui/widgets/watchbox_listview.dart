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
import 'package:wristcheck/ui/widgets/watch_card.dart';

class WatchboxListView extends StatefulWidget {
  WatchboxListView({
    Key? key,
    required this.collectionValue,
    required this.watchOrder,
    required this.scrollController,
  }) : super(key: key);
  final CollectionView collectionValue;
  final WatchOrder watchOrder;
  final ScrollController scrollController;
  final wristCheckController = Get.put(WristCheckController());

  @override
  State<WatchboxListView> createState() => _WatchboxListViewState();
}

class _WatchboxListViewState extends State<WatchboxListView> {
  final watchBox = Boxes.getWatches();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Watches>>(
        valueListenable: watchBox.listenable(),
        builder: (context, box, _){
          List<Watches> unsortedList = Boxes.getWatchesByFilter(widget.collectionValue);
          List<Watches> filteredList = Boxes.sortWatchBox(unsortedList, widget.wristCheckController.watchboxOrder.value!);

          if (filteredList.isEmpty) {
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: DynamicCopyHelper.getEmptyBoxCopy(widget.collectionValue, context),
              ),
            );
          }

          return SliverPadding(
            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 110.0),
            sliver: SliverList.separated(
              itemCount: filteredList.length,
              separatorBuilder: (context, index){
                return const SizedBox(height: 5,);
              },
              itemBuilder: (BuildContext context, int index) {
                return ShrinkOnScrollItem(
                  scrollController: widget.scrollController,
                  child: WatchCard(watch: filteredList.elementAt(index), collectionView: widget.collectionValue),
                );
              },
            ),
          );
        }


    );
  }
}

