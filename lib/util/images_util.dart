import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/sync/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/controllers/sync_controller.dart';
import 'package:wristcheck/privacy/biometric_lock_wrapper.dart';
import 'package:wristcheck/model/enums/gallery_selection_enum.dart';
import 'package:wristcheck/model/enums/watchbox_ordering.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/gallery_image_item.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/widgets/images/image_card_widget.dart';

class ImgDirectoryExportResult {
  final int totalFilesScanned;
  final int fullImagesExported;
  final int thumbnailFallbacksExported;
  final int failedCount;
  final String? exportDirectoryPath;

  const ImgDirectoryExportResult({
    required this.totalFilesScanned,
    required this.fullImagesExported,
    required this.thumbnailFallbacksExported,
    required this.failedCount,
    required this.exportDirectoryPath,
  });

  int get totalExported => fullImagesExported + thumbnailFallbacksExported;
}

class OrphanedImageRelinkResult {
  final int slotsRestored;
  final int watchesUpdated;
  final int orphanedFilesFound;

  const OrphanedImageRelinkResult({
    required this.slotsRestored,
    required this.watchesUpdated,
    required this.orphanedFilesFound,
  });
}

class ImagesUtil {
  static String? appDocsPath;
  static final Map<String, File?> _imageFileCache = {};

