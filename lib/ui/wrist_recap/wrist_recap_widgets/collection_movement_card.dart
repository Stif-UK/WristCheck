import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/recap_empty_icon.dart';
import 'package:wristcheck/util/images_util.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class CollectionMovementCard extends StatelessWidget {
  const CollectionMovementCard({super.key, required this.watch, required this.purchased});

  final Watches watch;
  final bool purchased;

  @override
  Widget build(BuildContext context) {
    //TODO: This should check for the primary image - an externalised method is required.
    bool showImage = watch.frontImagePath != null && watch.frontImagePath != "";

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            showImage
                ? FutureBuilder(
                    future: ImagesUtil.getImage(watch, watch.primaryImageIndex ?? 0),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError || !snapshot.hasData) {
                          return const RecapEmptyIcon(dimension: 60,);
                        }
                        final data = snapshot.data as File;
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            data,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      return Container(
                        width: 60,
                        height: 60,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                  )
                : const RecapEmptyIcon(dimension: 60,),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(watch.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),),
                  watch.purchaseDate != null && watch.purchaseDate != "" ? Text(AppLocalizations.of(context)!.cmPurchasedOn(WristCheckFormatter.getFormattedDate(watch.purchaseDate!)), style: Theme.of(context).textTheme.bodySmall,) : const SizedBox(height: 0,),
                  watch.soldDate != null && watch.soldDate != "" ? Text(AppLocalizations.of(context)!.cmSoldOn(WristCheckFormatter.getFormattedDate(watch.soldDate!)), style: Theme.of(context).textTheme.bodySmall,) : const SizedBox(height: 0,)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: purchased? Icon(FontAwesomeIcons.cashRegister) :Icon(FontAwesomeIcons.handHoldingDollar),
            )

          ],
        ),
      ),

    );
  }
}
