import 'package:get/get.dart';
import 'package:wristcheck/model/upload_methods.dart';

class UploadsController extends GetxController{

  final headerValidationStatus = Rxn<bool>();

  validateHeader(List<String> header) async {
    bool status = await UploadMethods.validateHeader(header);
    updateHeaderValidationStatus(status);
  }

  updateHeaderValidationStatus(bool status){
    headerValidationStatus(status);
  }
}