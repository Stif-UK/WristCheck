import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/util/list_tile_helper.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/view_watch.dart';
import 'package:wristcheck/copy/dialogs.dart';



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
                child: const Text("No Service schedules identified. \n\nEdit your watch info to track service timelines and last-serviced dates.",
                  textAlign: TextAlign.center,),
              ):

              Column(
                  children:[
                    Expanded(
              flex:1,
                  child: ListTile(
                    title: Text("Service Schedule"),
                    leading: Icon(Icons.schedule),
                    trailing: InkWell(
                        child: Icon(Icons.help),
                      onTap: () => WristCheckDialogs.getServicePageTooltipDialog(),

                    ),
                  )

              ),
                    const Divider(
                      thickness: 2.0,
                    ),


                    Expanded(
              flex: 9,
              child:ListView.separated(
              itemCount: filteredList.length,
              itemBuilder: (BuildContext context, int index){
              var watch = filteredList.elementAt(index);
              String? _title = "${watch.manufacturer} ${watch.model}";


              return ListTile(
              leading: ListTileHelper.getServicingIcon(watch.nextServiceDue!),
              title: Text("$_title"),
              subtitle: Text("Next Service: ${DateFormat.yMMMd().format(watch.nextServiceDue!)}"),
              //ToDo: Update and create service view page?
              onTap: () => Get.to(ViewWatch(currentWatch: watch,)),
              );
              },
              separatorBuilder: (context, index){
              return const Divider();
              },
              )
              )
                  ]
                  );
            }


        )

    );

  }
}
