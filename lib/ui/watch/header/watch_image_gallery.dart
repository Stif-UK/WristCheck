import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/images_util.dart';

class WatchImageGallery extends StatefulWidget {
  WatchImageGallery({
    required this.watch,
    required this.index,
    super.key});


  final Watches watch;
  final watchViewController = Get.put(WatchViewController());
  final int index;



  @override
  State<WatchImageGallery> createState() => _WatchImageGalleryState();
}

class _WatchImageGalleryState extends State<WatchImageGallery> {

  @override
  void initState() {
    _watchCarouselController = CarouselController(initialItem: widget.index);
    super.initState();
  }

  @override
  void dispose() {
    _watchCarouselController.dispose();
    super.dispose();
  }

  late CarouselController _watchCarouselController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.watch.toString()} Gallery"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width*0.90,
            child: Obx(()=> Hero(
              tag: "ImageCarousel",
              child: GestureDetector(
                onHorizontalDragEnd: (_)=>print("dragged"),
                child: CarouselView.weighted(
                  controller: _watchCarouselController,
                    itemSnapping: true,
                    flexWeights: [1,8,1],
                      enableSplash: false,
                      children: [GestureDetector(
                        onLongPress: ()=> print("long press detected for front image") ,
                          child: widget.watchViewController.imageList[0]),
                        GestureDetector(
                            onLongPress: ()=> print("long press detected for back image") ,
                            child: widget.watchViewController.imageList[1]),
                        GestureDetector(
                            onLongPress: ()=>print("long press detected for lume image"),
                            child: widget.watchViewController.imageList[2])]
                  ),
              ),
            ),
            ),
          ),
          Center(
            child: Text("Long press to edit or delete"),
          ),
        ],
      ),

    );
  }
}
