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
  late Future<List<File?>> _pageData;

  @override
  void initState() {
    _watchCarouselController = CarouselController(initialItem: _currentPage);
    _pageData = getPageData();
    super.initState();
  }


  @override
  void dispose() {
    _watchCarouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<File?> images;

    return FutureBuilder<List<File?>>(
          future: _pageData,
          builder: (context, AsyncSnapshot<List<File?>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              try {
                images = snapshot.data!;
              } on Exception catch (e) {
                print("Exception caught in implementing image file list: $e");
                images = [];
              }
              _prepDataList(images);

              return Row(
                mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Column(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width*0.95,
                  height: MediaQuery.sizeOf(context).width*0.8,
                  child:
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        child: Obx(()=> Hero(
                          tag: "ImageCarousel",
                          child: CarouselView.weighted(
                                onTap: (index) async {
                                  //If there is no image selected, show the new image pop-up. Otherwise...
                                  widget.watchViewController.imageList[index].image == null || widget.watchViewController.watchViewState == WatchViewEnum.add ?
                                  await AddImage(index) : Get.to(()=> WatchImageGallery(watch: widget.currentWatch!, index: index,));
                                    },
                                flexWeights: [1,8,1],
                                  controller: _watchCarouselController,
                                  itemSnapping: true,
                                  children: [widget.watchViewController.imageList[0], widget.watchViewController.imageList[1], widget.watchViewController.imageList[2],]
                            ),
                        ),
                        ),
                      )
                ),
              ],
            ),
          ],
        );
      }else {
              return Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator()
              );
            }
          }
      );

}

/*
When in an add state, get values for temporary images from the controller (will be null if not yet added)
 */
  Future<List<File?>>addWatchImageList() async {
    return <File?>[widget.watchViewController.frontImage.value, widget.watchViewController.backImage.value, widget.watchViewController.lumeImage.value];
  }

  Future<bool> AddImage(int index) async {
    //TODO: Refactor method along with ImagesUtil methods to take an index instead of bool
    bool front = true;
    if(index == 1) {
      front = false;
    }

    var imageSource = await ImagesUtil.imageSourcePopUp(context);
  //Split this method depending on status
  if (widget.watchViewController.watchViewState.value != WatchViewEnum.add) {
  await  ImagesUtil.pickAndSaveImage(source: imageSource!, currentWatch: widget.currentWatch!, index: index);
  widget.watchViewController.updateImageListIndex(ImageCardWidget(image:  await ImagesUtil.getImage(widget.currentWatch!, index)),  index);
  }
  else {
  var tempImage = imageSource!= null? await ImagesUtil.pickImage(source: imageSource): null;
  widget.watchViewController.updateImage(tempImage, index);
  widget.watchViewController.updateImageListIndex(ImageCardWidget(image: tempImage), index);
  }
  return true;
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
    //Clear the current list
    widget.watchViewController.clearImageList();
    //We need to create a list of ImageCards - images or icons depending on what's currently saved
    for (int i = 0; i < images.length; i++){
      widget.watchViewController.imageList.add(ImageCardWidget(image: images[i]));
    }
  }
  
}