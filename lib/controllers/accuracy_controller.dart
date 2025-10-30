import 'package:get/get.dart';

class AccuracyController extends GetxController{
  final watchDateTime = DateTime.now().obs;

  updateWatchDateTime(DateTime time){
    watchDateTime(time);
  }
}