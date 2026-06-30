import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/collection_view.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/watch/watchview.dart';
import 'package:wristcheck/util/images_util.dart';
import 'package:wristcheck/util/list_tile_helper.dart';

class WatchCard extends StatelessWidget {
  final Watches watch;
  final CollectionView collectionView;

  const WatchCard({
    super.key,
    required this.watch,
    required this.collectionView,
  });

  @override
  Widget build(BuildContext context) {
    bool showImage = watch.frontImagePath != null && watch.frontImagePath != "";

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => Get.to(() => WatchView(currentWatch: watch)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Watch Image
              showImage
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
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Theme.of(context).disabledColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      },
                    )
                  : _getEmptyIcon(context),
              const SizedBox(width: 15),
              // Watch Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      watch.toString(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Obx(() {
                      final wristCheckController = Get.put(WristCheckController());
                      wristCheckController.showLastWornDate.value;
                      wristCheckController.showWearCount.value;
                      return Text(
                        ListTileHelper.getWatchboxListSubtitle(watch, collectionView),
                        style: ListTileHelper.getSubtitleTheme(watch) ?? 
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).textTheme.bodySmall?.color,
                                ),
                      );
                    }),
                  ],
                ),
              ),
              // Favourite Star
              Icon(
                watch.favourite ? Icons.star : Icons.star_border,
                color: watch.favourite ? Colors.amber : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getEmptyIcon(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
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
