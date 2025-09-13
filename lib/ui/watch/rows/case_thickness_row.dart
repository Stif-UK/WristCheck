import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/util/string_extension.dart';

import '../../widgets/watch_formfield.dart';

class CaseThicknessRow extends StatelessWidget {
  const CaseThicknessRow({super.key, required this.enabled, required this.caseThicknessController});
  final bool enabled;
  final TextEditingController caseThicknessController;

  @override
  Widget build(BuildContext context) {
    return WatchFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      icon: const Icon(FontAwesomeIcons.rulerVertical),
      enabled: enabled,
      fieldTitle: "Case Thickness(mm):",
      hintText: "Case Thickness",
      maxLines: 1,
      controller: caseThicknessController,
      textCapitalization: TextCapitalization.none,
      validator: (String? val) {
        if(!val!.isDouble) {
          return 'Must be numbers only with up to two decimal points';
        }
      },
    );
  }
}
