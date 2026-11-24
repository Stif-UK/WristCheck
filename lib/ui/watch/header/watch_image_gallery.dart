import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
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
    final bool isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(Get.context!)!.watchGallery(widget.watch.toString())),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double availableWidth = constraints.maxWidth;
            final double galleryHeight = isLandscape
                ? math.min(availableWidth * 0.90, constraints.maxHeight * 0.65)
                : availableWidth * 0.90;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: galleryHeight,
                  child: Obx(()=> Hero(
                    tag: "ImageCarousel",
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
                                child: widget.watchViewController.imageList[2])],
                      onTap: (index) async {
                        //If there is no image selected, show the new image pop-up. Otherwise...
                        widget.watchViewController.imageList[index].image == null ?
                        await ImagesUtil.addImageViaController(index, context, widget.watch) : null;
                      },
                      ),
                  ),
                  ),
                ),
                Center(
                  child: Text(AppLocalizations.of(Get.context!)!.longPressToEditOrDelete),
                ),
              ],
            );
          },
        ),
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
