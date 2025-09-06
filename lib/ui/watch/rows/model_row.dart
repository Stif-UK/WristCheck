import 'package:flutter/material.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:wristcheck/util/string_extension.dart';

class ModelRow extends StatelessWidget {
  const ModelRow({super.key, required this.enabled, required this.modelFieldController});
  final bool enabled;
  final TextEditingController modelFieldController;

  @override
  Widget build(BuildContext context) {
      return WatchFormField(
        icon: const Icon(Icons.watch),
        enabled: enabled,
        fieldTitle: "Model:",
        hintText: "Model",
        maxLines: 1,
        controller: modelFieldController,
        textCapitalization: TextCapitalization.words,
        validator: (String? val) {
          if(!val!.isAlphaNumericIncCyrillicAndNotEmpty) {
            return 'Model is missing or invalid characters included';
          }
        },
      );
    }
}
