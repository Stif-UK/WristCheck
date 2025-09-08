import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';

class SoldDateRow extends StatelessWidget {
  const SoldDateRow({super.key, required this.enabled, required this.soldDateFieldController});
  final bool enabled;
  final TextEditingController soldDateFieldController;

  @override
  Widget build(BuildContext context) {
      return WatchFormField(
        icon: const Icon(FontAwesomeIcons.calendarXmark),
        enabled: enabled,
        fieldTitle: "Sold Date:",
        hintText: "Sold Date",
        maxLines: 1,
        datePicker: true,
        controller: soldDateFieldController,
        textCapitalization: TextCapitalization.none,
      );
    }
}
