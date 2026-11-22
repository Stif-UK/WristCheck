import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/watch_status_enum.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/watch/rows/last_serviced_row.dart';
import 'package:wristcheck/ui/watch/rows/purchase_date_row.dart';
import 'package:wristcheck/ui/watch/rows/sold_date_row.dart';
import 'package:wristcheck/ui/watch/rows/warranty_end_row.dart';
import 'package:wristcheck/ui/widgets/responsive_two_column_grid.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:wristcheck/util/string_extension.dart';

class DatesTab extends StatelessWidget {
  DatesTab({super.key,
    required this.modelYearFieldController,
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
  final TextEditingController modelYearFieldController;
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
    return Obx(() {
      final isPreOrder =
          watchViewController.selectedStatus.value == WatchStatusEnum.preOrder.toDbString();
      final isSold =
          watchViewController.selectedStatus.value == WatchStatusEnum.sold.toDbString();
      final isView = watchViewController.watchViewState.value == WatchViewEnum.view;

      return ResponsiveTwoColumnGrid(
        children: [
          if (isPreOrder) _deliveryDateRow(context),
          _modelYearRow(context),
          PurchaseDateRow(
            enabled: watchViewController.inEditState.value,
            purchaseDateFieldController: purchaseDateFieldController,
          ),
          if (isSold)
            SoldDateRow(
              enabled: watchViewController.inEditState.value,
              soldDateFieldController: soldDateFieldController,
            ),
          if (isView) _timeInCollectionRow(context),
          WarrantyEndRow(
            enabled: watchViewController.inEditState.value,
            warrantyEndDateFieldController: warrantyEndDateFieldController,
          ),
          LastServicedRow(
            enabled: watchViewController.inEditState.value,
            lastServicedDateFieldController: lastServicedDateFieldController,
          ),
          _serviceIntervalRow(context),
          if (isView) _nextServiceDueRow(context),
        ],
      );
    });
  }

  Widget _modelYearRow(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations.of(Get.context!)!;
    return WatchFormField(
      keyboardType: TextInputType.number,
      icon: const FaIcon(FontAwesomeIcons.calendar),
      enabled: watchViewController.inEditState.value,
      fieldTitle: l10n.modelYearRowTitle,
      hintText: l10n.modelYearRowHintText,
      maxLines: 1,
      controller: modelYearFieldController,
      textCapitalization: TextCapitalization.none,
      validator: (String? val) {
        if (val != null && !val.isFourDigitYear) {
          return l10n.mustBe4DigitYearOrBlank;
        }
        return null;
      },
    );
  }

  Widget _deliveryDateRow(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations.of(Get.context!)!;
    return WatchFormField(
      icon: const FaIcon(FontAwesomeIcons.calendar),
      enabled: watchViewController.inEditState.value,
      fieldTitle: l10n.preOrderDueDateRowTitle,
      hintText: l10n.preOrderDueDateRowHintText,
      maxLines: 1,
      datePicker: true,
      controller: deliveryDateFieldController,
      textCapitalization: TextCapitalization.none,
    );
  }

  Widget _timeInCollectionRow(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations.of(Get.context!)!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: WatchFormField(
            icon: const FaIcon(FontAwesomeIcons.hourglass),
            enabled: false,
            fieldTitle: l10n.timeInCollectionRowTitle,
            hintText: l10n.timeInCollectionRowTitle,
            textCapitalization: TextCapitalization.none,
            controller: timeInCollectionFieldController,
          ),
        ),
        IconButton(
          icon: watchViewController.showDays.value
              ? const FaIcon(FontAwesomeIcons.solidCalendarMinus)
              : const FaIcon(FontAwesomeIcons.solidCalendarPlus),
          onPressed: () {
            final newShowDays = !watchViewController.showDays.value;
            watchViewController.updateShowdays(newShowDays);
            if (currentWatch != null) {
              final newTime = WatchMethods.calculateTimeInCollection(currentWatch!, newShowDays);
              watchViewController.updateTimeInCollection(newTime);
              timeInCollectionFieldController.text = newTime;
            }
          },
        )
      ],
    );
  }

  Widget _serviceIntervalRow(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations.of(Get.context!)!;
    return WatchFormField(
      keyboardType: TextInputType.number,
      icon: const FaIcon(FontAwesomeIcons.arrowsSpin),
      enabled: watchViewController.inEditState.value,
      fieldTitle: l10n.serviceIntervalRowTitle,
      hintText: l10n.serviceIntervalRowHintText,
      maxLines: 1,
      controller: serviceIntervalFieldController,
      textCapitalization: TextCapitalization.none,
      validator: (String? val) {
        if (!val!.isServiceNumber) {
          return l10n.mustBe099orBlank;
        }
        return null;
      },
    );
  }

  Widget _nextServiceDueRow(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations.of(Get.context!)!;
    return WatchFormField(
      icon: const FaIcon(FontAwesomeIcons.calendarDays),
      //Always read only
      enabled: false,
      fieldTitle: l10n.nextServiceDueRowTitle,
      hintText: l10n.nextServiceDueRowHintText,
      maxLines: 1,
      controller: nextServiceDueFieldController,
      textCapitalization: TextCapitalization.none,
    );
  }
}
