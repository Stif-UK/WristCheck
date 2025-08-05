import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/watches.dart';
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
    List<Widget> imageList = [];

    return FutureBuilder<List<File?>>(
          future: _pageData,
          builder: (context, AsyncSnapshot<List<File?>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              try {
                // snapshot.data == File("") ? images = [null] :
                images = snapshot.data!;
              } on Exception catch (e) {
                print("Exception caught in implementing image file list: $e");
                images = [];
              }
              for (int i = 0; i < images.length; i++){
                File? pic = images[i];
                pic == null? imageList.add(const Icon(Icons.add_a_photo_outlined, size: 85)):
                imageList.add(Image.file(pic, fit: BoxFit.cover,));
              }
              //Temporary, remove!
              imageList.add(const Icon(Icons.ac_unit, size: 90,));

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
                        child: CarouselView.weighted(
                          onTap: (index) async => imageList[index].runtimeType == Icon? await AddImage(index).then((_)=> setState(() {})) : print("image tapped $index, object type: ${imageList[index].runtimeType}"),
                          flexWeights: [1,8,1],
                            controller: _watchCarouselController,
                            shrinkExtent: 200.0,
                            itemSnapping: true,
                            children: imageList,),
                      )

                ),
              ],
            ),
            //TODO: Unhide buttons and refactor
            // Expanded(
            //   flex: 2,
            //   //Column to display the pick image and switch image icons
            //   child: Column(
            //     children: [
            //       InkWell(
            //           child: const Icon(Icons.add_a_photo_outlined),
            //           onTap: () async {
            //
            //
            //             var imageSource = await ImagesUtil.imageSourcePopUp(context);
            //             //Split this method depending on status
            //             if (widget.watchViewController.watchViewState.value != WatchViewEnum.add) {
            //               await  ImagesUtil.pickAndSaveImage(source: imageSource!, currentWatch: widget.currentWatch!, front: widget.watchViewController.front.value);
            //             } else{
            //               if(widget.watchViewController.front.value) {
            //                 imageSource != null
            //                     ? widget.watchViewController.updateFrontImage(
            //                 await ImagesUtil.pickImage(source: imageSource))
            //                     : null;
            //               } else {
            //                 imageSource != null
            //                     ? widget.watchViewController.updateBackImage(
            //                 await ImagesUtil.pickImage(source: imageSource))
            //                     : null;
            //               }
            //             }
            //
            //             //pickAndSaveImage will have set the image for the given watch
            //             //Now call setstate to ensure the display is updated
            //             setState(() {
            //
            //             });
            //           }
            //       ),
            //       const SizedBox(height: 25,),
            //       IconButton(
            //           icon: const Icon(Icons.flip_camera_android_rounded),
            //           onPressed: (){
            //             widget.watchViewController.updateFrontValue(!widget.watchViewController.front.value);
            //           })
            //     ],
            //   ),
            // ),


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

Future <List<File?>> getPageData(){
  return widget.watchViewController.watchViewState.value != WatchViewEnum.add? ImagesUtil.getAllImages(widget.currentWatch!): addWatchImageList();
  }

/*
When in an add state, get values for temporary images from the controller (will be null if not yet added)
 */
  Future<List<File?>>addWatchImageList() async {
    return <File?>[widget.watchViewController.frontImage.value, widget.watchViewController.backImage.value];
  }

  Future<bool> AddImage(int index) async {
    //TODO: Refactor method along with ImagesUtil methods to take an index instead of bool
    bool front = true;
    switch(index){
      case 1:
        front = false;
        break;
      case 3:
        front = false;
        break;
    }


  var imageSource = await ImagesUtil.imageSourcePopUp(context);
  //Split this method depending on status
  if (widget.watchViewController.watchViewState.value != WatchViewEnum.add) {
  await  ImagesUtil.pickAndSaveImage(source: imageSource!, currentWatch: widget.currentWatch!, front: front);
  } else{
  if(front) {
  imageSource != null
  ? widget.watchViewController.updateFrontImage(
  await ImagesUtil.pickImage(source: imageSource))
      : null;
  } else {
  imageSource != null
  ? widget.watchViewController.updateBackImage(
  await ImagesUtil.pickImage(source: imageSource))
      : null;
  }
  }
  
  return true;

  //pickAndSaveImage will have set the image for the given watch
  //Now call setstate to ensure the display is updated
  setState(() {

  });
}

  // Widget imageView(List<File?> data, int index) {
  //   return Column(
  //     children: [
  //       imageCard(data[index]),
  //     ],
  //   );
  // }

//   Widget imageCard(File? image) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//               //height: 180,
//               margin: const EdgeInsets.all(5),
//               //Padding and borderradius not required once image is selected
//               padding: image == null? const EdgeInsets.all(40): null,
//               decoration: image == null? BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(width: 2, color: Get.isDarkMode? Colors.white: Colors.black)) : null,
//               //If we have an image display it (ClipRRect used to round corners to soften the image)
//               child: image == null? Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children:  [
//                   const Icon(Icons.camera_alt, size: 75),
//                   // widget.watchViewController.front.value? const Text("Front"): const Text("Back"),
//                 ],
//               ): ClipRRect(
//                 child: Image.file(image),
//                 borderRadius: BorderRadius.circular(16),
//               )
//         )
//       ],
//     );
//   }
// }

  // Future<File?>addWatchImage(bool front) async {
  //   return front? widget.watchViewController.frontImage.value: widget.watchViewController.backImage.value;
  // }
}