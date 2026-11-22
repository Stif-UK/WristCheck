import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/ui/decoration/formfield_decoration.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:wristcheck/util/string_extension.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class PurchasePriceRow extends StatelessWidget {
  const PurchasePriceRow({super.key, required this.enabled, required this.purchasePriceFieldController, required this.viewState, required this.locale, required this.price, this.bodyLarge, this.headlineSmall});
  final bool enabled;
  final TextEditingController purchasePriceFieldController;
  final WatchViewEnum viewState;
  final String locale;
  final int price;
  final TextStyle? bodyLarge;
  final TextStyle? headlineSmall;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations.of(Get.context!)!;
    //if state is add or edit, return a formfield to take an integer input otherwise return a field returning a view of the price
    return viewState != WatchViewEnum.view
        ? WatchFormField(
          icon: const FaIcon(FontAwesomeIcons.moneyBill1),
          enabled: enabled,
          fieldTitle: l10n.purchasePriceRowTitle,
          hintText: l10n.purchasePriceRowHintText,
          maxLines: 1,
          controller: purchasePriceFieldController,
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.none,
          validator: (String? val) {
            if (!val!.isWcCurrency) {
              return l10n.digitsNoDecimalsError;
            }
            return null;
          },
        )
        :
    //Alternate return view
    Padding(
      padding: WristCheckFormFieldDecoration.getFormFieldPadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.purchasePriceRowTitle,
            textAlign: TextAlign.start,
            style: bodyLarge,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: FaIcon(FontAwesomeIcons.moneyBill1),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    WristCheckFormatter.getCurrencyValue(locale, price, 0), //watchViewController.purchasePrice.value
                    style: headlineSmall,),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
