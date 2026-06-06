import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';

class SoldDateRow extends StatelessWidget {
  const SoldDateRow({super.key, required this.enabled, required this.soldDateFieldController});
  final bool enabled;
  final TextEditingController soldDateFieldController;

  @override
  Widget build(BuildContext context) {
      return WatchFormField(
        icon: const Icon(FontAwesomeIcons.calendarXmark),
        enabled: enabled,
        fieldTitle: AppLocalizations.of(Get.context!)!.soldDateRowTitle,
        hintText: AppLocalizations.of(Get.context!)!.soldDateRowHintText,
        maxLines: 1,
        datePicker: true,
        controller: soldDateFieldController,
        textCapitalization: TextCapitalization.none,
      );
    }
}
