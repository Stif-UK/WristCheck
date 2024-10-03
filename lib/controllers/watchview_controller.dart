import 'package:get/get.dart';
import 'package:wristcheck/model/enums/WatchViewFieldsEnum.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/watches.dart';

class WatchViewController extends GetxController{
  final inEditState = false.obs;
  final currentView = WatchViewFieldsEnum.info.obs;
  final selectedStatus = "In Collection".obs;
  final tabIndex = 0.obs;
  final watchViewState = WatchViewEnum.view.obs;
  final purchasePrice = 0.obs;
  final soldPrice = 0.obs;

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

  updatePurchasePrice(int price){
    purchasePrice(price);
  }

  updateSoldPrice(int price){
    soldPrice(price);
  }


}