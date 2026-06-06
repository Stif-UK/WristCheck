import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';

class WarrantyEndRow extends StatelessWidget {
  const WarrantyEndRow({super.key, required this.enabled, required this.warrantyEndDateFieldController});
  final bool enabled;
  final TextEditingController warrantyEndDateFieldController;

  @override
  Widget build(BuildContext context) {
      return WatchFormField(
        icon: const Icon(FontAwesomeIcons.screwdriverWrench),
        enabled: enabled,
        fieldTitle: AppLocalizations.of(Get.context!)!.warrantyEndRowTitle,
        hintText: AppLocalizations.of(Get.context!)!.warrantyEndRowHintText,
        maxLines: 1,
        datePicker: true,
        controller: warrantyEndDateFieldController,
        textCapitalization: TextCapitalization.none,
      );
    }
}
