import 'dart:io';
import 'package:csv/csv.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class ExtractMethods{

  static generateSimpleExtract() async {
    List<Watches> watchbox = Boxes.getAllWatches();

    //Produce a list of Rows to convert
    List<List<String>> csvList = [];
    //Create Header Row
    csvList.add(["Status", "Manufacturer", "Model"]);//, "Status", "Category", "Serial Number", "Reference Number", "Movement", "Purchase Date", "Warranty Expiry Date", "Last Serviced Date", "Purchase Price", "Purchased From", "Sold Price", "Sold To", "Notes"]);
    //Add additional rows per watch
    for(Watches watch in watchbox){
      csvList.add([watch.status!, watch.manufacturer, watch.model]);
    }
    String csv = const ListToCsvConverter().convert(csvList);
    print(csv);
    await shareExtract(csv);

  }

  static Future<ShareResult> shareExtract(String csv) async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/wristcheck_extract.csv');
    await file.writeAsString(csv);


    // //Check if extract directory exists - if it doesn't then create it
    // bool exists = await Directory("${directory.path}/extracts").exists();
    // if(!exists) {
    //   await Directory("${directory.path}/extracts").create();
    // }

    var result = await Share.shareXFiles([XFile(file.path)]);

    if (result.status == ShareResultStatus.success) {
      WristCheckDialogs.getWatchboxBackupSuccessDialog();
    }

    return result;
  }

}