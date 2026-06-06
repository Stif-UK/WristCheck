import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:wristcheck/util/string_extension.dart';

class ReferenceNumberRow extends StatelessWidget {
  const ReferenceNumberRow({super.key, required this.enabled, required this.referenceNumberFieldController, required this.viewState});
  final bool enabled;
  final TextEditingController referenceNumberFieldController;
  final WatchViewEnum viewState;

  @override
  Widget build(BuildContext context) {
      return WatchFormField(
        icon: const Icon(FontAwesomeIcons.hashtag),
        enabled: enabled,
        fieldTitle: viewState == WatchViewEnum.add? AppLocalizations.of(Get.context!)!.referenceNumberOptionalTitle: AppLocalizations.of(Get.context!)!.referenceNumberRowTitle,
        hintText: AppLocalizations.of(Get.context!)!.referenceNumberRowHelpText,
        maxLines: 1,
        controller: referenceNumberFieldController,
        textCapitalization: TextCapitalization.none,
        validator: (String? val) {
          if(!val!.isAlphaNumericWithSymbolsOrEmpty) {
            return AppLocalizations.of(Get.context!)!.referenceNumberErrorText;
          }
        },
      );
    }
}
