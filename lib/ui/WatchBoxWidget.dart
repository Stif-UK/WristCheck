import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wristcheck/controllers/filter_controller.dart';
import 'package:get/get.dart';



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

        List<Watches> filteredList = Boxes.getAllWatches();

        ever (filterController.filterName,(_) {
          switch (filterController.filterName.toString()) {
            case "Show All":
              {
                filteredList = Boxes.getAllWatches();
                print("List: Get all watches");
              }
              break;
            case "In Collection":
              {
                filteredList = Boxes.getCollectionWatches();
                print("List: Get collection watches");
              }
              break;
            default:
              {
                filteredList = Boxes.getAllWatches();
                print("List default: all watches");
              }
              break;
          }
        }
        );

        return filteredList.isEmpty?Container(
          alignment: Alignment.center,
          child: Text("Your watch-box is currently empty\n\nPress the red button to add watches to your collection\n",
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
                leading: Icon(Icons.watch),
                title: Text("$_title"),
                subtitle: Text("$_status"),
                trailing:  fav? Icon(Icons.star): Icon(Icons.star_border)
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
