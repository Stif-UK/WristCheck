import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/copy/snackbars.dart';
import 'package:wristcheck/ui/backup/backup_restore.dart';
import 'package:wristcheck/util/images_util.dart';

class DataLinks extends StatefulWidget {

  @override
  State<DataLinks> createState() => _DataLinksState();
}


class _DataLinksState extends State<DataLinks> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final watchBox = Boxes.getWatches();



  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(screenName: "app_data");

    return Scaffold(
      appBar: AppBar(
        title: const Text("App Data"),
      ),
      body: Column(
    children: [
    Expanded(
    child: ListView(
      children: [
        ListTile(
            title: const Text("Backup / Restore Database"),
            leading: const Icon(Icons.save_alt),
            onTap: (){
              Get.to(()=> const BackupRestore());
            }
        ),
        const Divider(thickness: 2,),
        ListTile(
            title: const Text("CSV Export"),
            leading: const Icon(FontAwesomeIcons.fileCsv),
            onTap: (){
              //Get.to(()=> const BackupRestore());
            }
        ),
        const Divider(thickness: 2,),
        ListTile(
            title:const Text("Delete collection"),
            leading: const Icon(Icons.warning),
            trailing: OutlinedButton(
                child: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: (){
                  Get.defaultDialog(
                      title: "Warning",
                      middleText: "Pressing OK will delete all watch data, including your wishlist and all saved images\n \n THIS CANNOT BE UNDONE",
                      textConfirm: "OK",
                      textCancel: "Cancel",
                      onConfirm: (){
                        _deleteCollection();
                        Get.back();
                        WristCheckSnackBars.collectionDeletedSnackbar();
                      }

                  );
                }
            )
        ),
        const Divider(thickness: 2,),
      ],
    ),
    )
    ]));
  }

  void _deleteCollection(){
    ImagesUtil.deleteAllImages();
    watchBox.clear();
  }
}
