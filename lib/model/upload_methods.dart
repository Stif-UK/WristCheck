import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:wristcheck/model/enums/upload_status_enum.dart';
import 'package:wristcheck/util/general_helper.dart';
import 'package:wristcheck/util/string_extension.dart';
import 'package:wristcheck/util/watch_data_validation_facade.dart';


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
  Gets the watch name if present in the data, or returns placeholder text
   */
  static String getWatchName(List<dynamic> inputRow){
    if(inputRow.isNotEmpty && inputRow.length > 3){
      var returnString = "";
      returnString = "${inputRow[1].toString()} ${inputRow[2].toString()}";
      return returnString;
    }
    return "Unknown";
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

    //TODO: Pass results to controller to populate detailed results view?
    return !headerFieldResults.containsValue(false);

  }

  static Future<bool> validateCSVRowCounts(List<List<String>> inputList) async{
    //Check all rows have the same number of columns
    final columnCount = inputList.first.length;
    for(var row in inputList){
      if(row.length != columnCount){
        //TODO: write error rows (to controller?) for meaningful feedback to user
        return false; //invalid row found
      }
    }
    return true; //if this point is reached then all rows are valid lengths

  }

  static UploadStatusEnum validateCSVRowContent(List<dynamic> inputRow) {

    //TODO: Need to consider versioning the upload template
    //Check row length and return fail if too short
    if(inputRow.length != 18) {
      return UploadStatusEnum.fail;
    }
    //Create a list of bools to capture results
    List<bool> validationResults = [];
    //populate with values
    for(var i=0; i < inputRow.length; i++){
      validationResults.add(false);
    }
    UploadStatusEnum result = UploadStatusEnum.fail;

    //Evaluate each field and capture results in the validation list
    //Position 0: Status
    validationResults[0] = WatchDataValidationFacade.validateStatus(inputRow[0]);

    //Position 1: Manufacturer
    validationResults[1] = WatchDataValidationFacade.validateManufacturer(inputRow[1]);

    //Position 2: Model
    validationResults[2] = WatchDataValidationFacade.validateModel(inputRow[2]);

    //Position 3: Serial Number
    validationResults[3] = WatchDataValidationFacade.validateSerialNumber(inputRow[3]);

    //Position 4: Reference Number
    validationResults[4] = WatchDataValidationFacade.validateReferenceNumber(inputRow[4]);

    //Position 5: Warranty Expiry Date
    validationResults[5] = WatchDataValidationFacade.validateWarrantyExpiryDate(inputRow[5]);

    //Position 6: Last Serviced Date
    validationResults[6] = WatchDataValidationFacade.validateLastServicedDate(inputRow[6]);

    //Position 7: Purchase Date
    validationResults[7] = WatchDataValidationFacade.validatePurchasedDate(inputRow[7]);

    //Position 8: Purchase Price
    validationResults[8] = WatchDataValidationFacade.validatePurchasePrice(inputRow[8]); //? true : inputRow[8].isDouble; //Handle case where decimals have been included - //TODO: TEST THIS!

    //Position 9: Purchased From
    validationResults[9] = WatchDataValidationFacade.validatePurchasedFrom(inputRow[9]);

    //Position 10: Sold Date
    validationResults[10] = WatchDataValidationFacade.validateSoldDate(inputRow[10]);

    //Position 11: Sold Price
    validationResults[11] = WatchDataValidationFacade.validateSoldPrice(inputRow[11]);// ? true : inputRow[11].isDouble;

    //Position 12: Sold To
    validationResults[12] = WatchDataValidationFacade.validateSoldTo(inputRow[12]);

    //Position 13: Case Diameter
    validationResults[13] = WatchDataValidationFacade.validateCaseDiameter(inputRow[13]);

    //Position 14: Case Thickness
    validationResults[14] = WatchDataValidationFacade.validateCaseThickness(inputRow[14]);

    //Position 15: Lug Width
    validationResults[15] = WatchDataValidationFacade.validateLugWidth(inputRow[15]);

    //Position 16: Lug to Lug
    validationResults[16] = WatchDataValidationFacade.validateLug2Lug(inputRow[16]);

    //Position 17: Water Resistance
    validationResults[17] = WatchDataValidationFacade.validateWaterResistance(inputRow[17]);

    //TODO: Once all fields are evaluated, confirm the final status for the row
    //TODO: Also need to confirm if Manufacturer + Model already exists + highlight if watch is a duplicate (new method in watch methods + update to add watch...)
    /*
    If Manufacturer or Model are missing the row fails, else check if all fields are passed.
    Any other fails result in a partial pass.
     */
    if(validationResults[1] == false || validationResults[2] == false){
      result = UploadStatusEnum.fail;
    } else if(validationResults.contains(false)){
      result = UploadStatusEnum.partialpass;
    } else {
      result = UploadStatusEnum.pass;
    }
    return result;

  }
}