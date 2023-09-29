import 'package:flutter/material.dart';
import 'package:wristcheck/ui/collection_stats/collection_info.dart';
import 'package:wristcheck/copy/dialogs.dart';


class CollectionStats extends StatelessWidget {
  const CollectionStats({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: const Text("Collection Stats"),
        actions: [
          IconButton(onPressed: (){WristCheckDialogs.getCollectionStatsDialog();}, icon: const Icon(Icons.help_outline))
        ],
      ),
      body: const CollectionInfo()
    );
  }

}
