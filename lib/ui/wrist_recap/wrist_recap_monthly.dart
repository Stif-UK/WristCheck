import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wrist_recap_controllers/wrist_recap_monthly_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/util/helper_classes.dart';
import 'package:wristcheck/util/images_util.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class WristRecapMonthly extends StatelessWidget {
  WristRecapMonthly({super.key, required this.month, required this.year});

  final int month;
  final int year;
  final recapController = Get.put(WristRecapMonthlyController());

  @override
  Widget build(BuildContext context) {
    //Initialise the controller
    recapController.updateMonth(month);
    recapController.updateYear(year);
    //Generate list of worn watches
    recapController.generateWornWatchesDate(recapController.month.value, recapController.year.value);

    return Scaffold(
      appBar: AppBar(
        title: (Text("Wrist Recap")),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(icon: Icon(FontAwesomeIcons.gear),
            onPressed: (){},),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Padding(
            padding: const EdgeInsets.all(8.0),
            //TODO: Update to include full month name
            child: Text("${WristCheckFormatter.getMonthName(recapController.month.value)} ${recapController.year.value}", 
              style: Theme.of(context).textTheme.headlineMedium,),
          )),
          
          const Divider(thickness: 2,),
          
          Obx(() => recapController.watchesWorn.isEmpty 
            ? const SizedBox(height: 0,)
            : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Watches worn:", style: Theme.of(context).textTheme.bodyLarge,),
                ),
                SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recapController.watchesWorn.length,
                      itemBuilder: (context, index) {
                        final wornWatch = recapController.watchesWorn[index];
                        return _buildWatchWornCard(wornWatch, context);
                      },
                    ),
                  ),
                const Divider(thickness: 2,)
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget _buildWatchWornCard(WornWatchesClass wornWatch, BuildContext context) {
    final watch = wornWatch.watch;
    bool showImage = watch.frontImagePath != null && watch.frontImagePath != "";

    return Container(
      width: 160,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                  : _getEmptyIcon(context),
              const SizedBox(height: 10),
              Text(
                watch.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                AppLocalizations.of(context)!.wearCount(wornWatch.count),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getEmptyIcon(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(Icons.watch, size: 50, color: Theme.of(context).disabledColor),
    );
  }
}
