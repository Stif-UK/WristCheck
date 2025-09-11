import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/watch/rows/purchase_price_row.dart';
import 'package:wristcheck/ui/watch/rows/purchased_from_row.dart';
import 'package:wristcheck/ui/watch/rows/sold_price_row.dart';
import 'package:wristcheck/ui/watch/rows/sold_to_row.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:get/get.dart';
import 'package:wristcheck/util/string_extension.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class ValueTab extends StatelessWidget {
  ValueTab({super.key,
    required this.purchasePriceFieldController,
    required this.purchasedFromFieldController,
    required this.soldPriceFieldController,
    required this.soldToFieldController,
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
  final Watches? currentWatch;
  final TextStyle? bodyLarge;
  final TextStyle? headlineSmall;
  final String locale;

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(()=> PurchasePriceRow(enabled: watchViewController.inEditState.value, purchasePriceFieldController: purchasePriceFieldController, viewState: watchViewController.watchViewState.value, locale: locale,
                price: watchViewController.purchasePrice.value, bodyLarge: bodyLarge, headlineSmall: headlineSmall,)),
            //_purchasePriceRow(locale),
            Obx(()=> PurchasedFromRow(enabled: watchViewController.inEditState.value, purchasedFromFieldController: purchasedFromFieldController)),
            watchViewController.selectedStatus.value == "Sold" ? Obx(()=> SoldPriceRow(enabled: watchViewController.inEditState.value, soldPriceFieldController: soldPriceFieldController, viewState: watchViewController.watchViewState.value,locale: locale,
            price: watchViewController.soldPrice.value, bodyLarge: bodyLarge, headlineSmall: headlineSmall,)): const SizedBox(height: 0,),
            watchViewController.selectedStatus.value == "Sold" ? Obx(()=> SoldToRow(enabled: watchViewController.inEditState.value, soldToFieldController: soldToFieldController)): const SizedBox(height: 0,),
            _costPerWearRow(locale)
          ],

        )
    );
  }

  Widget _costPerWearRow(String locale) {
    double costPerWear = 0.0;
    if (currentWatch != null) {
      costPerWear = WatchMethods.calculateCostPerWear(currentWatch!);
    }
    //Read only field
    return watchViewController.watchViewState.value == WatchViewEnum.view
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Cost per Wear:",
          textAlign: TextAlign.start,
          style: bodyLarge,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(FontAwesomeIcons.moneyCheckDollar),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                costPerWear == 0 ? "N/A" : NumberFormat.simpleCurrency(
                    locale: locale, decimalDigits: null).format(costPerWear),
                style: headlineSmall,),
            ),
          ],
        )
      ],
    )
        : const SizedBox(height: 0,);
  }

}