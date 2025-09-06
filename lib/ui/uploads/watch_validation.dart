import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/uploads_controller.dart';
import 'package:wristcheck/model/enums/upload_status_enum.dart';
import 'package:wristcheck/model/upload_methods.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class WatchValidation extends StatefulWidget {
  WatchValidation({super.key, this.index});
  final uploadsController = Get.put(UploadsController());
  final index;

  @override
  State<WatchValidation> createState() => _WatchValidationState();
}

class _WatchValidationState extends State<WatchValidation> {
  @override
  Widget build(BuildContext context) {
    //TODO: No need for a local variable here - just directly access the controller where required.
    UploadStatusEnum currentStatus = UploadMethods.validateCSVRowContent(widget.uploadsController.uploadData[widget.index]);
    return Scaffold(
      appBar: AppBar(
        title: Text(UploadMethods.getWatchName(widget.uploadsController.uploadData[widget.index])),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text("Current Status: $currentStatus"),
              subtitle: Text(WristCheckFormatter.getUploadStatusSubtitle(currentStatus)),
              trailing: UploadMethods.getStatusIcon(currentStatus),
            ),
            const Divider(thickness: 2,)
          ],
        ),
      ),
    );
  }
}
