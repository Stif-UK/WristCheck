import 'package:get/get.dart';

class AccuracyController extends GetxController{
  final watchDateTime = DateTime.now().obs;

  updateWatchDateTime(DateTime time){
    watchDateTime(time);
  }

  addAMinute(){
    DateTime newTime = watchDateTime.value.add(Duration(minutes: 1));
    watchDateTime(newTime);
  }

  subtractAMinute(){
    DateTime newTime = watchDateTime.value.subtract(Duration(minutes: 1));
    watchDateTime(newTime);
  }
}