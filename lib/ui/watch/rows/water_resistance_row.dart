import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:wristcheck/util/string_extension.dart';

class WaterResistanceRow extends StatelessWidget {
  const WaterResistanceRow({super.key, required this.enabled, required this.waterResistanceController, required this.units});
  final bool enabled;
  final TextEditingController waterResistanceController;
  final String units;

  @override
  Widget build(BuildContext context) {
    return WatchFormField(
      keyboardType: TextInputType.number,
      icon: const Icon(FontAwesomeIcons.water),
      enabled: enabled,
      fieldTitle: "Water Resistance ($units):",
      hintText: "Water Resistance",
      maxLines: 1,
      controller: waterResistanceController,
      textCapitalization: TextCapitalization.none,
      validator: (String? val) {
        if(!val!.isUnboundPositiveInteger) {
          return 'Must be a whole number';
        }
      },
    );
  }
}
