import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/widgets/bottomsheets/image_update_bottomsheet.dart';
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
                          onLongPress: ()=> showUpdateBottomSheet(0),
                          child: widget.watchViewController.imageList[0]),
                        GestureDetector(
                            onLongPress: ()=> showUpdateBottomSheet(1),
                            child: widget.watchViewController.imageList[1]),
                        GestureDetector(
                            onLongPress: ()=> showUpdateBottomSheet(2),
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

  showUpdateBottomSheet(int index){
    return showModalBottomSheet(
        context: context,
        builder:
          (context){
            return Container(
              child: ImageUpdateBottomsheet(index: index, watch: widget.watch,)
            );
          }
        );

  }
}
