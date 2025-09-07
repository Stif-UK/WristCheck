import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/watch/rows/warranty_end_row.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:wristcheck/util/string_extension.dart';

class ServiceTab extends StatelessWidget {
  ServiceTab({super.key,
    required this.deliveryDateFieldController,
    required this.purchaseDateFieldController,
    required this.soldDateFieldController,
    required this.timeInCollectionFieldController,
    required this.serviceIntervalFieldController,
    required this.warrantyEndDateFieldController,
    required this.lastServicedDateFieldController,
    required this.nextServiceDueFieldController,
    required this.currentWatch,
  });

  final watchViewController = Get.put(WatchViewController());
  final TextEditingController deliveryDateFieldController;
  final TextEditingController purchaseDateFieldController;
  final TextEditingController soldDateFieldController;
  final TextEditingController timeInCollectionFieldController;
  final TextEditingController serviceIntervalFieldController;
  final TextEditingController warrantyEndDateFieldController;
  final TextEditingController lastServicedDateFieldController;
  final TextEditingController nextServiceDueFieldController;
  final Watches? currentWatch;

  @override
  Widget build(BuildContext context) {
    return Obx(()=> Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          watchViewController.selectedStatus.value =="Pre-Order"? Obx(()=> _deliveryDateRow()): const SizedBox(height: 0,),
          _purchaseDateRow(),
          watchViewController.selectedStatus.value =="Sold"? Obx(()=> _soldDateRow()): const SizedBox(height: 0,),
          watchViewController.watchViewState.value == WatchViewEnum.view? _timeInCollectionRow() : const SizedBox(height: 0,),
          _serviceIntervalRow(),
          WarrantyEndRow(enabled: watchViewController.inEditState.value, warrantyEndDateFieldController: warrantyEndDateFieldController),
          _lastServicedDateRow(),
          watchViewController.watchViewState.value == WatchViewEnum.view? _nextServiceDueRow(): const SizedBox(height: 0,)
        ],
      ),
    );
  }

  Widget _deliveryDateRow(){
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.calendar),
      enabled: watchViewController.inEditState.value,
      fieldTitle: "Due Date:",
      hintText: "Due Date",
      maxLines: 1,
      datePicker: true,
      controller: deliveryDateFieldController,
      textCapitalization: TextCapitalization.none,

    );
  }

  Widget _purchaseDateRow(){
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.calendar),
      enabled: watchViewController.inEditState.value,
      fieldTitle: "Purchase Date:",
      hintText: "Purchase Date",
      maxLines: 1,
      datePicker: true,
      controller: purchaseDateFieldController,
      textCapitalization: TextCapitalization.none,
    );
  }

  Widget _soldDateRow(){
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.calendarXmark),
      enabled: watchViewController.inEditState.value,
      fieldTitle: "Sold Date:",
      hintText: "Sold Date",
      maxLines: 1,
      datePicker: true,
      controller: soldDateFieldController,
      textCapitalization: TextCapitalization.none,
    );
  }

  Widget _timeInCollectionRow(){
    if(currentWatch != null){
      watchViewController.updateTimeInCollection(WatchMethods.calculateTimeInCollection(currentWatch!, watchViewController.showDays.value));
    }
    timeInCollectionFieldController.value = TextEditingValue(text: watchViewController.timeInCollection.value);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: WatchFormField(
            icon: const Icon(FontAwesomeIcons.hourglass),
            enabled: false,
            fieldTitle: "Time in Collection",
            hintText: "Time in Collection",
            textCapitalization: TextCapitalization.none,
            controller: timeInCollectionFieldController, ),
        ),
        IconButton(
          icon: watchViewController.showDays.value? const Icon(FontAwesomeIcons.solidCalendarMinus): const Icon(FontAwesomeIcons.solidCalendarPlus),
          onPressed: ()=> watchViewController.updateShowdays(!watchViewController.showDays.value),
        )
      ],
    );
  }

  Widget _serviceIntervalRow(){
    return WatchFormField(
      keyboardType: TextInputType.number,
      icon: const Icon(FontAwesomeIcons.arrowsSpin),
      enabled: watchViewController.inEditState.value,
      fieldTitle: "Service Interval:",
      hintText: "Service Interval (years)",
      maxLines: 1,
      controller: serviceIntervalFieldController,
      textCapitalization: TextCapitalization.none,
      validator: (String? val) {
        if(!val!.isServiceNumber) {
          return 'Must be 0-99 or blank';
        }
      },
    );
  }

  // Widget _warrantyExpiryRow(){
  //   return WatchFormField(
  //     icon: const Icon(FontAwesomeIcons.screwdriverWrench),
  //     enabled: watchViewController.inEditState.value,
  //     fieldTitle: "Warranty Expiry Date:",
  //     hintText: "Warranty Expiry Date",
  //     maxLines: 1,
  //     datePicker: true,
  //     controller: warrantyEndDateFieldController,
  //     textCapitalization: TextCapitalization.none,
  //   );
  // }

  Widget _lastServicedDateRow(){
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.calendarCheck),
      enabled: watchViewController.inEditState.value,
      fieldTitle: "Last Serviced Date:",
      hintText: "Last Serviced Date",
      maxLines: 1,
      datePicker: true,
      controller: lastServicedDateFieldController,
      textCapitalization: TextCapitalization.none,
    );
  }

  Widget _nextServiceDueRow(){
    nextServiceDueFieldController.value = TextEditingValue(text: watchViewController.nextServiceDue.value);
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.calendarDays),
      //Always read only
      enabled: false,
      fieldTitle: "Next Service Due:",
      hintText: "Next Service Due",
      maxLines: 1,
      controller: nextServiceDueFieldController,
      textCapitalization: TextCapitalization.none,
    );
  }




}
