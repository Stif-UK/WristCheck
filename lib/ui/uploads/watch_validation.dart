import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/uploads_controller.dart';
import 'package:wristcheck/model/enums/upload_status_enum.dart';
import 'package:wristcheck/model/upload_methods.dart';
import 'package:wristcheck/ui/watch/rows/manufacturer_row.dart';
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

  @override
  void dispose() {
    manufacturerFieldController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    manufacturerFieldController.value = TextEditingValue(text: widget.uploadsController.uploadData[widget.index][1].toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(UploadMethods.getWatchName(widget.uploadsController.uploadData[widget.index])),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text("Current Status: ${WristCheckFormatter.getUploadStatusText(UploadMethods.validateCSVRowContent(widget.uploadsController.uploadData[widget.index]))}"),
              subtitle: Text(WristCheckFormatter.getUploadStatusSubtitle(UploadMethods.validateCSVRowContent(widget.uploadsController.uploadData[widget.index]))),
              trailing: UploadMethods.getStatusIcon(UploadMethods.validateCSVRowContent(widget.uploadsController.uploadData[widget.index])),
            ),
            const Divider(thickness: 2,),
            ManufacturerRow(enabled: true, manufacturerFieldController: manufacturerFieldController)
          ],
        ),
      ),
    );
  }
}
