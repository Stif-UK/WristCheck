import 'package:get/get.dart';

class AccuracyController extends GetxController{
  final watchDateTime = DateTime.now().obs;
  final baseLine = true.obs;

  updateWatchDateTime(DateTime time){
    watchDateTime(time);
  }

  toggleBaseline(){
    baseLine(!baseLine.value);
  }

  updateBaseline(bool newValue){
    baseLine(newValue);
    print(baseLine.value);
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