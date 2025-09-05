import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/uploads_controller.dart';
import 'package:wristcheck/model/upload_methods.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(UploadMethods.getWatchName(widget.uploadsController.uploadData[widget.index])),
      ),
    );
  }
}
