import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/model/enums/timeline_type_enum.dart';
import 'package:wristcheck/ui/more_menu/timeline/wristcheck_timeline_tile.dart';
import 'package:wristcheck/util/timeline_helper.dart';

class WristCheckTimeline extends StatelessWidget {
  const WristCheckTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    //Get Data
    List<TimeLineEvent> data = TimeLineHelper.getTimeLineData();

    return Scaffold(
      appBar: AppBar(
        title: Text("Timeline"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: Icon(FontAwesomeIcons.gear),
            onPressed: (){},),
          )
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index){
              return WristCheckTimelineTile(
                isFirst: index == 0,
                isLast: index == data.length-1,
                event: data[index],);
            },
          ),
        ),
      )

    );
  }
}
