import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/enums/gallery_selection_enum.dart';
import 'package:wristcheck/model/enums/watchbox_ordering.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';

class ImagesUtil {

  /*
  pickImage takes in an ImageSource (camera or gallery) and a Watch and allows the user to select an image.
  the path to this is then saved to the given watch as it's display image, after forcing it to be cropped to the
  correct aspect ratio.
  It also
   */
  static pickAndSaveImage({
    required ImageSource source,
    required Watches currentWatch,
    required bool front
  }) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return null;

      final imageTemporary = File(image.path);
      var croppedImage = await ImagesUtil.cropImage(imageTemporary);
      File returnImage;
      if(croppedImage == null){
        return null;
      } else{
        returnImage = File(croppedImage.path);
        await ImagesUtil.saveImage(croppedImage.path, currentWatch, front);

      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
      //ToDo: Implement error handling
      return null;
    }
  }

  static Future<File?> pickImage({
    required ImageSource source,
  }) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return null;

      final imageTemporary = File(image.path);
      var croppedImage = await ImagesUtil.cropImage(imageTemporary);
      File returnImage;
      if(croppedImage == null){
        return null;
      } else{
        returnImage = File(croppedImage.path);
        return returnImage;
        //await ImagesUtil.saveImage(croppedImage.path, currentWatch);

      }
    } on PlatformException catch (e) {
      WristCheckDialogs.getFailedToPickImageDialog(e);
      return null;
    }
  }


  /*
  Calls a bottom modal sheet allowing user to select if the source of their image should be
  from the camera or the gallery
   */
  static Future<ImageSource?> imageSourcePopUp(BuildContext context) async {
    return showModalBottomSheet(context: context,
        builder: (context) => Container(
          decoration: BoxDecoration(
            color: Colors.white38,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10,),
              const Divider(thickness: 2,),
              ListTile(
                  leading: const Icon(FontAwesomeIcons.cameraRetro),
                  title: Text("Take with Camera", style: Theme.of(context).textTheme.headlineSmall,),
                  onTap: ()=> Navigator.of(context).pop(ImageSource.camera)
              ),
              const Divider(thickness: 2,),
              ListTile(
                  leading: const Icon(FontAwesomeIcons.images),
                  title: Text("Select from Gallery", style: Theme.of(context).textTheme.headlineSmall,),
                  onTap: ()=> Navigator.of(context).pop(ImageSource.gallery)
              ),
              const Divider(thickness: 2,),
              SizedBox(
                  height: MediaQuery.of(context).size.height*0.2
              )
            ],

          ),
        ));
  }

  /*
  cropImage takes a File and forces a crop at a fixed ratio for display
   */
  static Future<CroppedFile?> cropImage(File imageFile) async{
    //create UI settings for the crop
    AndroidUiSettings androidUIsettingsForCrop() => AndroidUiSettings(
      toolbarTitle: "Crop watch image",
      aspectRatioPresets: [CropAspectRatioPreset.square],
    );

    IOSUiSettings iOSUIsettingsForCrop() => IOSUiSettings(
        title: "Crop Image",
      aspectRatioPresets: [CropAspectRatioPreset.square]

    );

    return await ImageCropper.platform.cropImage(sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 70,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [androidUIsettingsForCrop(),iOSUIsettingsForCrop()]
    );
  }

  //TODO: Update getImage() to utilise the imageExists() helper method to reduce code duplication
  //Helper method to return the watch image
  static Future<File?> getImage(Watches currentWatch, bool front) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = front? currentWatch.frontImagePath ?? "" : currentWatch.backImagePath ?? "";
    final exists = await File("${directory.path}/$name").exists();

    //if no image path has been saved or if the image cannot be found return null? otherwise give the path name
    return name == "" || !exists ? null : File("${directory.path}/$name");
  }

  static Future<bool> imageExists(Watches currentWatch, bool front) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = front? currentWatch.frontImagePath ?? "" : currentWatch.backImagePath ?? "";
    return await File("${directory.path}/$name").exists();
  }


  static Future<File> saveImage(String imagePath, Watches currentWatch, bool front) async {
    String name = "${currentWatch.key}_${currentWatch.manufacturer}_${currentWatch.model}";
    String perspective = front? "_front": "_back";
    //Get the directory and save the file
    var directory = await getApplicationDocumentsDirectory();
    //Check if image directory exists - if it doesn't then create it
    bool exists = await Directory("${directory.path}/img").exists();
    if(!exists) {
      await Directory("${directory.path}/img").create();
    }
    //ToDo: Get File extention by truncating the below and add to path
    //final name = basename(imagePath);

    //Check if file already exists - if so delete it
    if (front) {
      //Deal with front image scenario
      if(currentWatch.frontImagePath != null){
        bool exists = await File("${directory.path}${currentWatch.frontImagePath!}").exists();
        if(exists){
          await File("${directory.path}${currentWatch.frontImagePath!}").delete().catchError((Object error) => print("Failed to delete old image: $error"));

        }
      }
    } else{
      //Deal with back image scenario
      if(currentWatch.backImagePath != null){
        bool exists = await File("${directory.path}${currentWatch.backImagePath!}").exists();
        if(exists){
          await File("${directory.path}${currentWatch.backImagePath!}").delete().catchError((Object error) => print("Failed to delete old image: $error"));

        }
      }
    }
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    timestamp = timestamp.substring(timestamp.length-6);
    String safeName = name.replaceAll(RegExp('[^A-Za-z0-9]'), '');
    final String imgPath = '${directory.path}/img/$timestamp$safeName$perspective.jpg';
    final image = File(imgPath);
    if(front){
      currentWatch.frontImagePath = "/img/$timestamp$safeName$perspective.jpg";
    }else{
      currentWatch.backImagePath = "/img/$timestamp$safeName$perspective.jpg";
    }
    currentWatch.save();

    return File(imagePath).copy(image.path);
  }

  static deleteImages(Watches watch) async {
    final directory = await getApplicationDocumentsDirectory();
    final front = watch.frontImagePath ?? "";
    final frontExists = await File("${directory.path}/$front").exists();
    if(frontExists){
      await File("${directory.path}${watch.frontImagePath!}").delete().catchError((Object error) => print("Failed to delete old image: $error"));
    }
    final back = watch.backImagePath ?? "";
    final backExists = await File("${directory.path}/$back").exists();
    if(backExists){
      await File("${directory.path}${watch.backImagePath!}").delete().catchError((Object error) => print("Failed to delete old image: $error"));
    }

  }

  ///deleteAllImages() iterates through the open watchbox and deletes all associated images
  static deleteAllImages() async{
    final watchList = Boxes.getAllWatches();
    for(var watch in watchList){
      ImagesUtil.deleteImages(watch);
    }
  }

  /**
   * getImages() returns a list of all of the Images stored in the watchbox
   * //TODO: Extend this to include options for sold/archived/retired/wishlist
   */
  static Future<List<Image>> getImages() async{
    final watchList = Boxes.getCollectionWatches();
    List<Image> returnList = [];
    for(Watches watch in watchList){
      if(watch.frontImagePath != null && watch.frontImagePath != ""){
        File? currentImage = await ImagesUtil.getImage(watch, true);
        if(currentImage != null){
          returnList.add(Image.file(currentImage));
        }
      }
    }

    return returnList;
  }

  //TODO: Update this method to take a sort order as input
  static Future<List<Watches>> getWatchesWithImages(GallerySelectionEnum selection) async{
    var watchList = [];
    WatchOrder sortOrder = await WristCheckPreferences.getWatchOrder() ?? WatchOrder.watchbox;

    switch(selection) {
      case GallerySelectionEnum.watchbox:
        watchList = Boxes.getCollectionWatches();
        break;
      case GallerySelectionEnum.favourite:
        watchList = Boxes.getFavouriteWatches();
        break;
      case GallerySelectionEnum.sold:
        watchList = Boxes.getSoldWatches();
        break;
      case GallerySelectionEnum.archived:
        watchList = Boxes.getArchivedWatches();
        break;
      case GallerySelectionEnum.retired:
        watchList = Boxes.getRetiredWatches();
        break;
      case GallerySelectionEnum.preordered:
        watchList = Boxes.getPreOrderWatches();
        break;
      case GallerySelectionEnum.wishlist:
        watchList = Boxes.getWishlistWatches();
        break;
      case GallerySelectionEnum.all:
        watchList = Boxes.getAllNonArchivedWatches();
        break;
      default:
        watchList = Boxes.getCollectionWatches();
        break;
    }

    List<Watches> returnlist = [];
    for(Watches watch in watchList){
      if(await ImagesUtil.imageExists(watch, true)){
        returnlist.add(watch);
      }
    }
    //TODO: Implement sort method - use Boxes sort method for collection & favourites
    //Initially just sort by the users selected watchbox order preference
    returnlist = Boxes.sortWatchBox(returnlist, sortOrder);
    return returnlist;
  }


}