import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/model/upload_methods.dart';
import 'package:wristcheck/ui/uploads/uploads_validation.dart';

class UploadsLanding extends StatefulWidget {
  const UploadsLanding({super.key});

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
              result == null?
              print("Null return") :
              Get.to(()=> UploadsValidation(data: result));
            });

      }

        ,)),
    );
  }
}
