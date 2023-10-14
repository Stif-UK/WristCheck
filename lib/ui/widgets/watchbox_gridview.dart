import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/dynamic_copy_helper.dart';
import 'package:wristcheck/model/enums/collection_view.dart';
import 'package:wristcheck/model/enums/watchbox_ordering.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/watch/watchview.dart';
import 'package:wristcheck/util/images_util.dart';
import 'package:wristcheck/util/list_tile_helper.dart';

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

    bool fullTile = false;
    if (widget.collectionValue == CollectionView.all ||
        widget.collectionValue == CollectionView.favourites ||
        widget.collectionValue == CollectionView.random) {
      fullTile = true;
    }
    const double boxSides = 95;


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
                  return InkWell(
                    onTap: () => Get.to(() => WatchView(currentWatch: currentWatch,)),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                            border: Border.all(color: Theme
                                .of(context)
                                .disabledColor),
                        borderRadius: BorderRadius.circular(20)
                        ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Header - watch make & model
                          Text(currentWatch.manufacturer, style: Theme.of(context).textTheme.bodyLarge,maxLines: 1, overflow: TextOverflow.ellipsis,),
                          Text(currentWatch.model, style: Theme.of(context).textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis,),
                          //Add image to listtile
                          FutureBuilder(
                              future: ImagesUtil.getImage(currentWatch, true),
                              builder: (context, snapshot) {
                                //start
                                if (snapshot.connectionState == ConnectionState.done) {
                                  // If we got an error
                                  if (snapshot.hasError) {
                                    return const CircularProgressIndicator();
                                    // if we got our data
                                  } else if (snapshot.hasData) {
                                    // Extracting data from snapshot object
                                    final data = snapshot.data as File;
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          minHeight: boxSides,
                                          maxHeight: boxSides,
                                          minWidth: boxSides,
                                          maxWidth: boxSides,
                                        ),
                                        child: Image.file(data),
                                      ),
                                    );

                                  }
                                }
                                return _getEmptyIcon(context, boxSides);
                              } //builder
                          ),
                          //Footer - Details of watch counts
                          Expanded(child: Text(ListTileHelper.getWatchboxListSubtitle(currentWatch, widget.collectionValue), textAlign: TextAlign.center,))
                        ],
                      ),
                    ),
                  );
                })
          );
        }


    );
  }

  Widget _getEmptyIcon(context, double boxSides) {
    return Container(
        width: boxSides,
        height: boxSides,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme
                .of(context)
                .disabledColor)
        ),
        child: const Icon(Icons.watch));

  }
}
