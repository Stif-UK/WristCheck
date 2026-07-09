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

class WatchboxGalleryView extends StatefulWidget {
  WatchboxGalleryView({
    Key? key,
    required this.collectionValue,
    required this.watchOrder,
  }) : super(key: key);
  
  final CollectionView collectionValue;
  final WatchOrder watchOrder;
  final wristCheckController = Get.find<WristCheckController>();

  @override
  State<WatchboxGalleryView> createState() => _WatchboxGalleryViewState();
}

class _WatchboxGalleryViewState extends State<WatchboxGalleryView> {
  final watchBox = Boxes.getWatches();

  @override
  Widget build(BuildContext context) {
    List<Watches> unsortedList = Boxes.getWatchesByFilter(widget.collectionValue);
    List<Watches> filteredList = Boxes.sortWatchBox(unsortedList, widget.wristCheckController.watchboxOrder.value!);

    return ValueListenableBuilder<Box<Watches>>(
      valueListenable: watchBox.listenable(),
      builder: (context, box, _) {
        if (filteredList.isEmpty) {
          return Container(
            alignment: Alignment.center,
            child: DynamicCopyHelper.getEmptyBoxCopy(widget.collectionValue, context),
          );
        }

        return Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: filteredList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              var currentWatch = filteredList.elementAt(index);
              return InkWell(
                onTap: () => Get.to(() => WatchView(currentWatch: currentWatch)),
                child: _getWatchImage(currentWatch),
              );
            },
          ),
        );
      },
    );
  }

  Widget _getWatchImage(Watches watch) {
    bool showImage = watch.frontImagePath != null && watch.frontImagePath != "";

    return showImage
        ? FutureBuilder(
            future: ImagesUtil.getImage(watch, watch.primaryImageIndex ?? 0),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError || !snapshot.hasData) {
                  return _getEmptyIcon(context);
                }
                final data = snapshot.data as File;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    data,
                    fit: BoxFit.cover,
                  ),
                );
              }
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(child: CircularProgressIndicator()),
              );
            },
          )
        : _getEmptyIcon(context);
  }

  Widget _getEmptyIcon(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).disabledColor.withOpacity(0.2)),
      ),
      child: Icon(
        Icons.watch,
        size: 40,
        color: Theme.of(context).disabledColor,
      ),
    );
  }
}
