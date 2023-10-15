import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wristcheck/util/images_util.dart';

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


  static Future<File?> pickBackupFile() async {
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

      print(frontImage);
      print(backImage);
      if(frontExists){ shareList.add(XFile(frontImage));}
      if(backExists){ shareList.add(XFile(backImage));}
    }
    print(shareList);

    var result;
    if (shareList.isNotEmpty) {
      try {
        result = await Share.shareXFiles(shareList);

        if (result.status == ShareResultStatus.success) {
          WristCheckDialogs.getImageBackupSuccessDialog();
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