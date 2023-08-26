import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/view_watch.dart';
import 'package:wristcheck/util/list_tile_helper.dart';

class WatchListTile extends ListTile{
  const WatchListTile(this.currentWatch, {Key? key}) : super(key: key);
  final Watches currentWatch;

  @override
  Widget build(BuildContext context) {
    var watch = currentWatch;
    String? _title = "${watch.manufacturer} ${watch.model}";
    bool fav = watch.favourite; // ?? false;
    String? _status = "${watch.status}";
    int _wearCount = watch.wearList.length;
    return ListTile(
      leading: const Icon(Icons.watch),
      title: Text(_title),
      subtitle: Text(ListTileHelper.getWatchboxListSubtitle(watch)),
      isThreeLine: true,

      trailing:  InkWell(
        child: fav? const Icon(Icons.star): const Icon(Icons.star_border),
        onTap: () {
          // setState(() {
          //   watch.favourite = !fav;
          //   watch.save();
          // });
        },
      ),
      onTap: () => Get.to(() => ViewWatch(currentWatch: watch,)),
    );
  }
}
