import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/view_watch.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/copy/snackbars.dart';

class Archived extends StatefulWidget {
  Archived({Key? key}) : super(key: key);

  @override
  State<Archived> createState() => _ArchivedState();
}

class _ArchivedState extends State<Archived> {
  var watchBox = Boxes.getWatches();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Archived Watches"),
        actions: [
          IconButton(
              icon: const Icon(Icons.help_outline),
            onPressed: (){} )
        ],

      ),
        body: ValueListenableBuilder<Box<Watches>>(
            valueListenable: watchBox.listenable(),
            builder: (context, box, _){
              List<Watches> archiveList = Boxes.getArchivedWatches();



              return archiveList.isEmpty?Container(
                alignment: Alignment.center,
                child: const Text("Your Archive is currently empty",
                  textAlign: TextAlign.center,),
              ):

              ListView.separated(
                itemCount: archiveList.length,
                itemBuilder: (BuildContext context, int index){
                  final item = archiveList[index].toString();
                  var watch = archiveList.elementAt(index);
                  String? _title = "${watch.manufacturer} ${watch.model}";
                  String? _status = "${watch.status}";


                  return Dismissible(
                    key: Key(item),
                    direction: DismissDirection.endToStart,

                    onDismissed: (direction) {
                      setState(() {
                        archiveList.removeAt(index);
                        var watchInfo = "${watch.manufacturer} ${watch.model}";
                        watchBox.delete(watch.key);
                        // Then show a snackbar.
                        WristCheckSnackBars.deleteWatch(watchInfo);
                      });

                    },

                    child: ListTile(
                      leading: const Icon(Icons.watch),
                      title: Text(_title),
                      subtitle: Text(_status),
                      onTap: () => Get.to(() => ViewWatch(currentWatch: watch,)),
                    ),

                    background: Container(
                    alignment: Alignment.center,color: Colors.red,
                    child: const Text("Deleting"),),
                  );
                },
                separatorBuilder: (context, index){
                  return const Divider();
                },
              );
            }


        )
    );
  }
}
