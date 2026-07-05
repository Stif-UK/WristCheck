import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/recap_empty_icon.dart';
import 'package:wristcheck/util/helper_classes.dart';
import 'package:wristcheck/util/images_util.dart';

class WornWatchCard extends StatelessWidget {
  final WornWatchesClass wornWatch;

  const WornWatchCard({super.key, required this.wornWatch});

  @override
  Widget build(BuildContext context) {
    final watch = wornWatch.watch;
    //TODO: Update this to check the primary image selected for the watch
    bool showImage = watch.frontImagePath != null && watch.frontImagePath != "";

    return Container(
      alignment: Alignment.topLeft,
      width: 160,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Watch Image
              showImage
                  ? FutureBuilder(
                      future: ImagesUtil.getImage(watch, watch.primaryImageIndex ?? 0),
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
                        return Container(
                          width: 100,
                          height: 100,
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      },
                    )
                  : const RecapEmptyIcon(dimension: 100),
              const SizedBox(height: 10),
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
              const SizedBox(height: 5,),
              Text(
                "Wear Percentage: ${wornWatch.percentage}",
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.left,
              )
            ],
          ),
        ),
      ),
    );
  }
}
