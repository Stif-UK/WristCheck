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
    const double boxSides = 175;

    return GestureDetector(
      onTap: () => Get.to(() => WatchView(currentWatch: currentWatch,)),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Primary image
            FutureBuilder(
                future: ImagesUtil.getImage(currentWatch, currentWatch.primaryImageIndex ?? 0),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      final data = snapshot.data as File;
                      return Container(
                        alignment: Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: boxSides,
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.file(data, fit: BoxFit.cover)),
                        ),
                      );
                    }
                  }
                  return _getEmptyIcon(context, boxSides);
                } //builder
                ),
            const SizedBox(height: 8),
            // Manufacturer
            Text(
              currentWatch.manufacturer,
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // Model
            Text(
              currentWatch.model,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // Last worn and wear count lines (order swapped)
            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ListTileHelper.getWatchboxListSubtitle(currentWatch, collectionValue)
                  .split('\n')
                  .where((line) => line.isNotEmpty)
                  .toList()
                  .reversed
                  .map((line) => Text(
                        line,
                        style: ListTileHelper.getSubtitleTheme(currentWatch) ?? 
                               Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ))
                  .toList(),
            )),
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
