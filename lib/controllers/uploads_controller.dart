import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/model/upload_methods.dart';

class UploadsController extends GetxController{

  final headerValidationStatus = Rxn<bool>();
  // final uploadData = Rxn<List<List<dynamic>>>();
  final uploadData = <List<dynamic>>[].obs;


  updateUploadData(List<List<dynamic>> data){
    uploadData(data);
  }

  validateHeader(List<String> header) async {
    bool status = await UploadMethods.validateHeader(header);
    updateHeaderValidationStatus(status);
  }

  updateHeaderValidationStatus(bool status){
    headerValidationStatus(status);
  }

}