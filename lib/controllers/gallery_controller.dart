import 'package:get/get.dart';
import 'package:wristcheck/model/enums/gallery_selection_enum.dart';

class GalleryController extends GetxController{

  final gallerySelection = GallerySelectionEnum.watchbox.obs;

  updateGallerySelection(GallerySelectionEnum selection){
    gallerySelection(selection);
  }

}