import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:wristcheck/model/upload_methods.dart';

class Uploads extends StatefulWidget {
  const Uploads({super.key});

  @override
  State<Uploads> createState() => _UploadsState();
}

class _UploadsState extends State<Uploads> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Uploads"),
      ),
      body: Center(child: ElevatedButton(
          child: Text("Test Button"),
      onPressed: (){
            UploadMethods.getCSVImport();

      }

        ,)),
    );
  }
}
