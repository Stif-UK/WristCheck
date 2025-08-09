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

  /*
  Validates that the header row matches spec for v0.1 of CSV upload template
   */
  //TODO: Generate errors to help users identify data issues
  static Future<bool> validateHeader(List<String> header) async {
    bool result = true;
    //Check we have the expected number of columns
    if(header.length != 18){result = false;}
    //Check each row matches the spec
    //TODO: Externalise this list to reference a standard (Template CSV in assets to validate against)
    if(header[0] != "Status") {result = false;}
    if(header[1] != "Manufacturer") {result = false;}
    if(header[2] != "Model") {result = false;}
    if(header[3] != "Serial Number") {result = false;}
    if(header[4] != "Reference Number") {result = false;}
    if(header[5] != "Warranty Expiry Date") {result = false;}
    if(header[6] != "Last Serviced Date") {result = false;}
    if(header[7] != "Purchase Date") {result = false;}
    if(header[8] != "Purchase Price") {result = false;}
    if(header[9] != "Purchased From") {result = false;}
    if(header[10] != "Sold Date") {result = false;}
    if(header[11] != "Sold Price") {result = false;}
    if(header[12] != "Sold To") {result = false;}
    if(header[13] != "Case Diameter") {result = false;}
    if(header[14] != "Case Thickness") {result = false;}
    if(header[15] != "Lug Width") {result = false;}
    if(header[16] != "Lug to Lug") {result = false;}
    if(header[17] != "Water Resistance") {result = false;}

    return result;
  }
}