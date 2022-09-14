import 'dart:io';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/copy/dialogs.dart';

class BackupRestoreMethods {
  static Future<String?> pickBackupLocation() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) {
      return null;
    } else {
      return selectedDirectory;
    }
  }

  static Future<void> backupWatchBox<Watches>(String backupPath) async {
    print("Backup watchbox called");
    // DateTime backupTime = DateTime.now();
    // int year = backupTime.year;
    // int month = backupTime.month;
    // int day = backupTime.day;
    final box = Boxes.getWatches();
    final boxPath = box.path;
    await box.close();

    try {
      backupPath = backupPath+"/watchbox.hive";
      File(boxPath!).copy(backupPath);

      //Check file now exists then notify user
      var file = File(backupPath);
      await file.exists().then((_) => WristCheckDialogs.getBackupSuccessDialog());



    } catch(e) {
      print("Caught exception: $e");
    } finally {
      await Hive.openBox<Watches>("WatchBox").onError((error, stackTrace) => WristCheckDialogs.getBackupFailedDialog(error.toString()));

    }


  }

  static Future<void> restoreWatchBox<Watches>() async {
    final File? backupFile = await pickBackupFile();
    if(backupFile == null){
    }

    final box = Boxes.getWatches();
    final boxPath = box.path;
    await box.close();

    try {
      backupFile!.copy(boxPath!);
    } finally {
      await Hive.openBox<Watches>("WatchBox");
    }
  }

  static Future<File?> pickBackupFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File? file;

    if (result != null) {
      file = File(result.files.single.path!);
    } else {

    }

    return file;


  }
}