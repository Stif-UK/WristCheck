import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        fieldTitle: viewState == WatchViewEnum.add? "Reference Number (Optional)": "Reference Number:",
        hintText: "Reference Number",
        maxLines: 1,
        controller: referenceNumberFieldController,
        textCapitalization: TextCapitalization.none,
        validator: (String? val) {
          if(!val!.isAlphaNumericWithSymbolsOrEmpty) {
            return 'Reference Number is missing or invalid characters included';
          }
        },
      );
    }
}
