import 'package:get/get.dart';

class DatePickerController extends GetxController{
  final allowRange = false.obs;

  updateAllowRange(range){
    allowRange(range);
  }

  toggleAllowRange(){
    allowRange(!allowRange.value);
  }

}