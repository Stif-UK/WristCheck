import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';

class UploadMethods{

  /*
  getCSVImport opens a file picker on the users device and allows the selection of a CSV file which is then
  returned as a List or Lists, with each internal list representing a row of the import file.
  Returns null if cancelled by the user.
   */
  static Future<List<List<dynamic>>?> getCSVImport() async {
    List<List<dynamic>> import = [];

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      File resultFile = File(result.files.single.path!);
      final input = resultFile.openRead();
      import = await input.transform(utf8.decoder).transform(CsvToListConverter()).toList();
      return import;

    } else {
      // User canceled the picker
      return null;
    }
  }
}