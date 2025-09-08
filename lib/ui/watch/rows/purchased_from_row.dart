import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
}
