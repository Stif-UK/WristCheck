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
    csvList.add(["Status", "Manufacturer", "Model", "Category", "Serial Number", "Reference Number", "Movement", "Purchase Date", "Warranty Expiry Date", "Last Serviced Date", "Purchase Price", "Purchased From", "Sold Price", "Sold To", "Notes", "Tracked Wear Count"]);
    //Add additional rows per watch
    for(Watches watch in watchbox){
      csvList.add([watch.status!, watch.manufacturer, watch.model, watch.category, watch.serialNumber, watch.referenceNumber, watch.movement, watch.purchaseDate.toString(), watch.warrantyEndDate.toString(), watch.lastServicedDate.toString(), watch.purchasePrice.toString(), watch.purchasedFrom, watch.soldPrice.toString(), watch.soldTo, watch.notes, watch.wearList.length.toString()]);
    }
    String csv = const ListToCsvConverter().convert(csvList);
    print(csv);
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
      WristCheckDialogs.getWatchboxBackupSuccessDialog();
    }

    return result;
  }

}