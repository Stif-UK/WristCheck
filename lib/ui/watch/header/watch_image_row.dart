import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/images_util.dart';

class WatchImageRow extends StatefulWidget {
  WatchImageRow({super.key, required this.currentWatch});
  final watchViewController = Get.put(WatchViewController());
  final Watches? currentWatch;


  @override
  State<WatchImageRow> createState() => _WatchImageRowState();
}

class _WatchImageRowState extends State<WatchImageRow> {
  @override
  Widget build(BuildContext context) {
    File? image;
    List<File?> images;

    return Obx(()=> FutureBuilder<File?>(
          future: widget.watchViewController.watchViewState.value != WatchViewEnum.add? ImagesUtil.getImage(widget.currentWatch!, widget.watchViewController.front.value): addWatchImage(widget.watchViewController.front.value),
          builder: (context, AsyncSnapshot<File?> snapshot) {
            if (snapshot.hasData || snapshot.data == null) {
              try {
                snapshot.data == File("") ? image = null :
                image = snapshot.data;
              } on Exception catch (e) {
                print("Exception caught in implementing file: $e");
                image = null;
              }
              return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            const Expanded(
                flex: 2,
                child: SizedBox(height: 10)),
            Expanded(
              flex: 6,
              child: Obx(()=> Container(
                    height: 180,
                    margin: const EdgeInsets.all(20),
                    //Padding and borderradius not required once image is selected
                    padding: image == null? const EdgeInsets.all(40): null,
                    decoration: image == null? BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(width: 2, color: Get.isDarkMode? Colors.white: Colors.black)) : null,
                    //If we have an image display it (ClipRRect used to round corners to soften the image)
                    child: image == null? Column(
                      mainAxisSize: MainAxisSize.min,
                      children:  [
                        const Icon(Icons.camera_alt, size: 75),
                        widget.watchViewController.front.value? const Text("Front"): const Text("Back"),
                      ],
                    ): ClipRRect(
                      child: Image.file(image!),
                      borderRadius: BorderRadius.circular(16),
                    )
                ),
              ),

            ),
            Expanded(
              flex: 2,
              //Column to display the pick image and switch image icons
              child: Column(
                children: [
                  InkWell(
                      child: const Icon(Icons.add_a_photo_outlined),
                      onTap: () async {


                        var imageSource = await ImagesUtil.imageSourcePopUp(context);
                        //Split this method depending on status
                        if (widget.watchViewController.watchViewState.value != WatchViewEnum.add) {
                          await  ImagesUtil.pickAndSaveImage(source: imageSource!, currentWatch: widget.currentWatch!, front: widget.watchViewController.front.value);
                        } else{
                          if(widget.watchViewController.front.value) {
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

                        //pickAndSaveImage will have set the image for the given watch
                        //Now call setstate to ensure the display is updated
                        setState(() {

                        });
                      }
                  ),
                  const SizedBox(height: 25,),
                  IconButton(
                      icon: const Icon(Icons.flip_camera_android_rounded),
                      onPressed: (){
                        widget.watchViewController.updateFrontValue(!widget.watchViewController.front.value);
                      }),

                ],
              ),
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
      ),
    );

}



  Future<File?>addWatchImage(bool front) async {
    return front? widget.watchViewController.frontImage.value: widget.watchViewController.backImage.value;
  }
}