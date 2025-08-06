import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/model/watches.dart';

class WatchImageGallery extends StatefulWidget {
  WatchImageGallery({required this.watch, super.key});
  final Watches watch;
  final watchViewController = Get.put(WatchViewController());


  @override
  State<WatchImageGallery> createState() => _WatchImageGalleryState();
}

class _WatchImageGalleryState extends State<WatchImageGallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.watch.toString()),
      ),

    );
  }
}
