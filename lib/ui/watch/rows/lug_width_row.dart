import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/util/string_extension.dart';

import '../../widgets/watch_formfield.dart';

class LugWidthRow extends StatelessWidget {
  const LugWidthRow({super.key, required this.enabled, required this.lugWidthController});
  final bool enabled;
  final TextEditingController lugWidthController;

  @override
  Widget build(BuildContext context) {
    return WatchFormField(
      keyboardType: TextInputType.number,
      icon: const Icon(FontAwesomeIcons.rulerHorizontal),
      enabled: enabled,
      fieldTitle: AppLocalizations.of(context)!.lugWidthRowTitle,
      hintText: AppLocalizations.of(context)!.lugWidthHintText,
      maxLines: 1,
      controller: lugWidthController,
      textCapitalization: TextCapitalization.none,
      validator: (String? val) {
        if(!val!.isServiceNumber) {
          return AppLocalizations.of(Get.context!)!.mustBeWholeNumberLessThan99;
        }
      },
    );
  }
}
