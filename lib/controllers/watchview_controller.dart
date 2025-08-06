import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:wristcheck/model/enums/WatchViewFieldsEnum.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/ui/widgets/images/image_card_widget.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';


class WatchViewController extends GetxController{
  final inEditState = false.obs;
  final currentView = WatchViewFieldsEnum.info.obs;
  final selectedStatus = "In Collection".obs;
  final tabIndex = 0.obs;
  final watchViewState = WatchViewEnum.view.obs;
  final purchasePrice = 0.obs;
  final soldPrice = 0.obs;
  final movement = "".obs;
  final category = "".obs;
  final caseMaterial = "".obs;
  final winderDirection = "".obs;
  final dateComplication = "".obs;
  final showDays = false.obs;
  final favourite = false.obs;
  final  nextServiceDue = "N/A".obs;
  final timeInCollection = "N/A".obs;
  final canRecordWear = false.obs;
  final skipBackCheck = false.obs;
  final overrideBackNav = false.obs;
  //TODO: Refactor to change this to a cycling index count rather than a bool
  final front = true.obs;
  final frontImage = Rxn<File>();
  final backImage = Rxn<File>();
  //testing moving imagesList to the controller
  final imageList = <ImageCardWidget>[].obs;

  updateImageListIndex(ImageCardWidget newValue, int index){
    List<ImageCardWidget> updatedList = List.from(imageList);
    updatedList[index] = newValue;
    imageList(updatedList);
  }

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

  updateMovement(String? _movement){
    movement(_movement);
  }

  updateCategory(String? _category){
    category(_category);
  }

  updateCaseMaterial(String? _caseMaterial){
    caseMaterial(_caseMaterial);
  }

  updateWinderDirection(String? _winderDirection){
    winderDirection(_winderDirection);
  }

  updateDateComplication(String? _dateComplication){
    dateComplication(_dateComplication);
  }

  updateShowdays(bool value){
    showDays(value);
  }

  updateFavourite(bool value){
    favourite(value);
  }

  updateNextServiceDue(DateTime? due){
    String nsd = due != null? WristCheckFormatter.getFormattedDate(due): "N/A";
    nextServiceDue(nsd);
  }

  updateTimeInCollection(String time){
    timeInCollection(time);
  }

  updateCanRecordWear(bool value){
    canRecordWear(value);
  }

  updateSkipBackCheck(bool value){
    skipBackCheck(value);
  }

  updateOverrideBacknav(bool value){
    overrideBackNav(value);
  }

  updateFrontValue(bool value){
    front(value);
  }

  updateFrontImage(File? file){
    frontImage(file);
  }

  updateBackImage(File? file){
    backImage(file);
  }

}