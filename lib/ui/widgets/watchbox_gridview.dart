import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/collection_view.dart';
import 'package:wristcheck/model/enums/watchbox_ordering.dart';
import 'package:wristcheck/model/watches.dart';

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
            child: const Text("Your watch-box is currently empty\n\nPress the red button to add watches to your collection\n",
              textAlign: TextAlign.center,),
          ):

          Expanded(
              // child: ListView.separated(
              //   shrinkWrap: true,
              //   itemCount: filteredList.length,
              //   separatorBuilder: (context, index){
              //     return const Divider(thickness: 2,);
              //   },
              //   itemBuilder: (BuildContext context, int index) {
              //     return WatchListTile(filteredList.elementAt(index), widget.collectionValue);
              //   },
              // )
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    decoration: BoxDecoration(
                          border: Border.all(color: Theme
                              .of(context)
                              .disabledColor)
                      ),
                    child: Text(filteredList.elementAt(index).model),
                  );
                })
          );
        }


    );
  }
}
