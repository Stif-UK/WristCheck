import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/util/string_extension.dart';

import '../../widgets/watch_formfield.dart';

class LugToLugRow extends StatelessWidget {
  const LugToLugRow({super.key, required this.enabled, required this.lug2lugController});
  final bool enabled;
  final TextEditingController lug2lugController;

  @override
  Widget build(BuildContext context) {
    return WatchFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      icon: const Icon(FontAwesomeIcons.ruler),
      enabled: enabled,
      fieldTitle: AppLocalizations.of(context)!.lug2lugRowTitle,
      hintText: AppLocalizations.of(context)!.lug2lugRowHintText,
      maxLines: 1,
      controller: lug2lugController,
      textCapitalization: TextCapitalization.none,
      validator: (String? val) {
        if(!val!.isDouble) {
          return AppLocalizations.of(Get.context!)!.mustBeNumber2decimals;
        }
      },
    );
  }
}
