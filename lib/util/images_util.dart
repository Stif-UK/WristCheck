import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagesUtil {

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
}