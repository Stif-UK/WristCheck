import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      fieldTitle: "Lug to Lug(mm):",
      hintText: "Lug to Lug",
      maxLines: 1,
      controller: lug2lugController,
      textCapitalization: TextCapitalization.none,
      validator: (String? val) {
        if(!val!.isDouble) {
          return 'Must be numbers only with up to two decimal points';
        }
      },
    );
  }
}
