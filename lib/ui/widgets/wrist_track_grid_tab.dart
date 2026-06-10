import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/enums/collection_view.dart';
import 'package:wristcheck/ui/watch/watchview.dart';
import 'package:wristcheck/util/images_util.dart';
import 'package:wristcheck/util/list_tile_helper.dart';

class WristTrackGridTab extends StatelessWidget {
  const WristTrackGridTab({
    Key? key,
    required this.currentWatch,
    required this.collectionValue,
  }) : super(key: key);

  final Watches currentWatch;
  final CollectionView collectionValue;

  @override
  Widget build(BuildContext context) {
    const double boxSides = 95;

    return InkWell(
      onTap: () => Get.to(() => WatchView(currentWatch: currentWatch,)),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).disabledColor),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Header - watch make & model
            Text(
              currentWatch.manufacturer,
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              currentWatch.model,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            //Add image to listtile
            FutureBuilder(
                future: ImagesUtil.getImage(currentWatch, currentWatch.primaryImageIndex ?? 0),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
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
            Expanded(
                child: Text(
              ListTileHelper.getWatchboxListSubtitle(currentWatch, collectionValue),
              textAlign: TextAlign.center,
              style: ListTileHelper.getSubtitleTheme(currentWatch),
            ))
          ],
        ),
      ),
    );
  }

  Widget _getEmptyIcon(BuildContext context, double boxSides) {
    return Container(
        width: boxSides,
        height: boxSides,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).disabledColor)),
        child: const Icon(Icons.watch));
  }
}
