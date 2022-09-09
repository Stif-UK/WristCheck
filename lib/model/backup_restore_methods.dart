import 'dart:io';
import 'package:hive/hive.dart';

Future<void> backupHiveBox<T>(String boxName, String backupPath) async {
  final box = await Hive.openBox<T>(boxName);
  final boxPath = box.path;
  await box.close();

  try {
    File(boxPath!).copy(backupPath);
  }
  catch(e){
    print("Caught exception: $e");
  }
  finally {
    await Hive.openBox<T>(boxName);
  }
}

Future<void> restoreHiveBox<T>(String boxName, String backupPath) async {
  final box = await Hive.openBox<T>(boxName);
  final boxPath = box.path;
  await box.close();

  try {
    File(backupPath).copy(boxPath!);
  } finally {
    await Hive.openBox<T>(boxName);
  }
}