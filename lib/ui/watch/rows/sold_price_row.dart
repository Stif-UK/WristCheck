import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:wristcheck/util/string_extension.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class SoldPriceRow extends StatelessWidget {
  const SoldPriceRow({super.key, required this.enabled, required this.soldPriceFieldController, required this.viewState, required this.locale, required this.price, this.bodyLarge, this.headlineSmall});
  final bool enabled;
  final TextEditingController soldPriceFieldController;
  final WatchViewEnum viewState;
  final String locale;
  final int price;
  final TextStyle? bodyLarge;
  final TextStyle? headlineSmall;




  @override
  Widget build(BuildContext context) {
      //if state is add or edit, return a formfield to take an integer input otherwise return a field returning a view of the price
      return viewState != WatchViewEnum.view
          ? WatchFormField(
        icon: const Icon(FontAwesomeIcons.handHoldingDollar),
        enabled: enabled,
        fieldTitle: AppLocalizations.of(Get.context!)!.soldPriceRowTitle,
        hintText: AppLocalizations.of(Get.context!)!.soldPriceRowHintText,
        maxLines: 1,
        controller: soldPriceFieldController,
        keyboardType: TextInputType.number,
        textCapitalization: TextCapitalization.none,
        validator: (String? val) {
          if (!val!.isWcCurrency) {
            return AppLocalizations.of(Get.context!)!.digitsNoDecimalsError;
          }
        },
      )
          :
      //Alternate return view
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(Get.context!)!.soldPriceRowTitle,
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
                  WristCheckFormatter.getCurrencyValue(locale, price, 0),
                  style: headlineSmall,),
              ),
            ],
          )
        ],
      )
      ;
    }
}
