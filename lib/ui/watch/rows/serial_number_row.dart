import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:wristcheck/util/string_extension.dart';

class SerialNumberRow extends StatelessWidget {
  const SerialNumberRow({super.key, required this.serialNumberFieldController, required this.enabled, required this.viewState});
  final TextEditingController serialNumberFieldController;
  final WatchViewEnum viewState;
  final bool enabled;

  @override
  Widget build(BuildContext context) {

      return WatchFormField(
        icon: const Icon(FontAwesomeIcons.barcode),
        enabled: enabled,
        fieldTitle: viewState == WatchViewEnum.add? "Serial Number (Optional)": "Serial Number:",
        hintText: "Serial Number",
        maxLines: 1,
        controller: serialNumberFieldController,
        textCapitalization: TextCapitalization.none,
        validator: (String? val) {
          if(!val!.isAlphaNumericWithSymbolsOrEmpty) {
            return 'Serial Number contains invalid characters';
          }
        },
      );
    }
}
