import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';

class PurchaseDateRow extends StatelessWidget {
  const PurchaseDateRow({super.key, required this.enabled, required this.purchaseDateFieldController});
  final bool enabled;
  final TextEditingController purchaseDateFieldController;

  @override
  Widget build(BuildContext context) {
      return WatchFormField(
        icon: const Icon(FontAwesomeIcons.calendar),
        enabled: enabled,
        fieldTitle: "Purchase Date:",
        hintText: "Purchase Date",
        maxLines: 1,
        datePicker: true,
        controller: purchaseDateFieldController,
        textCapitalization: TextCapitalization.none,
      );
    }
}
