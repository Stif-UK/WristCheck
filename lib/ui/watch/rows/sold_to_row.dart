import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:wristcheck/util/string_extension.dart';

class SoldToRow extends StatelessWidget {
  const SoldToRow({super.key, required this.enabled, required this.soldToFieldController});
  final bool enabled;
  final TextEditingController soldToFieldController;

  @override
  Widget build(BuildContext context) {
      return WatchFormField(
        icon: const Icon(FontAwesomeIcons.handHoldingHand),
        enabled: enabled,
        fieldTitle: AppLocalizations.of(Get.context!)!.soldToRowTitle,
        hintText: AppLocalizations.of(Get.context!)!.soldToRowHintText,
        maxLines: 1,
        controller: soldToFieldController,
        textCapitalization: TextCapitalization.sentences,
        validator: (String? val) {
          if (!val!.isAlphaNumericWithSymbolsOrEmpty) {
            return AppLocalizations.of(Get.context!)!.invalidCharactersDetected;
          }
        },
      );
    }
}
