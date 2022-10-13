import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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
    required Watches currentWatch
  }) async {
    //required Future<File> Function(File file) cropImage}
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return null;

      final imageTemporary = File(image.path);
      var croppedImage = await ImagesUtil.cropImage(imageTemporary);
      File returnImage;
      // croppedImage == null? var returnImage = File(croppedImage.path) : return null;
      if(croppedImage == null){
        return null;
      } else{
        returnImage = File(croppedImage.path);
        await ImagesUtil.saveImage(croppedImage.path, currentWatch);

      }


      // return cropSquareImage(File(imageTemporary.path)) as File;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
      //ToDo: Implement error handling
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
  static Future<File?> getImage(Watches currentWatch) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = currentWatch.frontImagePath ?? "";
    final exists = await File("${directory.path}/$name").exists();

    //if no image path has been saved or if the image cannot be found return null? otherwise give the path name
    return name == "" || !exists ? null : File("${directory.path}/$name");
  }

  //Helper method to save the watch image to the file system and add a reference
  //to the instance variable of the given watch
  static Future<File> saveImageToDirectory(String imagePath) async {
    //Get the directory and save the file
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    print("creating image file at ${directory.path}/$name");

    return File(imagePath).copy(image.path);
  }

  static saveImagepathToDatabase(String imagePath, Watches currentWatch) async{
    final name = basename(imagePath);
    currentWatch.frontImagePath = "/$name";
    currentWatch.save();
  }

  /// saveImage() calls saveImageToDirectory() to firstly save the image to the device directory
  /// and then secondly calls saveImagepathToDatabase() to ensure the watch object knows the new image location.
  /// Prefer to call this method over the individual methods unless the watch object is not yet created
  static saveImage(String imagePath, Watches currentWatch) async {
    await saveImageToDirectory(imagePath).then((_) => saveImagepathToDatabase(imagePath, currentWatch));
  }


}