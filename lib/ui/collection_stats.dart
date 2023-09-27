import 'package:flutter/material.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:wristcheck/copy/dialogs.dart';

import '../boxes.dart';
import '../model/watches.dart';

class CollectionStats extends StatelessWidget {
  const CollectionStats({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Collection Stats"),
        actions: [
          IconButton(onPressed: (){WristCheckDialogs.getCollectionStatsDialog();}, icon: const Icon(Icons.help_outline))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.shopping_bag_outlined),
                    title: const Text("Size of Collection"),
                    subtitle: watchBox.length == 1? Text("${watchBox.length} watch") : Text("${watchBox.length} watches"),
                  ),
                  const Divider(thickness: 2,),
                  ListTile(
                    isThreeLine: true,
                    leading: const Icon(Icons.dark_mode_outlined),
                    title: const Text("Oldest Watch"),
                    subtitle: oldestWatch == null? const Text("No purchase dates tracked"):Text("${oldestWatch.model}\n${WristCheckFormatter.getFormattedDate(oldestWatch.purchaseDate!)}"),


                  ),
                  const Divider(thickness: 2,),
                  ListTile(
                    isThreeLine: true,
                    leading: const Icon(Icons.light_mode_outlined),
                    title: const Text("Newest Watch"),
                    subtitle: newestWatch == null? const Text("No purchase dates tracked"):Text("${newestWatch.model}\n${WristCheckFormatter.getFormattedDate(newestWatch.purchaseDate!)}"),


                  ),
                  const Divider(thickness: 2,),

                  //Only show most and least worn if the watchbox is not empty
                  watchBox.isNotEmpty? ListTile(
                    isThreeLine: true,
                    leading: const Icon(Icons.star_border),
                    title: const Text("Most Worn"),
                    subtitle: longestWorn.length == 1? Text("${longestWorn[0].model}\nWorn ${longestWorn[0].wearList.length} times") : Text("$longestWornWatches \nWorn ${longestWorn[0].wearList.length} times")

                  ): const SizedBox(height: 0,),
                  watchBox.isNotEmpty? const Divider(thickness: 2,): const SizedBox(height: 0,),

                  watchBox.isNotEmpty? ListTile(
                      isThreeLine: true,
                      leading: const Icon(Icons.stacked_bar_chart_outlined),
                      title: const Text("Least Worn"),
                      subtitle: shortestWorn.length == 1? Text("${shortestWorn[0].model}\nWorn ${shortestWorn[0].wearList.length} times") : Text("$shortestWornWatches \nWorn ${shortestWorn[0].wearList.length} times")

                  ): const SizedBox(height: 0,),
                  watchBox.isNotEmpty? const Divider(thickness: 2,): const SizedBox(height: 0,),


                  ListTile(
                      isThreeLine: true,
                      leading: const Icon(Icons.cake_outlined),
                      title: const Text("Wish listed Watches"),
                      subtitle: wishList.length == 1? Text("${wishList.length} watch") : Text("${wishList.length} watches")

                  ),
                  const Divider(thickness: 2,),

                  ListTile(
                      isThreeLine: true,
                      leading: const Icon(Icons.monetization_on_outlined),
                      title: const Text("Sold Watches"),
                      subtitle: soldList.length == 1? Text("${soldList.length} watch") : Text("${soldList.length} watches")

                  ),
                  const Divider(thickness: 2,),
                ],
              ),






            ),
          ),
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text("These stats compiled with WristCheck app"),
                ],
              ))
        ],
      ),
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
