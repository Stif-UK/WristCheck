import 'package:get/get.dart';
import 'package:wristcheck/model/enums/WatchViewFieldsEnum.dart';

class WatchViewController extends GetxController{
  final inEditState = false.obs;
  final currentView = WatchViewFieldsEnum.info.obs;

  updateInEditState(bool edit){
    inEditState(edit);
  }

  updateCurrentView(WatchViewFieldsEnum view){
    currentView(view);
  }

}