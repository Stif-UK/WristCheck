import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/controllers/uploads_controller.dart';
import 'package:get/get.dart';
import 'package:wristcheck/model/enums/upload_status_enum.dart';
import 'package:wristcheck/model/upload_methods.dart';

class UploadsValidation extends StatefulWidget {
  UploadsValidation({
    required this.data,
    super.key});
  final List<List<dynamic>> data;
  final uploadsController = Get.put(UploadsController());

  @override
  State<UploadsValidation> createState() => _UploadsValidationState();
}

class _UploadsValidationState extends State<UploadsValidation> {
  @override
  Widget build(BuildContext context) {
    //Trigger header row validation
    List<String> header = List<String>.from(widget.data[0]);
    widget.uploadsController.validateHeader(header);
    //remove the header row from data (first row is created below
    widget.data.removeAt(0);
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Review"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              child: Obx(()=> ListTile(
                  leading: Icon(Icons.data_array),
                  title: Text("Header Status"),
                  subtitle: Text("Test"),
                  trailing: _getHeaderStatusIcon(widget.uploadsController.headerValidationStatus.value),

                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.data.length,
              itemBuilder: (_, index) {
                //var currentData = List<String>.from(widget.data[index]);
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.watch),
                    title: Text("${widget.data[index][1]} ${widget.data[index][2]}"),
                    trailing: _getStatusIcon(UploadMethods.validateCSVRowContent(widget.data[index])),
                  ),
                );
              },
                ),
          ],
        ),
      )
    );
  }
}

Widget _getHeaderStatusIcon(bool? status) {
  switch(status){
    case true:
      return Icon(FontAwesomeIcons.circleCheck, color: Colors.green, size: 45,);
    case false:
      return Icon(FontAwesomeIcons.circleXmark, color: Colors.red, size: 45,);
    default:
      return CircularProgressIndicator();
  }
}

Widget _getStatusIcon(UploadStatusEnum? status) {
  switch(status){
    case UploadStatusEnum.pass:
      return Icon(FontAwesomeIcons.circleCheck, color: Colors.green, size: 30,);
      break;
    case UploadStatusEnum.fail:
      return Icon(FontAwesomeIcons.circleXmark, color: Colors.red, size: 30,);
      break;
    case UploadStatusEnum.partialpass:
      return Icon(FontAwesomeIcons.triangleExclamation, color: Colors.blueAccent, size: 30,);
      break;
    default: return CircularProgressIndicator();
  }
}
