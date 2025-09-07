import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';

class LastServicedRow extends StatelessWidget {
  const LastServicedRow({super.key, required this.enabled, required this.lastServicedDateFieldController});
  final bool enabled;
  final TextEditingController lastServicedDateFieldController;

  @override
  Widget build(BuildContext context) {
      return WatchFormField(
        icon: const Icon(FontAwesomeIcons.calendarCheck),
        enabled: enabled,
        fieldTitle: "Last Serviced Date:",
        hintText: "Last Serviced Date",
        maxLines: 1,
        datePicker: true,
        controller: lastServicedDateFieldController,
        textCapitalization: TextCapitalization.none,
      );
    }
}
