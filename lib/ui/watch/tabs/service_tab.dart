import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/watch/rows/last_serviced_row.dart';
import 'package:wristcheck/ui/watch/rows/purchase_date_row.dart';
import 'package:wristcheck/ui/watch/rows/sold_date_row.dart';
import 'package:wristcheck/ui/watch/rows/warranty_end_row.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:wristcheck/util/string_extension.dart';

import 'package:wristcheck/model/enums/watch_status_enum.dart';

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
          watchViewController.selectedStatus.value == WatchStatusEnum.preOrder.toDbString()? Obx(()=> _deliveryDateRow()): const SizedBox(height: 0,),
          PurchaseDateRow(enabled: watchViewController.inEditState.value, purchaseDateFieldController: purchaseDateFieldController),
          watchViewController.selectedStatus.value == WatchStatusEnum.sold.toDbString()? Obx(()=> SoldDateRow(enabled: watchViewController.inEditState.value, soldDateFieldController: soldDateFieldController)): const SizedBox(height: 0,),
          watchViewController.watchViewState.value == WatchViewEnum.view? _timeInCollectionRow() : const SizedBox(height: 0,),
          _serviceIntervalRow(),
          WarrantyEndRow(enabled: watchViewController.inEditState.value, warrantyEndDateFieldController: warrantyEndDateFieldController),
          LastServicedRow(enabled: watchViewController.inEditState.value, lastServicedDateFieldController: lastServicedDateFieldController),
          watchViewController.watchViewState.value == WatchViewEnum.view? _nextServiceDueRow(): const SizedBox(height: 0,)
        ],
      ),
    );
  }

  Widget _deliveryDateRow(){
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.calendar),
      enabled: watchViewController.inEditState.value,
      fieldTitle: AppLocalizations.of(Get.context!)!.preOrderDueDateRowTitle,
      hintText: AppLocalizations.of(Get.context!)!.preOrderDueDateRowHintText,
      maxLines: 1,
      datePicker: true,
      controller: deliveryDateFieldController,
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
            fieldTitle: AppLocalizations.of(Get.context!)!.timeInCollectionRowTitle,
            hintText: AppLocalizations.of(Get.context!)!.timeInCollectionRowTitle,
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
      fieldTitle: AppLocalizations.of(Get.context!)!.serviceIntervalRowTitle,
      hintText: AppLocalizations.of(Get.context!)!.serviceIntervalRowHintText,
      maxLines: 1,
      controller: serviceIntervalFieldController,
      textCapitalization: TextCapitalization.none,
      validator: (String? val) {
        if(!val!.isServiceNumber) {
          return AppLocalizations.of(Get.context!)!.mustBe099orBlank;
        }
      },
    );
  }

  Widget _nextServiceDueRow(){
    nextServiceDueFieldController.value = TextEditingValue(text: watchViewController.nextServiceDue.value);
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.calendarDays),
      //Always read only
      enabled: false,
      fieldTitle: AppLocalizations.of(Get.context!)!.nextServiceDueRowTitle,
      hintText: AppLocalizations.of(Get.context!)!.nextServiceDueRowHintText,
      maxLines: 1,
      controller: nextServiceDueFieldController,
      textCapitalization: TextCapitalization.none,
    );
  }
}
