import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';

class ImagesUtil {

  /*
  pickImage takes in an ImageSource (camera or gallery) and a Watch and allows the user to select an image.
  the path to this is then saved to the given watch as it's display image, after forcing it to be cropped to the
  correct aspect ratio.
  It also
  //ToDo: Refactor to allow both front and caseback images!
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
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text("Take with Camera"),
                onTap: ()=> Navigator.of(context).pop(ImageSource.camera)
            ),
            ListTile(
                leading: const Icon(Icons.camera_roll_outlined),
                title: const Text("Select from Gallery"),
                onTap: ()=> Navigator.of(context).pop(ImageSource.gallery)
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height*0.2
            )
          ],

        ));
  }

  /*
  cropImage takes a File and forces a crop at a fixed ratio for display
   */
  static Future<CroppedFile?> cropImage(File imageFile) async{
    //create UI settings for the crop
    AndroidUiSettings androidUIsettingsForCrop() => AndroidUiSettings(
      toolbarTitle: "Crop watch image",
    );

    IOSUiSettings iOSUIsettingsForCrop() => IOSUiSettings(
        title: "Crop Image"
    );

    return await ImageCropper.platform.cropImage(sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.square],
        compressQuality: 70,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [androidUIsettingsForCrop(),iOSUIsettingsForCrop()]
    );
  }

  //Helper method to return the watch image
  static Future<File?> getImage(Watches currentWatch, bool front) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = front? currentWatch.frontImagePath ?? "" : currentWatch.backImagePath ?? "";
    final exists = await File("${directory.path}/$name").exists();

    //if no image path has been saved or if the image cannot be found return null? otherwise give the path name
    return name == "" || !exists ? null : File("${directory.path}/$name");
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
    final String imgPath = '${directory.path}/img/$timestamp$name$perspective.jpg';
    final image = File(imgPath);
    if(front){
      currentWatch.frontImagePath = "/img/$timestamp$name$perspective.jpg";
    }else{
      currentWatch.backImagePath = "/img/$timestamp$name$perspective.jpg";
    }
    currentWatch.save();

    return File(imagePath).copy(image.path);
  }

  static deleteImages(Watches watch) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = watch.frontImagePath ?? "";
    final exists = await File("${directory.path}/$name").exists();
    if(exists){
      await File("${directory.path}${watch.frontImagePath!}").delete().catchError((Object error) => print("Failed to delete old image: $error"));
    }

  }

  // static saveImagepathToDatabase(String imagePath, Watches currentWatch, String name) async{
  //   //final name = basename(imagePath);
  //   currentWatch.frontImagePath = "/img/$name";
  //   currentWatch.save();
  // }

  // /// saveImage() calls saveImageToDirectory() to firstly save the image to the device directory
  // /// and then secondly calls saveImagepathToDatabase() to ensure the watch object knows the new image location.
  // /// Prefer to call this method over the individual methods unless the watch object is not yet created
  // static saveImage(String imagePath, Watches currentWatch, String name) async {
  //   await saveImageToDirectory(imagePath, name).then((_) => saveImagepathToDatabase(imagePath, currentWatch, name));
  // }


}