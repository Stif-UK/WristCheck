import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:wristcheck/util/string_extension.dart';

class PurchasedFromRow extends StatelessWidget {
  const PurchasedFromRow({super.key, required this.enabled, required this.purchasedFromFieldController});
  final bool enabled;
  final TextEditingController purchasedFromFieldController;

  @override
  Widget build(BuildContext context) {
      return WatchFormField(
        icon: const Icon(FontAwesomeIcons.cartShopping),
        enabled: enabled,
        fieldTitle: AppLocalizations.of(Get.context!)!.purchasedFromRowTitle,
        hintText: AppLocalizations.of(Get.context!)!.purchasedFromHintText,
        maxLines: 1,
        controller: purchasedFromFieldController,
        textCapitalization: TextCapitalization.sentences,
        validator: (String? val) {
          if (!val!.isAlphaNumericWithSymbolsOrEmpty) {
            return AppLocalizations.of(Get.context!)!.invalidCharactersDetected;
          }
        },
      );
    }
}
