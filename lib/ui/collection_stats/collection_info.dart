import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class CollectionInfo extends StatelessWidget {
  CollectionInfo({Key? key}) : super(key: key);
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    analytics.setAnalyticsCollectionEnabled(true);
    analytics.logScreenView(screenName: "collection_info");
    final l = AppLocalizations.of(context);

    List<Watches> watchBox = Boxes.getCollectionWatches();
    Watches? oldestWatch = WatchMethods.getOldestorNewestWatch(watchBox, true);
    Watches? newestWatch = WatchMethods.getOldestorNewestWatch(watchBox, false);
    List<Watches> longestWorn = WatchMethods.getMostOrLeastWornWatch(watchBox, true);
    List<Watches> shortestWorn = WatchMethods.getMostOrLeastWornWatch(watchBox, false);
    List<Watches> wishList = Boxes.getWishlistWatches();
    List<Watches> soldList = Boxes.getSoldWatches();
    String? longestWornWatches;
    String? shortestWornWatches;
    if(longestWorn.length != 1){
      longestWornWatches = _findLongestWornModels(longestWorn);
    }
    if(shortestWorn.length != 1){
      shortestWornWatches = _findLongestWornModels(shortestWorn);
    }

    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.shopping_bag_outlined),
                  title: Text(l!.sizeOfCollection),
                  subtitle: Text(l.nWatches(watchBox.length)),
                  //subtitle: watchBox.length == 1? Text("${watchBox.length} watch") : Text("${watchBox.length} watches"),
                ),
                const Divider(thickness: 2,),
                ListTile(
                  isThreeLine: true,
                  leading: const Icon(Icons.dark_mode_outlined),
                  title: Text(l.oldestWatch),
                  subtitle: oldestWatch == null? Text(l.noPurchaseDatesTracked):Text("${oldestWatch.toString()}\n${WristCheckFormatter.getFormattedDate(oldestWatch.purchaseDate!)}"),


                ),
                const Divider(thickness: 2,),
                ListTile(
                  isThreeLine: true,
                  leading: const Icon(Icons.light_mode_outlined),
                  title: Text(l.newestWatch),
                  subtitle: newestWatch == null? Text(l.noPurchaseDatesTracked):Text("${newestWatch.toString()}\n${WristCheckFormatter.getFormattedDate(newestWatch.purchaseDate!)}"),


                ),
                const Divider(thickness: 2,),

                //Only show most and least worn if the watchbox is not empty
                watchBox.isNotEmpty? ListTile(
                    isThreeLine: true,
                    leading: const Icon(Icons.star_border),
                    title: Text(l.mostWorn),
                    subtitle: longestWorn.length == 1? Text("${longestWorn[0].toString()}\n${l.nWears(longestWorn[0].wearList.length)}") :Text("$longestWornWatches ${l.nWears(longestWorn[0].wearList.length)}"),

                ): const SizedBox(height: 0,),
                watchBox.isNotEmpty? const Divider(thickness: 2,): const SizedBox(height: 0,),

                watchBox.isNotEmpty? ListTile(
                    isThreeLine: true,
                    leading: const Icon(Icons.stacked_bar_chart_outlined),
                    title: Text(l.leastWorn),
                    subtitle: shortestWorn.length == 1? Text("${shortestWorn[0].toString()}\n${l.nWears(shortestWorn[0].wearList.length)}") : Text("$shortestWornWatches \n${l.nWears(shortestWorn[0].wearList.length)}")

                ): const SizedBox(height: 0,),
                watchBox.isNotEmpty? const Divider(thickness: 2,): const SizedBox(height: 0,),


                ListTile(
                    isThreeLine: true,
                    leading: const Icon(Icons.cake_outlined),
                    title: Text(l.wishListCount),
                    subtitle: Text(l.nWatches(wishList.length)),

                ),
                const Divider(thickness: 2,),

                ListTile(
                    isThreeLine: true,
                    leading: const Icon(Icons.monetization_on_outlined),
                    title: Text(l.soldWatches),
                    subtitle: Text(l.nWatches(soldList.length)),

                ),
                const Divider(thickness: 2,),
              ],
            ),
          ),
        )
      ],
    );
  }

  String _findLongestWornModels(List<Watches> longestWorn){
    String returnString = "";
    for (var watch in longestWorn) {
      returnString = "$returnString & \n${watch.model}";
    }
    return returnString.replaceFirst(" & \n", "");

  }
}
