import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/watch/watchview.dart';

class DataWatchlist extends StatelessWidget {
  const DataWatchlist({
    super.key,
    required this.fieldTitle,
    required this.fieldExtractor,
  });

  final String fieldTitle;
  final dynamic Function(Watches) fieldExtractor;

  bool _isPopulated(dynamic value) {
    if (value == null) return false;
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return false;
      if (trimmed == 'Not Entered' || trimmed == 'Not Selected') return false;
      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watch data: $fieldTitle'),
      ),
      body: ValueListenableBuilder<Box<Watches>>(
        valueListenable: Boxes.getWatches().listenable(),
        builder: (context, box, _) {
          final collectionWatches = Boxes.getCollectionWatches();

          if (collectionWatches.isEmpty) {
            return const Center(
              child: Text('No watches in collection'),
            );
          }

          return ListView.separated(
            itemCount: collectionWatches.length,
            separatorBuilder: (context, index) => const Divider(thickness: 2),
            itemBuilder: (context, index) {
              final watch = collectionWatches[index];
              final value = fieldExtractor(watch);
              final isPopulated = _isPopulated(value);

              return ListTile(
                title: Text(watch.toString()),
                trailing: isPopulated
                    ? const FaIcon(
                        FontAwesomeIcons.circleCheck,
                        color: Colors.green,
                      )
                    : const FaIcon(
                        FontAwesomeIcons.circleXmark,
                        color: Colors.red,
                      ),
                onTap: () => Get.to(() => WatchView(currentWatch: watch)),
              );
            },
          );
        },
      ),
    );
  }
}
