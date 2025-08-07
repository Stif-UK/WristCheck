import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/model/watches.dart';

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
              child: CarouselView.weighted(
                controller: _watchCarouselController,
                  itemSnapping: true,
                  flexWeights: [1,8,1],
                    children: [widget.watchViewController.imageList[0],widget.watchViewController.imageList[1], widget.watchViewController.imageList[2]]
                ),
            ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: Icon(FontAwesomeIcons.repeat, color: Colors.green,),
                onPressed: ()=> print("Replace button pressed"),),
                IconButton(icon: Icon(FontAwesomeIcons.trash, color: Colors.red,),
                  onPressed: ()=> print("Delete button pressed"),)
              ],
            ),
          )
        ],
      ),

    );
  }
}
