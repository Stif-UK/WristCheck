import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/collection_view.dart';
import 'package:wristcheck/model/enums/watchbox_ordering.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/view_watch.dart';
import 'package:wristcheck/util/list_tile_helper.dart';

class WatchboxListView extends StatefulWidget {
  WatchboxListView({
    Key? key,
    required this.collectionValue, required this.watchOrder}) : super(key: key);
  final CollectionView collectionValue;
  final WatchOrder watchOrder;
  final wristCheckController = Get.put(WristCheckController());




  @override
  State<WatchboxListView> createState() => _WatchboxListViewState();
}

class _WatchboxListViewState extends State<WatchboxListView> {
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
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: filteredList.length,
              itemBuilder: (BuildContext context, int index){
                var watch = filteredList.elementAt(index);
                String? _title = "${watch.manufacturer} ${watch.model}";
                bool fav = watch.favourite; // ?? false;
                String? _status = "${watch.status}";
                int _wearCount = watch.wearList.length;



                return ListTile(
                  leading: const Icon(Icons.watch),
                  title: Text(_title),
                  subtitle: Text(ListTileHelper.getWatchboxListSubtitle(watch)),
                  isThreeLine: true,

                  trailing:  InkWell(
                    child: fav? const Icon(Icons.star): const Icon(Icons.star_border),
                    onTap: () {
                      setState(() {
                        watch.favourite = !fav;
                        watch.save();
                      });
                    },
                  ),
                  onTap: () => Get.to(() => ViewWatch(currentWatch: watch,)),
                );
              },
              separatorBuilder: (context, index){
                return const Divider(thickness: 2,);
              },
            ),
          );
        }


    );
  }
}
