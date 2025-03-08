import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/controllers/gallery_controller.dart';
import 'package:wristcheck/model/enums/gallery_selection_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/more_menu/gallery/image_overlay.dart';
import 'package:wristcheck/util/images_util.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';
import 'package:get/get.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class Gallery extends StatefulWidget {
  Gallery({super.key});
  final galleryController = Get.put(GalleryController());

  @override
  State<Gallery> createState() => _GalleryState();
}



class _GalleryState extends State<Gallery> {

  StreamController<Widget> overlayController =
  StreamController<Widget>.broadcast();

  @override
  void dispose() {
    overlayController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Watch Gallery"),
      ),
      body:  Obx(()=> FutureBuilder(
            builder: (ctx, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasError){
                  return Center(
                    child: Text("${snapshot.error} occurred",
                    style: Theme.of(context).textTheme.headlineSmall,),
                  );
                } else if (snapshot.hasData){
                  final data = snapshot.data as List<Watches>;
                  widget.galleryController.updateDataAvailable(data.isNotEmpty);
                  return SingleChildScrollView(
                    child: Center(
                      child: Obx(()=> Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text("Show off your collection!",
                                textAlign: TextAlign.center,
                                ),
                            ),
                            _getCollectionPickerRow(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                child: Text("Go",
                                style: TextStyle(fontSize: 20.0),),
                                //TODO: Handle empty list
                                onPressed: ()=> data.isNotEmpty? SwipeImageGallery(
                                  context: context,
                                  itemBuilder: (context, index){
                                    return FutureBuilder(
                                        builder: (ctx, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            if (snapshot.hasError) {
                                              return Center(
                                                child: Text(
                                                  "${snapshot.error} occurred",
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .headlineSmall,),
                                              );
                                            } else if (snapshot.hasData) {
                                              final imageData = snapshot.data as File;
                                              return Image.file(imageData);
                                            }
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );

                                        },
                                          future: ImagesUtil.getImage(data[index], true));
                                    },
                                    itemCount: data.length,
                                  // children: data,
                                  onSwipe: (index) {
                                    overlayController.add(ImageOverlay(
                                      title: '${index + 1}/${data.length}',
                                      subtitle: "${data[index].manufacturer} ${data[index].model}",
                                    ));
                                  },
                                  overlayController: overlayController,
                                  initialOverlay: ImageOverlay(
                                    title: '1/${data.length}',
                                    subtitle: "${data[0].manufacturer} ${data[0].model}",
                                )).show() : null ,
                              ),
                            ),
                            widget.galleryController.dataAvailable.value? SizedBox(height: 0,): _getDataNotAvailableRow()
                          ],
                        ),
                      ),
                    ),
                  );
                };
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
            future: ImagesUtil.getWatchesWithImages(widget.galleryController.gallerySelection.value), ),
      )
    );
  }
}

Widget _getCollectionPickerRow(){
  final galController = Get.put(GalleryController());

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Show me my ", style: Theme.of(Get.context!).textTheme.bodyLarge,),
      Obx(()=> DropdownButton<GallerySelectionEnum>(
          value: galController.gallerySelection.value,
          items: GallerySelectionEnum.values.map((selection) {
            return DropdownMenuItem<GallerySelectionEnum>(
                value: selection,
                child: Text(WristCheckFormatter.getGallerySelectionName(selection)));
          }).toList(),
          onChanged: (selection) => galController.updateGallerySelection(selection!)

      ),
      ),
    ],
  );
}

Widget _getDataNotAvailableRow(){
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Icon(FontAwesomeIcons.eyeSlash),
        ),
        Text("No Images were found for this filter",
          style: Theme.of(Get.context!).textTheme.headlineSmall ,
        textAlign: TextAlign.center,)
      ],
    ),
  );
}

