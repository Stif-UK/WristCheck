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
      child: Text("Servicing!"),
    );
  }
}
