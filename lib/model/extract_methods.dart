import 'dart:io';
import 'package:csv/csv.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class ExtractMethods{

  /**
   * The generateSimpleExtract() method iterates over the users collection and generates a CSV String containing all key watch details
   * with a count of total times worn. It then internally calls the shareExtract() method to trigger the generation and sharing of a CSV file
   * which the user can then access as required.
   */
  static generateSimpleExtract() async {
    List<Watches> watchbox = Boxes.getAllWatches();

    //Produce a list of Rows to convert
    List<List<String?>> csvList = [];
    //Create Header Row
    csvList.add(["Status", "Manufacturer", "Model", "Category", "Serial Number", "Reference Number", "Movement", "Date Complication", "Warranty Expiry Date", "Last Serviced Date","Purchase Date", "Purchase Price", "Purchased From", "Sold Date", "Sold Price", "Sold To", "Case Diameter", "Case Thickness", "Case Material", "Lug Width", "Lug to Lug", "Water Resistance", "Winder TPD", "Winder Direction", "Notes", "Tracked Wear Count"]);
    //Add additional rows per watch
    for(Watches watch in watchbox){
      csvList.add([watch.status!, watch.manufacturer, watch.model, watch.category, watch.serialNumber, watch.referenceNumber, watch.movement, watch.dateComplication,  watch.warrantyEndDate.toString(), watch.lastServicedDate.toString(), watch.purchaseDate.toString(), watch.purchasePrice.toString(), watch.purchasedFrom, watch.soldDate.toString(), watch.soldPrice.toString(), watch.soldTo, watch.caseDiameter.toString(), watch.caseThickness.toString(), watch.caseMaterial, watch.lugWidth.toString(), watch.lug2lug.toString(), watch.waterResistance.toString(), watch.winderTPD.toString(), watch.winderDirection, watch.notes, watch.wearList.length.toString()]);
    }
    String csv = const ListToCsvConverter().convert(csvList);
    await shareExtract(csv);

  }

  /**
   * the generateComplexExtract() method iterates over the users collection and produces a CSV string containing a line for every
   * wear record (so multiple lines per watch) but it does not include notes. It then calls the shareExtract() method to convert to
   * a CSV file and make this available for the user to access.
   */
  static generateComplexExtract() async {
    List<Watches> watchbox = Boxes.getAllWatches();

    //Produce a list of Rows to convert
    List<List<String?>> csvList = [];
    //Create Header Row
    csvList.add(["Status", "Manufacturer", "Model", "Date Worn", "Category", "Serial Number", "Reference Number", "Movement", "Date Complication", "Warranty Expiry Date", "Last Serviced Date", "Purchase Date", "Purchase Price", "Purchased From", "Sold Date", "Sold Price", "Sold To", "Case Diameter", "Case Thickness", "Case Material", "Lug Width", "Lug to Lug", "Water Resistance", "Winder TPD", "Winder Direction",]);
    //Add additional rows per watch
    for(Watches watch in watchbox){
      for(DateTime date in watch.wearList){
        csvList.add([watch.status, watch.manufacturer, watch.model, date.toString(), watch.category, watch.serialNumber, watch.referenceNumber, watch.movement, watch.dateComplication, watch.warrantyEndDate.toString(), watch.lastServicedDate.toString(), watch.purchaseDate.toString(), watch.purchasePrice.toString(), watch.purchasedFrom, watch.soldDate.toString(), watch.soldPrice.toString(), watch.soldTo, watch.caseDiameter.toString(), watch.caseThickness.toString(), watch.caseMaterial, watch.lugWidth.toString(), watch.lug2lug.toString(), watch.waterResistance.toString(), watch.winderTPD.toString(), watch.winderDirection,]);
      }
    }
    String csv = const ListToCsvConverter().convert(csvList);
    await shareExtract(csv);
  }

  /**
   * The shareExtract() method takes a csv in the form of a String, generates a file called 'wristcheck_extract.csv'
   * and passes this to the OS share dialog, allowing the user to then save or transfer the file as required.
   */
  static Future<ShareResult> shareExtract(String csv) async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/wristcheck_extract.csv');
    await file.writeAsString(csv);


    var result = await Share.shareXFiles([XFile(file.path)]);

    if (result.status == ShareResultStatus.success) {
      WristCheckDialogs.getExtractSuccessDialog();
    }

    return result;
  }

}