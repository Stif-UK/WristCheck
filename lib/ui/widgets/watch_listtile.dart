import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/model/enums/collection_view.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/watch/watchview.dart';
import 'package:wristcheck/util/list_tile_helper.dart';
import 'package:wristcheck/util/images_util.dart';


class WatchListTile extends ListTile {
  const WatchListTile(this.currentWatch, this.collectionView, {Key? key})
      : super(key: key);
  final Watches currentWatch;
  final CollectionView collectionView;

  @override
  Widget build(BuildContext context) {
    //Strip data from the watch object
    var watch = currentWatch;
    String? _title = "${watch.manufacturer} ${watch.model}";
    bool fav = watch.favourite; // ?? false;
    String? _status = "${watch.status}";
    int _wearCount = watch.wearList.length;
    //Categorise the view
    bool fullTile = false;
    if (collectionView == CollectionView.all ||
        collectionView == CollectionView.favourites ||
        collectionView == CollectionView.random) {
      fullTile = true;
    }
    //Check if watch has an image
    bool showImage = false;
    if (watch.frontImagePath != null && watch.frontImagePath != "") {
      showImage = true;
    }

    return ListTile(
      //TODO: Add watch image or icon logic
      leading: showImage ?
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
                return ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 75,
                    maxHeight: 75,
                    minWidth: 75,
                    maxWidth: 75,
                  ),
                  child: Image.file(data),
                );

              }
            }
            return _getEmptyIcon(context);
          } //builder
      )

      //If we don't have a watch image
      //:const Icon(Icons.watch, size: 30,),
          : _getEmptyIcon(context),
      title: Text(_title),
      //Alter subtitle if not full info - for now, wishlist and sold views are blank
      subtitle: fullTile
          ? Text(ListTileHelper.getWatchboxListSubtitle(watch))
          : const Text(""),
      isThreeLine: true,

      trailing: InkWell(
        child: fav ? const Icon(Icons.star) : const Icon(Icons.star_border),
        onTap: () {
          //TODO: Make class stateful to enable favouriting from main view
          // setState(() {
          //   watch.favourite = !fav;
          //   watch.save();
          // });
        },
      ),
      onTap: () => Get.to(() => WatchView(currentWatch: watch,)),
    );
  }


  Widget _getEmptyIcon(context) {
    return Container(
        width: 75,
        height: 75,
        decoration: BoxDecoration(
            border: Border.all(color: Theme
                .of(context)
                .disabledColor)
        ),
        child: const Icon(Icons.watch));

  }

}
