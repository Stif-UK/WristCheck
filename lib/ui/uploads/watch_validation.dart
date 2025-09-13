import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/uploads_controller.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/upload_status_enum.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/upload_methods.dart';
import 'package:wristcheck/ui/watch/rows/case_diameter_row.dart';
import 'package:wristcheck/ui/watch/rows/case_thickness_row.dart';
import 'package:wristcheck/ui/watch/rows/last_serviced_row.dart';
import 'package:wristcheck/ui/watch/rows/manufacturer_row.dart';
import 'package:wristcheck/ui/watch/rows/model_row.dart';
import 'package:wristcheck/ui/watch/rows/purchase_date_row.dart';
import 'package:wristcheck/ui/watch/rows/purchase_price_row.dart';
import 'package:wristcheck/ui/watch/rows/purchased_from_row.dart';
import 'package:wristcheck/ui/watch/rows/reference_number_row.dart';
import 'package:wristcheck/ui/watch/rows/serial_number_row.dart';
import 'package:wristcheck/ui/watch/rows/sold_date_row.dart';
import 'package:wristcheck/ui/watch/rows/sold_price_row.dart';
import 'package:wristcheck/ui/watch/rows/sold_to_row.dart';
import 'package:wristcheck/ui/watch/rows/warranty_end_row.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class WatchValidation extends StatefulWidget {
  WatchValidation({super.key, this.index});
  final uploadsController = Get.put(UploadsController());
  final index;
  final wristCheckController = Get.put(WristCheckController());





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
  TextEditingController purchaseDateFieldController = TextEditingController();
  TextEditingController purchasePriceFieldController = TextEditingController();
  TextEditingController purchasedFromFieldController = TextEditingController();
  TextEditingController soldDateFieldController = TextEditingController();
  TextEditingController soldPriceFieldController = TextEditingController();
  TextEditingController soldToFieldController = TextEditingController();
  TextEditingController caseDiameterController = TextEditingController();
  TextEditingController caseThicknessController = TextEditingController();

  @override
  void dispose() {
    manufacturerFieldController.dispose();
    modelFieldController.dispose();
    serialNumberFieldController.dispose();
    referenceNumberFieldController.dispose();
    warrantyEndDateFieldController.dispose();
    lastServicedDateFieldController.dispose();
    purchaseDateFieldController.dispose();
    purchasePriceFieldController.dispose();
    purchasedFromFieldController.dispose();
    soldDateFieldController.dispose();
    soldPriceFieldController.dispose();
    soldToFieldController.dispose();
    caseDiameterController.dispose();
    caseThicknessController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final String locale = WristCheckFormatter.getLocaleString(widget.wristCheckController.locale.value);
    final WatchViewEnum viewState = WatchViewEnum.edit; //Static value for this page to drive some text for formfields
    manufacturerFieldController.value = TextEditingValue(text: widget.uploadsController.uploadData[widget.index][1].toString());
    modelFieldController.value = TextEditingValue(text: widget.uploadsController.uploadData[widget.index][2].toString());
    serialNumberFieldController.value = TextEditingValue(text: widget.uploadsController.uploadData[widget.index][3].toString());
    referenceNumberFieldController.value = TextEditingValue(text: widget.uploadsController.uploadData[widget.index][4].toString());
    warrantyEndDateFieldController.value = TextEditingValue(text: _fillDateField(widget.uploadsController.uploadData[widget.index][5].toString()));
    lastServicedDateFieldController.value = TextEditingValue(text: _fillDateField(widget.uploadsController.uploadData[widget.index][6].toString()));
    purchaseDateFieldController.value = TextEditingValue(text: _fillDateField(widget.uploadsController.uploadData[widget.index][7].toString()));
    purchasePriceFieldController.value = TextEditingValue(text: widget.uploadsController.uploadData[widget.index][8].toString());
    purchasedFromFieldController.value = TextEditingValue(text: widget.uploadsController.uploadData[widget.index][9].toString());
    soldDateFieldController.value = TextEditingValue(text: _fillDateField(widget.uploadsController.uploadData[widget.index][10].toString()));
    soldPriceFieldController.value = TextEditingValue(text: widget.uploadsController.uploadData[widget.index][11].toString());
    soldToFieldController.value = TextEditingValue(text: widget.uploadsController.uploadData[widget.index][12].toString());
    caseDiameterController.value = TextEditingValue(text: widget.uploadsController.uploadData[widget.index][13].toString());
    caseThicknessController.value = TextEditingValue(text: widget.uploadsController.uploadData[widget.index][14].toString());

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
            PurchaseDateRow(enabled: true, purchaseDateFieldController: purchaseDateFieldController),
            PurchasePriceRow(enabled: true, purchasePriceFieldController: purchasePriceFieldController, viewState: viewState, locale: locale, price: 0),
            PurchasedFromRow(enabled: true, purchasedFromFieldController: purchasedFromFieldController),
            SoldDateRow(enabled: true, soldDateFieldController: soldDateFieldController),
            SoldPriceRow(enabled: true, soldPriceFieldController: soldPriceFieldController, viewState: viewState, locale: locale, price: 0),
            SoldToRow(enabled: true, soldToFieldController: soldToFieldController),
            CaseDiameterRow(enabled: true, caseDiameterController: caseDiameterController),
            CaseThicknessRow(enabled: true, caseThicknessController: caseThicknessController),
    //Position 15: Lug Width
    //Position 16: Lug to Lug
    //Position 17: Water Resistance
          ],
        ),
      ),
    );
  }
}

String _fillDateField(String? inputText){
  var returnString = "";
  if(inputText != null && inputText != ""){
    try {
      var date = DateTime.parse(inputText);
      returnString = WristCheckFormatter.getFormattedDate(date);
    } on Exception catch (e){
      returnString = "Error parsing date"; //TODO: Handle this status at point of upload
    }
  }

  return returnString;
}
