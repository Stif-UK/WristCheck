import 'dart:convert';
import 'dart:io';
import 'dart:math';

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
  static Future<bool> validateHeader(List<String> header) async {
    List<String> expectedColumns = ["Status", "Manufacturer", "Model", "Serial Number", "Reference Number","Warranty Expiry Date",
      "Last Serviced Date","Purchase Date", "Purchase Price", "Purchased From", "Sold Date", "Sold Price",
      "Sold To", "Case Diameter", "Case Thickness", "Lug Width", "Lug to Lug", "Water Resistance"
    ];
    Map<String, bool> headerFieldResults = Map.fromIterable(expectedColumns,
    key: (item) => item, value: (item)=> true);

    //Check each row matches the spec
    //TODO: Externalise this list to reference a standard (Template CSV in assets to validate against)
    for(int index = 0; index < expectedColumns.length; index++){
      var currentHeaderValue = header[index] ?? "";
      if(currentHeaderValue != expectedColumns[index]){
        headerFieldResults[header[index]] = false;
      }
    }

    //TODO: Pass results to controller to populate detailed results view
    return !headerFieldResults.containsValue(false);

  }
}