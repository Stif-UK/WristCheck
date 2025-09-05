import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/uploads_controller.dart';
import 'package:wristcheck/model/upload_methods.dart';
import 'package:wristcheck/ui/uploads/uploads_validation.dart';

class UploadsLanding extends StatefulWidget {
  UploadsLanding({super.key});
  final uploadsController = Get.put(UploadsController());


  @override
  State<UploadsLanding> createState() => _UploadsLandingState();
}

class _UploadsLandingState extends State<UploadsLanding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Uploads"),
      ),
      body: Center(child: ElevatedButton(
          child: Text("Load CSV"),
      onPressed: (){
            UploadMethods.getCSVImport().then((result){
              if(result != null){
                widget.uploadsController.updateUploadData(result);
                Get.to(()=> UploadsValidation());
              }
              //TODO: handle null result - show loading indicator and on null reset loading status
            });
      }

        ,)),
    );
  }
}
