import 'package:get/get.dart';
import 'package:wristcheck/model/enums/WatchViewFieldsEnum.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';

class WatchViewController extends GetxController{
  final inEditState = false.obs;
  final currentView = WatchViewFieldsEnum.info.obs;
  final selectedStatus = "In Collection".obs;
  final tabIndex = 0.obs;
  final watchViewState = WatchViewEnum.view.obs;

  updateInEditState(bool edit){
    inEditState(edit);
  }

  updateCurrentView(WatchViewFieldsEnum view){
    currentView(view);
  }

  updateSelectedStatus(String status){
    selectedStatus(status);
  }

  updateTabIndex(int index){
    tabIndex(index);
  }

  incrementTabIndex(){
    tabIndex(tabIndex.value +1);
  }

  updateViewState(WatchViewEnum state){
    watchViewState(state);
  }

}