  static Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    appDocsPath = directory.path;
    unawaited(ensureThumbnailsExist());
  }

  static void updateImageCache(String fullPath, File? file) {
    _imageFileCache[fullPath] = file;
  }

  static void clearImageCache([String? fullPath]) {
    if (fullPath != null) {
      _imageFileCache.remove(fullPath);
    } else {
      _imageFileCache.clear();
    }
  }

  static String getFullPath(String relativePath) {
    if (appDocsPath == null || relativePath.trim().isEmpty) return "";
    final cleanPath = relativePath.startsWith('/') ? relativePath : '/$relativePath';
    return "$appDocsPath$cleanPath";
  }

  static String getThumbPath(String relativePath) {
    if (appDocsPath == null || relativePath.trim().isEmpty) return "";
    final cleanPath = relativePath.startsWith('/') ? relativePath : '/$relativePath';
    final thumbName = cleanPath.replaceAll(RegExp(r'\.(jpg|png|jpeg)$', caseSensitive: false), '_thumb.png');
    return "$appDocsPath$thumbName";
  }

  static File? getImageSync(Watches currentWatch, int index) {
    final String name = getNamePath(currentWatch, index);
    final String cacheKey = getFullPath(name);
    if (cacheKey.isEmpty) return null;

    if (_imageFileCache.containsKey(cacheKey)) {
      return _imageFileCache[cacheKey];
    }

    final file = File(cacheKey);
    final exists = file.existsSync();
    final result = exists ? file : null;
    _imageFileCache[cacheKey] = result;
    return result;
  }

  static File? getThumbnailSync(Watches currentWatch, int index) {
    final String name = getNamePath(currentWatch, index);
    final String thumbKey = getThumbPath(name);
    if (thumbKey.isEmpty) return null;

    if (_imageFileCache.containsKey(thumbKey)) {
      final cached = _imageFileCache[thumbKey];
      if (cached != null) return cached;
    }

    final thumbFile = File(thumbKey);
    if (thumbFile.existsSync()) {
      _imageFileCache[thumbKey] = thumbFile;
      return thumbFile;
    }

    // Fallback to full image
    return getImageSync(currentWatch, index);
  }

  static Future<File?> generateThumbnailAsync(File sourceFile, String targetPath) async {
    try {
      if (!await sourceFile.exists()) return null;
      final bytes = await sourceFile.readAsBytes();
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: 400,
      );
      final frame = await codec.getNextFrame();
      final image = frame.image;
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      final thumbFile = File(targetPath);
      await thumbFile.parent.create(recursive: true);
      await thumbFile.writeAsBytes(byteData.buffer.asUint8List());
      _imageFileCache[targetPath] = thumbFile;
      return thumbFile;
    } catch (e) {
      debugPrint("Failed to generate thumbnail: $e");
      return null;
    }
  }

  static Future<void> ensureThumbnailsExist() async {
    if (appDocsPath == null) return;
    try {
      final watchList = Boxes.getAllWatches();
      for (var watch in watchList) {
        for (int i = 0; i < 3; i++) {
          final String name = getNamePath(watch, i);
          if (name.isNotEmpty) {
            final String sourcePath = getFullPath(name);
            final String thumbPath = getThumbPath(name);
            final thumbFile = File(thumbPath);
            if (!thumbFile.existsSync()) {
              final sourceFile = File(sourcePath);
              if (sourceFile.existsSync()) {
                await generateThumbnailAsync(sourceFile, thumbPath);
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error generating background thumbnails: $e");
    }
  }

  static List<File?> getAllImagesSync(Watches currentWatch) {
    if (appDocsPath == null) return [null, null, null];
    List<File?> returnList = [];
    List<String> nameList = [
      currentWatch.frontImagePath ?? "",
      currentWatch.backImagePath ?? "",
      currentWatch.lumeImagePath ?? "",
    ];

    for (String imagePath in nameList) {
      if (imagePath.isEmpty) {
        returnList.add(null);
      } else {
        final String cacheKey = getFullPath(imagePath);
        if (_imageFileCache.containsKey(cacheKey)) {
          returnList.add(_imageFileCache[cacheKey]);
        } else {
          final file = File(cacheKey);
          final exists = file.existsSync();
          final result = exists ? file : null;
          _imageFileCache[cacheKey] = result;
          returnList.add(result);
        }
      }
    }
    return returnList;
  }

  /*
  pickImage takes in an ImageSource (camera or gallery) and a Watch and allows the user to select an image.
  the path to this is then saved to the given watch as it's display image, after forcing it to be cropped to the
  correct aspect ratio.
  It also
   */
  static pickAndSaveImage({
    required ImageSource source,
    required Watches currentWatch,
    required int index
  }) async {
    return await BiometricLockWrapper.suppressLockDuring(() async {
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
          await ImagesUtil.saveImage(croppedImage.path, currentWatch, index);

        }
      } on PlatformException catch (e) {
        print('Failed to pick image: $e');
        //ToDo: Implement error handling
        return null;
      }
    });
  }

  static Future<File?> pickImage({
    required ImageSource source,
  }) async {
    return await BiometricLockWrapper.suppressLockDuring(() async {
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
    });
  }


  /*
  Calls a bottom modal sheet allowing user to select if the source of their image should be
  from the camera or the gallery
   */
  static Future<ImageSource?> imageSourcePopUp(BuildContext context) async {
    return showModalBottomSheet(context: context,
        builder: (context) => Material(
          color: Get.isDarkMode? Colors.grey[600] : Colors.white38,
          borderRadius: BorderRadius.circular(15),
          clipBehavior: Clip.antiAlias,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10,),
                const Divider(thickness: 2,),
                ListTile(
                    leading: const FaIcon(FontAwesomeIcons.cameraRetro),
                    title: Text(AppLocalizations.of(Get.context!)!.takeWithCamera, style: Theme.of(context).textTheme.headlineSmall,),
                    onTap: ()=> Navigator.of(context).pop(ImageSource.camera)
                ),
                const Divider(thickness: 2,),
                ListTile(
                    leading: const FaIcon(FontAwesomeIcons.images),
                    title: Text(AppLocalizations.of(Get.context!)!.selectFromGallery, style: Theme.of(context).textTheme.headlineSmall,),
                    onTap: ()=> Navigator.of(context).pop(ImageSource.gallery)
                ),
                const Divider(thickness: 2,),
                SizedBox(
                    height: MediaQuery.of(context).size.height*0.2
                )
              ],

            ),
          ),
        ));
  }

  /*
  cropImage takes a File and forces a crop at a fixed ratio for display
   */
  static Future<CroppedFile?> cropImage(File imageFile) async{
    //create UI settings for the crop
    AndroidUiSettings androidUIsettingsForCrop() => AndroidUiSettings(
      toolbarTitle: AppLocalizations.of(Get.context!)!.cropImage,
      aspectRatioPresets: [CropAspectRatioPreset.square],
    );

    IOSUiSettings iOSUIsettingsForCrop() => IOSUiSettings(
        title: AppLocalizations.of(Get.context!)!.cropImage,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      cancelButtonTitle: AppLocalizations.of(Get.context!)!.cancel,
      doneButtonTitle: AppLocalizations.of(Get.context!)!.done

    );

    return await ImageCropper.platform.cropImage(sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 70,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [androidUIsettingsForCrop(),iOSUIsettingsForCrop()]
    );
  }

  static String getNamePath(Watches currentWatch, int index){
    String name;

    switch(index){
      case(0):
        name = currentWatch.frontImagePath ?? "";
        break;
      case(1):
        name = currentWatch.backImagePath ?? "";
        break;
      case(2):
        name = currentWatch.lumeImagePath ?? "";
        break;
      default: name = currentWatch.frontImagePath ?? "";
    }
    return name;
  }
  //TODO: Update getImage() to utilise the imageExists() helper method to reduce code duplication
  //Helper method to return the watch image
  static Future<File?> getImage(Watches currentWatch, int index) async {
    final directory = await getApplicationDocumentsDirectory();
    final String name = getNamePath(currentWatch, index);
    final exists = await File("${directory.path}/$name").exists();

    //if no image path has been saved or if the image cannot be found return null? otherwise give the path name
    return name == "" || !exists ? null : File("${directory.path}/$name");
  }

  //Helper method to return the watch image
  static Future<List<File?>> getAllImages(Watches currentWatch) async {
    List<File?> returnList = [];
    List<String> nameList= [];
    final directory = await getApplicationDocumentsDirectory();
    //Order is always front, back, lume
    nameList.add(currentWatch.frontImagePath ?? "");
    nameList.add(currentWatch.backImagePath ?? "");
    nameList.add(currentWatch.lumeImagePath ?? "");

    for(String imagePath in nameList){
      //bool exists = await File("${directory.path}/$imagePath").exists();
      returnList.add(await File("${directory.path}/$imagePath").exists()? File("${directory.path}/$imagePath") : null);
    }
    return returnList;
  }

  static Future<bool> imageExists(Watches currentWatch, int index) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = getNamePath(currentWatch, index);
    return await File("${directory.path}/$name").exists();
  }

  /*
  Takes a watch and image index, deletes the given image, resets the primary image to
  the first and updates the controller to ensure any UI is updated.
   */
  static Future<bool> deleteImageAndUpdateView(Watches currentWatch, int index) async {
    final watchViewController = Get.put(WatchViewController());
    //1. Delete the image
    await ImagesUtil.deleteImageByIndex(currentWatch, index);
    //2. If the image was primary, set primary image to zero
    int primaryIndex = currentWatch.primaryImageIndex ?? 0;
    if(index == primaryIndex){
      WatchMethods.setPrimaryImage(currentWatch, 0);
    }
    //3. Update the controller
    watchViewController.updateImageListIndex(ImageCardWidget(image: null),  index);
    return true;
  }


  static Future<File> saveImage(
    String imagePath,
    Watches currentWatch,
    int index, {
    bool triggerSync = true,
  }) async {
    String name = "${currentWatch.key}_${currentWatch.manufacturer}_${currentWatch.model}";
    String perspective;

    switch(index){
      case(0):
        perspective = "_front";
        break;
      case(1):
        perspective = "_back";
        break;
      case(2):
        perspective = "_lume";
        break;
      default:
        perspective = "_front";
    }

    //Get the directory and save the file
    var directory = await getApplicationDocumentsDirectory();
    //Check if image directory exists - if it doesn't then create it
    bool exists = await Directory("${directory.path}/img").exists();
    if(!exists) {
      await Directory("${directory.path}/img").create();
    }

    //Check if file already exists - if so delete it
    final pathName = getNamePath(currentWatch, index);
    if(pathName.isNotEmpty){
      final cleanOldPath = pathName.startsWith('/') ? pathName : '/$pathName';
      final oldFile = File("${directory.path}$cleanOldPath");
      if(await oldFile.exists()){
        try {
          await oldFile.delete();
        } catch (error) {
          debugPrint("Failed to delete old image: $error");
        }
      }
    }

    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    timestamp = timestamp.substring(timestamp.length-6);
    String safeName = name.replaceAll(RegExp('[^A-Za-z0-9]'), '');
    final String relativePath = '/img/$timestamp$safeName$perspective.jpg';
    final String imgPath = '${directory.path}$relativePath';
    final image = File(imgPath);

    // Copy the file to its final destination before persisting metadata and starting sync
    final copiedFile = await File(imagePath).copy(image.path);

    switch(index){
      case(0):
        currentWatch.frontImagePath = relativePath;
        currentWatch.frontImageSynced = false;
        break;
      case(1):
        currentWatch.backImagePath = relativePath;
        currentWatch.backImageSynced = false;
        break;
      case(2):
        currentWatch.lumeImagePath = relativePath;
        currentWatch.lumeImageSynced = false;
        break;
    }

    currentWatch.ensureInitialized();
    currentWatch.isDirty = true;
    currentWatch.updatedAt = DateTime.now().toUtc();
    await currentWatch.save();

    updateImageCache(imgPath, copiedFile);
    final String thumbPath = imgPath.replaceAll(RegExp(r'\.(jpg|png|jpeg)$'), '_thumb.png');
    unawaited(generateThumbnailAsync(copiedFile, thumbPath));

    if (triggerSync) {
      unawaited(SyncService.syncData());
    }
    return copiedFile;
  }

  static Future<void> deleteImageByIndex(Watches watch, int index) async {
    final directory = await getApplicationDocumentsDirectory();

    switch(index){
      case(0):
        final front = watch.frontImagePath ?? "";
        if (front.isNotEmpty) {
          final cleanPath = front.startsWith('/') ? front : '/$front';
          final file = File("${directory.path}$cleanPath");
          if (await file.exists()) {
            await file.delete().catchError((Object error) => print("Failed to delete old image: $error"));
          }
          clearImageCache("${directory.path}$cleanPath");
        }
        watch.frontImagePath = "";
        watch.frontImageSynced = true;
        break;
      case(1):
        final back = watch.backImagePath ?? "";
        if (back.isNotEmpty) {
          final cleanPath = back.startsWith('/') ? back : '/$back';
          final file = File("${directory.path}$cleanPath");
          if (await file.exists()) {
            await file.delete().catchError((Object error) => print("Failed to delete old image: $error"));
          }
          clearImageCache("${directory.path}$cleanPath");
        }
        watch.backImagePath = "";
        watch.backImageSynced = true;
        break;
      case(2):
        final lume = watch.lumeImagePath ?? "";
        if (lume.isNotEmpty) {
          final cleanPath = lume.startsWith('/') ? lume : '/$lume';
          final file = File("${directory.path}$cleanPath");
          if (await file.exists()) {
            await file.delete().catchError((Object error) => print("Failed to delete old image: $error"));
          }
          clearImageCache("${directory.path}$cleanPath");
        }
        watch.lumeImagePath = "";
        watch.lumeImageSynced = true;
        break;
    }

    watch.ensureInitialized();
    watch.isDirty = true;
    watch.updatedAt = DateTime.now().toUtc();
    await watch.save();
    unawaited(SyncService.syncData());
  }

  static Future<void> deleteImages(Watches watch) async {
    final directory = await getApplicationDocumentsDirectory();
    final front = watch.frontImagePath ?? "";
    if (front.isNotEmpty) {
      final cleanFront = front.startsWith('/') ? front : '/$front';
      final frontFile = File("${directory.path}$cleanFront");
      if (await frontFile.exists()) {
        await frontFile.delete().catchError((Object error) => print("Failed to delete old image: $error"));
      }
      clearImageCache("${directory.path}$cleanFront");
    }
    final back = watch.backImagePath ?? "";
    if (back.isNotEmpty) {
      final cleanBack = back.startsWith('/') ? back : '/$back';
      final backFile = File("${directory.path}$cleanBack");
      if (await backFile.exists()) {
        await backFile.delete().catchError((Object error) => print("Failed to delete old image: $error"));
      }
      clearImageCache("${directory.path}$cleanBack");
    }
    final lume = watch.lumeImagePath ?? "";
    if (lume.isNotEmpty) {
      final cleanLume = lume.startsWith('/') ? lume : '/$lume';
      final lumeFile = File("${directory.path}$cleanLume");
      if (await lumeFile.exists()) {
        await lumeFile.delete().catchError((Object error) => print("Failed to delete old image: $error"));
      }
      clearImageCache("${directory.path}$cleanLume");
    }

    watch.frontImagePath = "";
    watch.frontImageSynced = true;
    watch.backImagePath = "";
    watch.backImageSynced = true;
    watch.lumeImagePath = "";
    watch.lumeImageSynced = true;
    watch.ensureInitialized();
    watch.isDirty = true;
    watch.updatedAt = DateTime.now().toUtc();
    if (watch.isInBox) {
      await watch.save();
    }
    unawaited(SyncService.syncData());
  }

  ///deleteAllImages() iterates through the open watchbox and deletes all associated images
  static Future<void> deleteAllImages() async {
    _imageFileCache.clear();
    final watchList = Boxes.getAllWatches();
    for(var watch in watchList){
      await ImagesUtil.deleteImages(watch);
    }
  }

  //TODO: getImages() doesn't seem to be used - check if it can be removed as unnecessary
  /**
   * getImages() returns a list of all of the Images stored in the watchbox
   * //TODO: Extend this to include options for sold/archived/retired/wishlist
   * //TODO: Implement index to allow pictures 2 & 3 to be returned
   */
  static Future<List<Image>> getImages() async{
    final watchList = Boxes.getCollectionWatches();
    List<Image> returnList = [];
    for(Watches watch in watchList){
      if(watch.frontImagePath != null && watch.frontImagePath != ""){
        File? currentImage = await ImagesUtil.getImage(watch, 0);
        if(currentImage != null){
          returnList.add(Image.file(currentImage));
        }
      }
    }

    return returnList;
  }

  static Future<List<GalleryImageItem>> getGalleryImageItems(GallerySelectionEnum selection) async {
    if (appDocsPath == null) {
      await init();
    }

    List<Watches> watchList = [];
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
      case GallerySelectionEnum.onLoan:
        watchList = Boxes.getOnLoanWatches();
        break;
      case GallerySelectionEnum.all:
        watchList = Boxes.getAllNonArchivedWatches();
        break;
    }

    watchList = Boxes.sortWatchBox(watchList, sortOrder);

    List<GalleryImageItem> returnList = [];

    for (var watch in watchList) {
      for (int i = 0; i < 3; i++) {
        final File? file = getImageSync(watch, i);
        if (file != null) {
          returnList.add(
            GalleryImageItem(
              watch: watch,
              imageIndex: i,
              imageFile: file,
            ),
          );
        }
      }
    }

    return returnList;
  }

  static Future<List<Watches>> getWatchesWithImages(GallerySelectionEnum selection) async {
    final items = await getGalleryImageItems(selection);
    List<Watches> returnList = [];
    for (var item in items) {
      if (!returnList.contains(item.watch)) {
        returnList.add(item.watch);
      }
    }
    return returnList;
  }

  static addImageViaController(int index, BuildContext context, Watches? watch) async {
    final watchViewController = Get.put(WatchViewController());

    var imageSource = await ImagesUtil.imageSourcePopUp(context);
    if (imageSource == null) return;
    //Split this method depending on status
    if (watchViewController.watchViewState.value != WatchViewEnum.add) {
      await  ImagesUtil.pickAndSaveImage(source: imageSource, currentWatch: watch!, index: index);
      watchViewController.updateImageListIndex(ImageCardWidget(image:  await ImagesUtil.getImage(watch, index)),  index);
    }
    else {
      var tempImage = await ImagesUtil.pickImage(source: imageSource);
      watchViewController.updateImage(tempImage, index);
      watchViewController.updateImageListIndex(ImageCardWidget(image: tempImage), index);
    }
  }

  // --- Avatar Methods ---

  static Future<File?> getLocalAvatar() async {
    if (appDocsPath == null) return null;
    final file = File("$appDocsPath/avatar/avatar.jpg");
    return file.existsSync() ? file : null;
  }

  static Future<void> syncAvatar(String remoteUrl) async {
    if (appDocsPath == null || remoteUrl.isEmpty) return;
    
    // Check if the URL has changed exactly (including the timestamp ?t=...)
    final lastUrl = WristCheckPreferences.getLastAvatarUrl();
    final file = File("$appDocsPath/avatar/avatar.jpg");
    
    if (lastUrl == remoteUrl && file.existsSync()) {
      // Avatar URL hasn't changed and we already have the file locally, no need to download
      return;
    }

    try {
      final request = await HttpClient().getUrl(Uri.parse(remoteUrl));
      final response = await request.close();
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final avatarDir = Directory("${directory.path}/avatar");
        if (!await avatarDir.exists()) {
          await avatarDir.create();
        }
        final file = File("${avatarDir.path}/avatar.jpg");
        
        // If an old avatar exists, explicitly delete it before piping the new bytes
        if (await file.exists()) {
          await file.delete();
        }
        
        await response.pipe(file.openWrite());
        
        // Evict from flutter cache explicitly
        PaintingBinding.instance.imageCache.evict(FileImage(file));
        
        // Save the new URL to preferences so we don't download it again
        await WristCheckPreferences.setLastAvatarUrl(remoteUrl);

        if (Get.isRegistered<SyncController>()) {
          SyncController.to.loadUserAvatar();
        }
      }
    } catch (e) {
      print("Failed to sync avatar: $e");
    }
  }

  // --- Developer Recovery & Export Methods ---

  /// Exports all image files found directly inside the app's `/img` folder to a subfolder
  /// inside [targetDirectoryPath], independent of Hive watch image paths.
  /// When [includeFallbackThumbnails] is true, `_thumb.png` files are also exported if their
  /// corresponding full-size image file is missing.
  static Future<ImgDirectoryExportResult> exportAllImgDirectoryFiles(
    String targetDirectoryPath, {
    bool includeFallbackThumbnails = true,
    Directory? imgDirOverride,
  }) async {
    final Directory imgDir = imgDirOverride ??
        Directory('${(await getApplicationDocumentsDirectory()).path}/img');

    if (!await imgDir.exists()) {
      return const ImgDirectoryExportResult(
        totalFilesScanned: 0,
        fullImagesExported: 0,
        thumbnailFallbacksExported: 0,
        failedCount: 0,
        exportDirectoryPath: null,
      );
    }

    final List<File> allFiles = (await imgDir.list().toList())
        .whereType<File>()
        .toList()
      ..sort((a, b) => p.basename(a.path).compareTo(p.basename(b.path)));

    final RegExp thumbSuffix = RegExp(r'_thumb\.png$', caseSensitive: false);
    final RegExp imageExt = RegExp(r'\.(jpg|jpeg|png)$', caseSensitive: false);

    final List<File> fullImages = [];
    final List<File> thumbImages = [];
    final Set<String> fullBaseNames = {};

    for (final file in allFiles) {
      final name = p.basename(file.path);
      if (thumbSuffix.hasMatch(name)) {
        thumbImages.add(file);
      } else if (imageExt.hasMatch(name)) {
        fullImages.add(file);
        fullBaseNames.add(name.replaceFirst(imageExt, '').toLowerCase());
      }
    }

    final List<File> fallbackThumbs = [];
    if (includeFallbackThumbnails) {
      for (final thumb in thumbImages) {
        final name = p.basename(thumb.path);
        final baseName = name.replaceFirst(thumbSuffix, '').toLowerCase();
        if (!fullBaseNames.contains(baseName)) {
          fallbackThumbs.add(thumb);
        }
      }
    }

    if (fullImages.isEmpty && fallbackThumbs.isEmpty) {
      return ImgDirectoryExportResult(
        totalFilesScanned: allFiles.length,
        fullImagesExported: 0,
        thumbnailFallbacksExported: 0,
        failedCount: 0,
        exportDirectoryPath: null,
      );
    }

    final exportSubdirName =
        'WristCheck_Img_Export_${DateTime.now().millisecondsSinceEpoch}';
    final Directory exportDir = Directory(p.join(targetDirectoryPath, exportSubdirName));
    await exportDir.create(recursive: true);

    int fullExported = 0;
    int thumbExported = 0;
    int failed = 0;

    for (final file in fullImages) {
      try {
        final destPath = p.join(exportDir.path, p.basename(file.path));
        await file.copy(destPath);
        fullExported++;
      } catch (e) {
        debugPrint('ImagesUtil: Failed to export ${file.path}: $e');
        failed++;
      }
    }

    for (final thumb in fallbackThumbs) {
      try {
        final destPath = p.join(exportDir.path, p.basename(thumb.path));
        await thumb.copy(destPath);
        thumbExported++;
      } catch (e) {
        debugPrint('ImagesUtil: Failed to export fallback thumbnail ${thumb.path}: $e');
        failed++;
      }
    }

    return ImgDirectoryExportResult(
      totalFilesScanned: allFiles.length,
      fullImagesExported: fullExported,
      thumbnailFallbacksExported: thumbExported,
      failedCount: failed,
      exportDirectoryPath: exportDir.path,
    );
  }

  /// Scans `/img` for unreferenced `.jpg`/`.jpeg`/`.png` files (excluding `_thumb.png`)
  /// and matches them back to watches whose corresponding front/back/lume path is empty.
  static Future<OrphanedImageRelinkResult> relinkOrphanedImages({
    Directory? imgDirOverride,
    bool triggerSync = true,
  }) async {
    final Directory imgDir = imgDirOverride ??
        Directory('${(await getApplicationDocumentsDirectory()).path}/img');

    if (!await imgDir.exists()) {
      return const OrphanedImageRelinkResult(
        slotsRestored: 0,
        watchesUpdated: 0,
        orphanedFilesFound: 0,
      );
    }

    final List<Watches> watches = Boxes.getAllWatches();
    final Set<String> referencedNamesLower = {};

    for (final watch in watches) {
      for (final path in [watch.frontImagePath, watch.backImagePath, watch.lumeImagePath]) {
        if (path != null && path.trim().isNotEmpty) {
          final fileName = p.basename(path.trim()).toLowerCase();
          if (fileName.isNotEmpty) {
            referencedNamesLower.add(fileName);
          }
        }
      }
    }

    final RegExp thumbSuffix = RegExp(r'_thumb\.png$', caseSensitive: false);
    final RegExp imageExt = RegExp(r'\.(jpg|jpeg|png)$', caseSensitive: false);

    final List<File> orphanedFiles = (await imgDir.list().toList())
        .whereType<File>()
        .where((file) {
          final name = p.basename(file.path);
          return imageExt.hasMatch(name) &&
              !thumbSuffix.hasMatch(name) &&
              !referencedNamesLower.contains(name.toLowerCase());
        })
        .toList();

    // Prefer newest files first if multiple candidates exist for a watch/slot
    orphanedFiles.sort((a, b) {
      try {
        return b.lastModifiedSync().compareTo(a.lastModifiedSync());
      } catch (_) {
        return p.basename(b.path).compareTo(p.basename(a.path));
      }
    });

    final Set<String> claimedFileNamesLower = {};
    int slotsRestored = 0;
    int watchesUpdated = 0;

    String? findMatchForSlot({
      required Watches watch,
      required String safeBrandModel,
      required String slotLabel,
    }) {
      if (safeBrandModel.isEmpty) return null;

      final String keyPart = watch.key != null ? RegExp.escape(watch.key.toString()) : '';
      final String brandModelPart = RegExp.escape(safeBrandModel);

      // 1. Prefer exact match including Hive key: <6-digit-ts><key><manufacturer><model>_<slot>
      if (keyPart.isNotEmpty) {
        final exactPattern = RegExp(
          '^\\d{6}$keyPart${brandModelPart}_$slotLabel\$',
          caseSensitive: false,
        );
        for (final file in orphanedFiles) {
          final fileName = p.basename(file.path);
          final lowerName = fileName.toLowerCase();
          if (claimedFileNamesLower.contains(lowerName)) continue;
          final baseNoExt = fileName.replaceFirst(imageExt, '');
          if (exactPattern.hasMatch(baseNoExt)) {
            claimedFileNamesLower.add(lowerName);
            return fileName;
          }
        }
      }

      // 2. Fallback match ignoring Hive key (if keys shifted after restore)
      final fallbackPattern = RegExp(
        '^\\d{6}\\d*${brandModelPart}_$slotLabel\$',
        caseSensitive: false,
      );
      for (final file in orphanedFiles) {
        final fileName = p.basename(file.path);
        final lowerName = fileName.toLowerCase();
        if (claimedFileNamesLower.contains(lowerName)) continue;
        final baseNoExt = fileName.replaceFirst(imageExt, '');
        if (fallbackPattern.hasMatch(baseNoExt)) {
          claimedFileNamesLower.add(lowerName);
          return fileName;
        }
      }

      return null;
    }

    for (final watch in watches) {
      final safeBrandModel = '${watch.manufacturer}${watch.model}'
          .replaceAll(RegExp('[^A-Za-z0-9]'), '')
          .toLowerCase();
      if (safeBrandModel.isEmpty) continue;

      bool watchModified = false;

      if (watch.frontImagePath == null || watch.frontImagePath!.trim().isEmpty) {
        final matched = findMatchForSlot(
          watch: watch,
          safeBrandModel: safeBrandModel,
          slotLabel: 'front',
        );
        if (matched != null) {
          final relPath = '/img/$matched';
          watch.frontImagePath = relPath;
          watch.frontImageSynced = false;
          clearImageCache(getFullPath(relPath));
          slotsRestored++;
          watchModified = true;
        }
      }

      if (watch.backImagePath == null || watch.backImagePath!.trim().isEmpty) {
        final matched = findMatchForSlot(
          watch: watch,
          safeBrandModel: safeBrandModel,
          slotLabel: 'back',
        );
        if (matched != null) {
          final relPath = '/img/$matched';
          watch.backImagePath = relPath;
          watch.backImageSynced = false;
          clearImageCache(getFullPath(relPath));
          slotsRestored++;
          watchModified = true;
        }
      }

      if (watch.lumeImagePath == null || watch.lumeImagePath!.trim().isEmpty) {
        final matched = findMatchForSlot(
          watch: watch,
          safeBrandModel: safeBrandModel,
          slotLabel: 'lume',
        );
        if (matched != null) {
          final relPath = '/img/$matched';
          watch.lumeImagePath = relPath;
          watch.lumeImageSynced = false;
          clearImageCache(getFullPath(relPath));
          slotsRestored++;
          watchModified = true;
        }
      }

      if (watchModified) {
        watch.ensureInitialized();
        watch.isDirty = true;
        watch.updatedAt = DateTime.now().toUtc();
        await watch.save();
        watchesUpdated++;
      }
    }

    if (slotsRestored > 0 && triggerSync) {
      unawaited(SyncService.syncData(manualSync: true));
    }

    return OrphanedImageRelinkResult(
      slotsRestored: slotsRestored,
      watchesUpdated: watchesUpdated,
      orphanedFilesFound: orphanedFiles.length,
    );
  }

}