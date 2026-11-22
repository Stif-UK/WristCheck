import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/watch/header/watch_image_gallery.dart';
import 'package:wristcheck/ui/widgets/images/image_card_widget.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/recap_empty_icon.dart';
import 'package:wristcheck/util/helper_classes.dart';
import 'package:wristcheck/util/images_util.dart';

class WornWatchCard extends StatelessWidget {
  final WornWatchesClass wornWatch;
  final VoidCallback? onTap;

  const WornWatchCard({
    super.key,
    required this.wornWatch,
    this.onTap,
  });

  Future<void> _openImageGallery(BuildContext context, Watches watch) async {
    final watchViewController = Get.put(WatchViewController());
    final List<File?> images = ImagesUtil.appDocsPath != null
        ? ImagesUtil.getAllImagesSync(watch)
        : [
            await ImagesUtil.getImage(watch, 0),
            await ImagesUtil.getImage(watch, 1),
            await ImagesUtil.getImage(watch, 2),
          ];

    watchViewController.imageList.assignAll(
      images.map((image) => ImageCardWidget(image: image)).toList(),
    );
    watchViewController.updateViewState(WatchViewEnum.view);

    final int initialIndex = (watch.primaryImageIndex ?? 0).clamp(0, 2);
    if (!context.mounted) return;
    Get.to(() => WatchImageGallery(watch: watch, index: initialIndex));
  }

  @override
  Widget build(BuildContext context) {
    final watch = wornWatch.watch;
    final int primaryIndex = watch.primaryImageIndex ?? 0;
    final bool showImage = ImagesUtil.getNamePath(watch, primaryIndex).isNotEmpty;

    return Container(
      alignment: Alignment.topLeft,
      width: 160,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(8.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap ?? () => _openImageGallery(context, watch),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Watch Image
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      showImage
                          ? FutureBuilder(
                              future: ImagesUtil.getImage(watch, primaryIndex),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  if (snapshot.hasError || !snapshot.hasData) {
                                    return const RecapEmptyIcon(dimension: 100);
                                  }
                                  final data = snapshot.data as File;
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      data,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }
                                return const SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              },
                            )
                          : const RecapEmptyIcon(dimension: 100),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                Text(
                  watch.toString(),
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  AppLocalizations.of(context)!.wearCount(wornWatch.count),
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 5),
                Text(
                  AppLocalizations.of(context)!.wornPercentage(wornWatch.percentage!),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
