import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:wristcheck/util/string_extension.dart';

class PowerReserveRow extends StatelessWidget {
  const PowerReserveRow({
    super.key,
    required this.enabled,
    required this.powerReserveController,
  });

  final bool enabled;
  final TextEditingController powerReserveController;

  @override
  Widget build(BuildContext context) {
    return WatchFormField(
      keyboardType: TextInputType.number,
      icon: const FaIcon(FontAwesomeIcons.batteryFull),
      enabled: enabled,
      fieldTitle: AppLocalizations.of(Get.context!)!.powerReserveRowTitle,
      hintText: AppLocalizations.of(Get.context!)!.powerReserveRowHintText,
      maxLines: 1,
      controller: powerReserveController,
      textCapitalization: TextCapitalization.none,
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return null;
        }
        if (!val.isUnboundPositiveInteger) {
          return AppLocalizations.of(Get.context!)!.mustBeAValidWholeNumber;
        }
        return null;
      },
    );
  }
}
