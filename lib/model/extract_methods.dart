import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/watches.dart';

class ExtractMethods {
  static final DateFormat _isoDateFormat = DateFormat('yyyy-MM-dd');

  static String _formatDate(DateTime? date) {
    if (date == null) return '';
    return _isoDateFormat.format(date);
  }

  static String _formatValue(Object? value) {
    if (value == null) return '';
    return value.toString();
  }

  static List<Watches> _getExportableWatches([List<Watches>? watchesOverride]) {
    final source = watchesOverride ?? Boxes.getAllWatches();
    return source.where((watch) => watch.isDeleted != true).toList();
  }

  /// Builds the CSV string for the Simple Extract (one row per watch, including Notes and Tracked Wear Count).
  static String buildSimpleExtractCsv([List<Watches>? watchesOverride]) {
    final watchbox = _getExportableWatches(watchesOverride);

    final List<List<String>> csvList = [
      [
        'Status',
        'Manufacturer',
        'Model',
        'Favourite',
        'Category',
        'Movement',
        'Primary Colour',
        'Secondary Colour',
        'Serial Number',
        'Reference Number',
        'Date Complication',
        'Model Year',
        'Warranty Expiry Date',
        'Last Serviced Date',
        'Service Interval',
        'Next Service Due',
        'Purchase Date',
        'Delivery Date',
        'Purchase Price',
        'Purchased From',
        'Sold Date',
        'Sold Price',
        'Sold To',
        'Current Value',
        'Case Diameter',
        'Case Thickness',
        'Case Material',
        'Lug Width',
        'Lug to Lug',
        'Water Resistance',
        'Power Reserve',
        'Winder TPD',
        'Winder Direction',
        'Notes',
        'Tracked Wear Count',
      ],
    ];

    for (final watch in watchbox) {
      csvList.add([
        _formatValue(watch.status),
        watch.manufacturer,
        watch.model,
        watch.favourite.toString(),
        _formatValue(watch.category),
        _formatValue(watch.movement),
        _formatValue(watch.primaryColour),
        _formatValue(watch.secondaryColour),
        _formatValue(watch.serialNumber),
        _formatValue(watch.referenceNumber),
        _formatValue(watch.dateComplication),
        _formatValue(watch.year),
        _formatDate(watch.warrantyEndDate),
        _formatDate(watch.lastServicedDate),
        watch.serviceInterval > 0 ? watch.serviceInterval.toString() : '',
        _formatDate(watch.nextServiceDue),
        _formatDate(watch.purchaseDate),
        _formatDate(watch.deliveryDate),
        _formatValue(watch.purchasePrice),
        _formatValue(watch.purchasedFrom),
        _formatDate(watch.soldDate),
        _formatValue(watch.soldPrice),
        _formatValue(watch.soldTo),
        _formatValue(watch.value),
        _formatValue(watch.caseDiameter),
        _formatValue(watch.caseThickness),
        _formatValue(watch.caseMaterial),
        _formatValue(watch.lugWidth),
        _formatValue(watch.lug2lug),
        _formatValue(watch.waterResistance),
        _formatValue(watch.powerReserve),
        _formatValue(watch.winderTPD),
        _formatValue(watch.winderDirection),
        _formatValue(watch.notes),
        watch.wearList.length.toString(),
      ]);
    }

    return const ListToCsvConverter().convert(csvList);
  }

  /// Builds the CSV string for the Detailed/Complex Extract (one row per wear date, plus a single row for unworn watches; excludes Notes).
  static String buildComplexExtractCsv([List<Watches>? watchesOverride]) {
    final watchbox = _getExportableWatches(watchesOverride);

    final List<List<String>> csvList = [
      [
        'Status',
        'Manufacturer',
        'Model',
        'Date Worn',
        'Favourite',
        'Category',
        'Movement',
        'Primary Colour',
        'Secondary Colour',
        'Serial Number',
        'Reference Number',
        'Date Complication',
        'Model Year',
        'Warranty Expiry Date',
        'Last Serviced Date',
        'Service Interval',
        'Next Service Due',
        'Purchase Date',
        'Delivery Date',
        'Purchase Price',
        'Purchased From',
        'Sold Date',
        'Sold Price',
        'Sold To',
        'Current Value',
        'Case Diameter',
        'Case Thickness',
        'Case Material',
        'Lug Width',
        'Lug to Lug',
        'Water Resistance',
        'Power Reserve',
        'Winder TPD',
        'Winder Direction',
      ],
    ];

    List<String> rowForWatch(Watches watch, DateTime? wearDate) {
      return [
        _formatValue(watch.status),
        watch.manufacturer,
        watch.model,
        _formatDate(wearDate),
        watch.favourite.toString(),
        _formatValue(watch.category),
        _formatValue(watch.movement),
        _formatValue(watch.primaryColour),
        _formatValue(watch.secondaryColour),
        _formatValue(watch.serialNumber),
        _formatValue(watch.referenceNumber),
        _formatValue(watch.dateComplication),
        _formatValue(watch.year),
        _formatDate(watch.warrantyEndDate),
        _formatDate(watch.lastServicedDate),
        watch.serviceInterval > 0 ? watch.serviceInterval.toString() : '',
        _formatDate(watch.nextServiceDue),
        _formatDate(watch.purchaseDate),
        _formatDate(watch.deliveryDate),
        _formatValue(watch.purchasePrice),
        _formatValue(watch.purchasedFrom),
        _formatDate(watch.soldDate),
        _formatValue(watch.soldPrice),
        _formatValue(watch.soldTo),
        _formatValue(watch.value),
        _formatValue(watch.caseDiameter),
        _formatValue(watch.caseThickness),
        _formatValue(watch.caseMaterial),
        _formatValue(watch.lugWidth),
        _formatValue(watch.lug2lug),
        _formatValue(watch.waterResistance),
        _formatValue(watch.powerReserve),
        _formatValue(watch.winderTPD),
        _formatValue(watch.winderDirection),
      ];
    }

    for (final watch in watchbox) {
      if (watch.wearList.isEmpty) {
        csvList.add(rowForWatch(watch, null));
      } else {
        for (final date in watch.wearList) {
          csvList.add(rowForWatch(watch, date));
        }
      }
    }

    return const ListToCsvConverter().convert(csvList);
  }

  /// Generates the Simple Extract CSV and opens the OS share sheet.
  static Future<ShareResult> generateSimpleExtract() async {
    final csv = buildSimpleExtractCsv();
    return shareExtract(csv);
  }

  /// Generates the Detailed/Complex Extract CSV and opens the OS share sheet.
  static Future<ShareResult> generateComplexExtract() async {
    final csv = buildComplexExtractCsv();
    return shareExtract(csv);
  }

  /// Writes [csv] to 'wristcheck_extract.csv' and passes it to the OS share dialog.
  static Future<ShareResult> shareExtract(String csv) async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/wristcheck_extract.csv');
    await file.writeAsString(csv);

    final result = await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)]),
    );

    if (result.status == ShareResultStatus.success) {
      WristCheckDialogs.getExtractSuccessDialog();
    }

    return result;
  }
}
