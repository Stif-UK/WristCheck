import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:wristcheck/util/string_extension.dart';

class CaseDiameterRow extends StatelessWidget {
  const CaseDiameterRow({super.key, required this.enabled, required this.caseDiameterController});
  final bool enabled;
  final TextEditingController caseDiameterController;

  @override
  Widget build(BuildContext context) {
    return WatchFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      icon: const Icon(FontAwesomeIcons.rulerCombined),
      enabled: enabled,
      fieldTitle: "Case Diameter(mm):",
      hintText: "Case Diameter",
      maxLines: 1,
      controller: caseDiameterController,
      textCapitalization: TextCapitalization.none,
      validator: (String? val) {
        if(!val!.isDouble) {
          return 'Must be numbers only with up to two decimal points';
        }
      },
    );
  }
}
