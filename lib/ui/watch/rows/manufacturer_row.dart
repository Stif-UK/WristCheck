import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:wristcheck/util/string_extension.dart';

class ManufacturerRow extends StatelessWidget {
  const ManufacturerRow({super.key, required this.enabled, required this.manufacturerFieldController});
  final bool enabled;
  final TextEditingController manufacturerFieldController;


  @override
  Widget build(BuildContext context) {
      return WatchFormField(
        icon: const Icon(FontAwesomeIcons.building),
        enabled: enabled,
        fieldTitle: "Manufacturer:",
        hintText: "Manufacturer",
        maxLines: 1,
        controller: manufacturerFieldController,
        textCapitalization: TextCapitalization.words,
        validator: (String? val) {
          if(!val!.isAlphaNumericIncCyrillicAndNotEmpty) {
            return 'Manufacturer missing or invalid characters included';
          }
        },
      );
    }
}
