import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wristcheck/util/string_extension.dart';

class BackupRestoreMethods {
  static Future<String?> pickBackupLocation() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) {
      return null;
    } else {
      return selectedDirectory;
    }
  }

  static Future<ShareResult> shareBackup() async {
    final box = Boxes.getWatches();
    final boxPath = box.path;
    var result = await Share.shareXFiles([XFile(boxPath!)]);

    if (result.status == ShareResultStatus.success) {
      WristCheckDialogs.getWatchboxBackupSuccessDialog();
    }

    return result;
  }

  static Future<void> backupWatchBox<Watches>(String backupPath) async {

    final box = Boxes.getWatches();
    final boxPath = box.path;

    try {
      bool _errored = false;
      backupPath = backupPath+"/watchbox.hive";
      await File(boxPath!).copy(backupPath).onError((error, stackTrace) {
        _errored = true;
        WristCheckDialogs.getBackupFailedDialog(error.toString());
        throw Exception();
      }
      ).whenComplete(() => _errored? print("errored"):File(backupPath).exists().then((_) => WristCheckDialogs.getBackupSuccessDialog()));

    } catch(e) {
      print("Caught exception: $e");
    } 

  }

  static restoreWatchBox(File watchbox) async {
    final box = Boxes.getWatches();
    final _boxPath = box.path;
    bool _errored = false;
    try{
      await watchbox.copy(_boxPath!).onError((error, stackTrace) => WristCheckDialogs.getRestoreFailedDialog(error.toString()));
    } catch(e) {
      _errored = true;
      WristCheckDialogs.getRestoreFailedDialog(e.toString());
    } finally{
      _errored? print("Finally called") : WristCheckDialogs.getRestoreSuccessDialog();
    }
  }

  /*
  restoreImages() is in DRAFT - the aim is to iterate over a folder of backed up images and restore them to the app directory
  Further work and understanding is required to progress, but saving for now
   */
  // static restoreImages() async {
  //   try {
  //     String? dirPath = await FilePicker.platform.getDirectoryPath();
  //     print("picked directory $dirPath");
  //     if(dirPath != null){
  //       int count = 0;
  //       //List dirList = Directory(dirPath!).listSync().where((element) => element is File).toList();
  //       List dirList = Directory(dirPath!).listSync();
  //       print("got directory list - size: ${dirList.length}");
  //       for(File file in dirList){
  //         //check filetype
  //         print("trying to iterate files");
  //         String fileName = basename(file.path);
  //         print("File name: $fileName");
  //         if(fileName.isWCJpg){
  //           count++;
  //         }
  //       }
  //       Get.defaultDialog(
  //         title: "Image Backup",
  //         middleText: "Found $count images"
  //       );
  //     } else {
  //       //handle null directory
  //     }
  //   } on Exception catch (e) {
  //     Get.defaultDialog(
  //       title: "Something went wrong",
  //       middleText: "Failed to access files, the following error was returned:\n"
  //           "${e.toString()}"
  //     );
  //   }
  // }



  /*
  This method is called during the RESTORE process to select the backup file to restore from.
  Updated to clear any file cache before selecting the file to ensure an old version of the watchbox
  isn't utilised for the restore.
   */
  static Future<File?> pickBackupFile() async {
    FilePicker.platform.clearTemporaryFiles();
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File? file;

    if (result != null) {
      String fileName = basename(result.files.single.path!);
      fileName == "watchbox.hive"? file = File(result.files.single.path!): WristCheckDialogs.getIncorrectFilenameDialog(fileName);
    }
    return file;
  }

  static Future<ShareResult?> imageBackup() async {
    final box = Boxes.getAllWatches();
    final directory = await getApplicationDocumentsDirectory();
    // final boxPath = box.path;
    // var result = await Share.shareXFiles([XFile(boxPath!)]);
    List<XFile> shareList = [];
    for(Watches watch in box){
      var frontImage = "${directory.path}${watch.frontImagePath}";
      var backImage = "${directory.path}${watch.backImagePath}";
      final frontExists = await File(frontImage).exists();
      final backExists = await File(backImage).exists();

      if(frontExists){ shareList.add(XFile(frontImage));}
      if(backExists){ shareList.add(XFile(backImage));}
    }


    var result;
    if (shareList.isNotEmpty) {
      try {
        result = await Share.shareXFiles(shareList);
        int imgCount = shareList.length;

        if (result.status == ShareResultStatus.success) {
          WristCheckDialogs.getImageBackupSuccessDialog(imgCount);
        }
      } on Exception catch (e) {
        WristCheckDialogs.getFailedToBackupImages(e);
      }
    } else {
      WristCheckDialogs.getNoImagesFoundDialog();
      result = null;
    }

    return result;
  }

}