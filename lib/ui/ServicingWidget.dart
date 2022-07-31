import 'package:flutter/material.dart';

class ServicingWidget extends StatefulWidget {
  const ServicingWidget({Key? key}) : super(key: key);

  @override
  State<ServicingWidget> createState() => _ServicingWidgetState();
}

class _ServicingWidgetState extends State<ServicingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child:
          Text("No Service schedules identified. \n\nEdit your watch info to track service timelines and last-serviced dates.",
          textAlign: TextAlign.center,),
      );



  }
}
