import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wristcheck/controllers/filter_controller.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/view_watch.dart';



class WatchBoxWidget extends StatefulWidget {
  const WatchBoxWidget({Key? key}) : super(key: key);



  @override
  State<WatchBoxWidget> createState() => _WatchBoxWidgetState();
}

final FilterController filterController = Get.put(FilterController());

class _WatchBoxWidgetState extends State<WatchBoxWidget> {

  final watchBox = Boxes.getWatches();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<Box<Watches>>(
          valueListenable: watchBox.listenable(),
          builder: (context, box, _){
            List<Watches> filteredList = Boxes.getFilteredWatches(
                FilterController().getFilterName());



        return filteredList.isEmpty?Container(
          alignment: Alignment.center,
          child: const Text("Your watch-box is currently empty\n\nPress the red button to add watches to your collection\n",
            textAlign: TextAlign.center,),
        ):

         ListView.separated(
            itemCount: filteredList.length,
            itemBuilder: (BuildContext context, int index){
              var watch = filteredList.elementAt(index);
              String? _title = "${watch.manufacturer} ${watch.model}";
              bool fav = watch.favourite; // ?? false;
              String? _status = "${watch.status}";


              return ListTile(
                leading: const Icon(Icons.watch),
                title: Text(_title),
                subtitle: Text(_status),
                trailing:  InkWell(
                    child: fav? const Icon(Icons.star): const Icon(Icons.star_border),
                  onTap: () {
                      setState(() {
                    watch.favourite = !fav;
                    watch.save();
                      });
                  },
                ),
                onTap: () => Get.to(() => ViewWatch(currentWatch: watch,)),
              );
            },
          separatorBuilder: (context, index){
              return Divider();
          },
            );
          }


      )

    );

  }

}
