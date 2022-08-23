import 'package:flutter/material.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

import '../boxes.dart';
import '../model/watches.dart';

class CollectionStats extends StatelessWidget {
  const CollectionStats({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    List<Watches> watchBox = Boxes.getCollectionWatches();
    Watches? oldestWatch = WatchMethods.getOldestorNewestWatch(watchBox, true);
    Watches? newestWatch = WatchMethods.getOldestorNewestWatch(watchBox, false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Collection Stats"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(20),
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
              leading: const Icon(Icons.access_alarm),
              trailing: const Icon(Icons.help_outline),
              title: const Text("Oldest Watch"),
              subtitle: oldestWatch == null? const Text("No purchase dates tracked"):Text("${oldestWatch.model}\n${WristCheckFormatter.getFormattedDate(oldestWatch.purchaseDate!)}"),


            ),
            const Divider(thickness: 2,)
          ],
        ),






      ),
    );
  }

}
