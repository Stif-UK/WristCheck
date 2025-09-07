import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/uploads_controller.dart';
import 'package:wristcheck/model/enums/upload_status_enum.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/upload_methods.dart';
import 'package:wristcheck/ui/watch/rows/last_serviced_row.dart';
import 'package:wristcheck/ui/watch/rows/manufacturer_row.dart';
import 'package:wristcheck/ui/watch/rows/model_row.dart';
import 'package:wristcheck/ui/watch/rows/reference_number_row.dart';
import 'package:wristcheck/ui/watch/rows/serial_number_row.dart';
import 'package:wristcheck/ui/watch/rows/warranty_end_row.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class WatchValidation extends StatefulWidget {
  WatchValidation({super.key, this.index});
  final uploadsController = Get.put(UploadsController());
  final index;




  @override
  State<WatchValidation> createState() => _WatchValidationState();
}

class _WatchValidationState extends State<WatchValidation> {
  TextEditingController manufacturerFieldController = TextEditingController();
  TextEditingController modelFieldController = TextEditingController();
  TextEditingController serialNumberFieldController = TextEditingController();
  TextEditingController referenceNumberFieldController = TextEditingController();
  TextEditingController warrantyEndDateFieldController = TextEditingController();
  TextEditingController lastServicedDateFieldController = TextEditingController();

  @override
  void dispose() {
    manufacturerFieldController.dispose();
    modelFieldController.dispose();
    serialNumberFieldController.dispose();
    referenceNumberFieldController.dispose();
    warrantyEndDateFieldController.dispose();
    lastServicedDateFieldController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final WatchViewEnum viewState = WatchViewEnum.edit; //Static value for this page to drive some text for formfields
    manufacturerFieldController.value = TextEditingValue(text: widget.uploadsController.uploadData[widget.index][1].toString());
    modelFieldController.value = TextEditingValue(text: widget.uploadsController.uploadData[widget.index][2].toString());
    serialNumberFieldController.value = TextEditingValue(text: widget.uploadsController.uploadData[widget.index][3].toString());
    referenceNumberFieldController.value = TextEditingValue(text: widget.uploadsController.uploadData[widget.index][4].toString());
    warrantyEndDateFieldController.value = TextEditingValue(text: widget.uploadsController.uploadData[widget.index][5].toString()); //TODO: Should use Formatter methods to convert this date, rather than toString()
    lastServicedDateFieldController.value = TextEditingValue(text: widget.uploadsController.uploadData[widget.index][6].toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(UploadMethods.getWatchName(widget.uploadsController.uploadData[widget.index])),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              //leading: Icon(FontAwesomeIcons.rotate),//TODO: Implement icon for refreshing data?
              title: Text("Current Status: ${WristCheckFormatter.getUploadStatusText(UploadMethods.validateCSVRowContent(widget.uploadsController.uploadData[widget.index]))}"),
              subtitle: Text(WristCheckFormatter.getUploadStatusSubtitle(UploadMethods.validateCSVRowContent(widget.uploadsController.uploadData[widget.index]))),
              trailing: UploadMethods.getStatusIcon(UploadMethods.validateCSVRowContent(widget.uploadsController.uploadData[widget.index])),
            ),
            const Divider(thickness: 2,),
            ManufacturerRow(enabled: true, manufacturerFieldController: manufacturerFieldController),
            ModelRow(enabled: true, modelFieldController: modelFieldController),
            SerialNumberRow(serialNumberFieldController: serialNumberFieldController, enabled: true, viewState: viewState),
            ReferenceNumberRow(enabled: true, referenceNumberFieldController: referenceNumberFieldController, viewState: viewState),
            WarrantyEndRow(enabled: true, warrantyEndDateFieldController: warrantyEndDateFieldController),
            LastServicedRow(enabled: true, lastServicedDateFieldController: lastServicedDateFieldController),
    //Position 7: Purchase Date
    //Position 8: Purchase Price
    //Position 9: Purchased From
    //Position 10: Sold Date
    //Position 11: Sold Price
    //Position 12: Sold To
    //Position 13: Case Diameter
    //Position 14: Case Thickness
    //Position 15: Lug Width
    //Position 16: Lug to Lug
    //Position 17: Water Resistance
          ],
        ),
      ),
    );
  }
}
