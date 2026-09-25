import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/watch/header/watch_image_gallery.dart';
import 'package:wristcheck/ui/widgets/images/image_card_widget.dart';
import 'package:wristcheck/util/images_util.dart';

class WatchImageCarousel extends StatefulWidget {
  WatchImageCarousel({super.key, required this.currentWatch});
  final watchViewController = Get.put(WatchViewController());
  final Watches? currentWatch;

  @override
  State<WatchImageCarousel> createState() => _WatchImageCarouselState();
}

class _WatchImageCarouselState extends State<WatchImageCarousel> {
  late CarouselController _watchCarouselController;
  int _currentPage = 0;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      _currentPage = widget.currentWatch?.primaryImageIndex ?? 0;
    } catch (_) {
      _currentPage = 0;
    }
    _watchCarouselController = CarouselController(initialItem: _currentPage);
    super.initState();
    if (_currentPage > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _watchCarouselController.hasClients) {
          final double extent = MediaQuery.sizeOf(context).width * 0.8;
          _watchCarouselController.jumpTo(_currentPage * extent);
        }
      });
    }
  }


  @override
  void dispose() {
    _watchCarouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<File?> images;
    if (widget.watchViewController.watchViewState.value != WatchViewEnum.add && widget.currentWatch != null) {
      images = ImagesUtil.getAllImagesSync(widget.currentWatch!);
    } else {
      images = <File?>[
        widget.watchViewController.frontImage.value,
        widget.watchViewController.backImage.value,
        widget.watchViewController.lumeImage.value,
      ];
    }
    _prepDataList(images);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.95,
              height: MediaQuery.sizeOf(context).width * 0.8,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                child: Obx(
                  () {
                    if (widget.watchViewController.imageList.length < 3) {
                      return const SizedBox();
                    }
                    return Hero(
                      tag: "ImageCarousel",
                      child: CarouselView(
                        itemExtent: MediaQuery.sizeOf(context).width * 0.8,
                        controller: _watchCarouselController,
                        itemSnapping: true,
                        onTap: (index) async {
                          widget.watchViewController.imageList[index].image == null ||
                                  widget.watchViewController.watchViewState == WatchViewEnum.add
                              ? await ImagesUtil.addImageViaController(index, context, widget.currentWatch)
                              : Get.to(() => WatchImageGallery(watch: widget.currentWatch!, index: index));
                        },
                        children: [
                          widget.watchViewController.imageList[0],
                          widget.watchViewController.imageList[1],
                          widget.watchViewController.imageList[2],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

/*
When in an add state, get values for temporary images from the controller (will be null if not yet added)
 */
  Future<List<File?>>addWatchImageList() async {
    return <File?>[widget.watchViewController.frontImage.value, widget.watchViewController.backImage.value, widget.watchViewController.lumeImage.value];
  }

  /*
Get the data to show on the page - this is either a list of File? objects (including null) where the page is in view/edit state, or a series of 'Add Watch' images in the case of new watch records.
 */
  Future <List<File?>> getPageData(){
    return widget.watchViewController.watchViewState.value != WatchViewEnum.add? ImagesUtil.getAllImages(widget.currentWatch!): addWatchImageList();
  }

  /*
  Prep the data - use the returned images and nulls to generate a series of either images or icons
   */
  void _prepDataList(List<File?> images) {
    widget.watchViewController.imageList.assignAll(
      images.map((image) => ImageCardWidget(image: image)).toList(),
    );
  }

}