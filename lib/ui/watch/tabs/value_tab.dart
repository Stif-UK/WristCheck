import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/watch_status_enum.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/decoration/formfield_decoration.dart';
import 'package:wristcheck/ui/watch/rows/current_value_row.dart';
import 'package:wristcheck/ui/watch/rows/purchase_price_row.dart';
import 'package:wristcheck/ui/watch/rows/purchased_from_row.dart';
import 'package:wristcheck/ui/watch/rows/sold_price_row.dart';
import 'package:wristcheck/ui/watch/rows/sold_to_row.dart';
import 'package:wristcheck/ui/widgets/responsive_two_column_grid.dart';

class ValueTab extends StatelessWidget {
  ValueTab({super.key,
    required this.purchasePriceFieldController,
    required this.purchasedFromFieldController,
    required this.soldPriceFieldController,
    required this.soldToFieldController,
    required this.currentValueFieldController,
    required this.currentWatch,
    required this.bodyLarge,
    required this.headlineSmall,
    required this.locale
  });

  final watchViewController = Get.put(WatchViewController());
  final TextEditingController purchasePriceFieldController;
  final TextEditingController purchasedFromFieldController;
  final TextEditingController soldPriceFieldController;
  final TextEditingController soldToFieldController;
  final TextEditingController currentValueFieldController;
  final Watches? currentWatch;
  final TextStyle? bodyLarge;
  final TextStyle? headlineSmall;
  final String locale;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSold =
          watchViewController.selectedStatus.value == WatchStatusEnum.sold.toDbString();
      final isView = watchViewController.watchViewState.value == WatchViewEnum.view;

      return ResponsiveTwoColumnGrid(
        children: [
          PurchasePriceRow(
            enabled: watchViewController.inEditState.value,
            purchasePriceFieldController: purchasePriceFieldController,
            viewState: watchViewController.watchViewState.value,
            locale: locale,
            price: watchViewController.purchasePrice.value,
            bodyLarge: bodyLarge,
            headlineSmall: headlineSmall,
          ),
          PurchasedFromRow(
            enabled: watchViewController.inEditState.value,
            purchasedFromFieldController: purchasedFromFieldController,
          ),
          if (isSold)
            SoldPriceRow(
              enabled: watchViewController.inEditState.value,
              soldPriceFieldController: soldPriceFieldController,
              viewState: watchViewController.watchViewState.value,
              locale: locale,
              price: watchViewController.soldPrice.value,
              bodyLarge: bodyLarge,
              headlineSmall: headlineSmall,
            ),
          if (isSold)
            SoldToRow(
              enabled: watchViewController.inEditState.value,
              soldToFieldController: soldToFieldController,
            ),
          CurrentValueRow(
            enabled: watchViewController.inEditState.value,
            currentValueFieldController: currentValueFieldController,
            viewState: watchViewController.watchViewState.value,
            locale: locale,
            price: watchViewController.currentValue.value,
            bodyLarge: bodyLarge,
            headlineSmall: headlineSmall,
          ),
          if (isView) _costPerWearRow(context, locale),
        ],
      );
    });
  }

  Widget _costPerWearRow(BuildContext context, String locale) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations.of(Get.context!)!;
    double costPerWear = 0.0;
    if (currentWatch != null) {
      costPerWear = WatchMethods.calculateCostPerWear(currentWatch!);
    }
    return Padding(
      padding: WristCheckFormFieldDecoration.getFormFieldPadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.costPerWearRowTitle,
            textAlign: TextAlign.start,
            style: bodyLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: FaIcon(FontAwesomeIcons.moneyCheckDollar),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    costPerWear == 0
                        ? l10n.na
                        : NumberFormat.simpleCurrency(
                            locale: locale,
                            decimalDigits: null,
                          ).format(costPerWear),
                    style: headlineSmall,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}