import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';


class ServicingWidget extends StatefulWidget {
  const ServicingWidget({Key? key}) : super(key: key);

  @override
  State<ServicingWidget> createState() => _ServicingWidgetState();
}

class _ServicingWidgetState extends State<ServicingWidget> {

  final watchBox = Boxes.getWatches();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ValueListenableBuilder<Box<Watches>>(
            valueListenable: watchBox.listenable(),
            builder: (context, box, _){
              List<Watches> filteredList = Boxes.getServiceSchedule();



              return filteredList.isEmpty?Container(
                alignment: Alignment.center,
                child: Text("No Service schedules identified. \n\nEdit your watch info to track service timelines and last-serviced dates.",
                  textAlign: TextAlign.center,),
              ):

              ListView.separated(
                itemCount: filteredList.length,
                itemBuilder: (BuildContext context, int index){
                  var watch = filteredList.elementAt(index);
                  String? _title = "${watch.manufacturer} ${watch.model}";


                  return ListTile(
                    leading: Icon(Icons.manage_history_rounded),
                    title: Text("$_title"),
                    subtitle: Text("Next Service: ${DateFormat.yMMMd().format(watch.nextServiceDue!)}"),
                    // trailing:  fav? Icon(Icons.star): Icon(Icons.star_border),
                    // onTap: () => Get.to(ViewWatch(currentWatch: watch,)),
                  );
                },
                separatorBuilder: (context, index){
                  return Divider();
                },
              );
            }


        )

    );


      // Container(
      // alignment: Alignment.center,
      // child:
      //     Text("No Service schedules identified. \n\nEdit your watch info to track service timelines and last-serviced dates.",
      //     textAlign: TextAlign.center,),
      // );



  }
}
