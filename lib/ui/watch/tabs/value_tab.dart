import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
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
            _purchasePriceRow(locale),
            Obx(()=> _purchaseFromRow()),
            watchViewController.selectedStatus.value == "Sold" ? Obx(()=> _soldPriceRow(locale)): const SizedBox(height: 0,),
            watchViewController.selectedStatus.value == "Sold" ? Obx(()=> _soldToRow()): const SizedBox(height: 0,),
            _costPerWearRow(locale)
          ],

        )
    );
  }


  Widget _purchasePriceRow(String locale) {
    //if state is add or edit, return a formfield to take an integer input otherwise return a field returning a view of the price
    return watchViewController.watchViewState.value != WatchViewEnum.view
        ? Obx(() =>
        WatchFormField(
          icon: const Icon(FontAwesomeIcons.moneyBill1),
          enabled: watchViewController.inEditState.value,
          fieldTitle: "Purchase Price:",
          hintText: "Purchased Price",
          maxLines: 1,
          controller: purchasePriceFieldController,
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.none,
          validator: (String? val) {
            if (!val!.isWcCurrency) {
              return "Enter digits only, no decimals, we'll take care of the rest!";
            }
          },
        ),
    )
        :
    //Alternate return view
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Purchase Price:",
          textAlign: TextAlign.start,
          style: bodyLarge,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(FontAwesomeIcons.moneyBill1),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                WristCheckFormatter.getCurrencyValue(locale, watchViewController.purchasePrice.value, 0),
                style: headlineSmall,),
            ),
          ],
        )
      ],
    )
    ;
  }

  Widget _purchaseFromRow() {
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.cartShopping),
      enabled: watchViewController.inEditState.value,
      fieldTitle: "Purchased From:",
      hintText: "Purchased From",
      maxLines: 1,
      controller: purchasedFromFieldController,
      textCapitalization: TextCapitalization.sentences,
      validator: (String? val) {
        if (!val!.isAlphaNumericWithSymbolsOrEmpty) {
          return 'Invalid characters detected.';
        }
      },
    );
  }

  Widget _soldPriceRow(String locale) {
    //if state is add or edit, return a formfield to take an integer input otherwise return a field returning a view of the price
    return watchViewController.watchViewState.value != WatchViewEnum.view
        ? WatchFormField(
      icon: const Icon(FontAwesomeIcons.handHoldingDollar),
      enabled: watchViewController.inEditState.value,
      fieldTitle: "Sold Price:",
      hintText: "Sold Price",
      maxLines: 1,
      controller: soldPriceFieldController,
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.none,
      validator: (String? val) {
        if (!val!.isWcCurrency) {
          return "Enter digits only, no decimals, we'll take care of the rest!";
        }
      },
    )
        :
    //Alternate return view
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Sold Price:",
          textAlign: TextAlign.start,
          style: bodyLarge,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(FontAwesomeIcons.handHoldingDollar),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                WristCheckFormatter.getCurrencyValue(locale, watchViewController.soldPrice.value, 0),
                style: headlineSmall,),
            ),
          ],
        )
      ],
    )
    ;
  }

  Widget _soldToRow() {
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.handHoldingHand),
      enabled: watchViewController.inEditState.value,
      fieldTitle: "Sold To:",
      hintText: "Sold to",
      maxLines: 1,
      controller: soldToFieldController,
      textCapitalization: TextCapitalization.sentences,
      validator: (String? val) {
        if (!val!.isAlphaNumericWithSymbolsOrEmpty) {
          return 'Invalid characters detected.';
        }
      },
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