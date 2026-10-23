import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/ui/decoration/formfield_decoration.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:wristcheck/util/string_extension.dart';

class ManufacturerRow extends StatefulWidget {
  const ManufacturerRow({
    super.key,
    required this.enabled,
    required this.manufacturerFieldController,
  });

  final bool enabled;
  final TextEditingController manufacturerFieldController;

  @override
  State<ManufacturerRow> createState() => _ManufacturerRowState();
}

class _ManufacturerRowState extends State<ManufacturerRow> {
  TextEditingController? _autocompleteController;

  @override
  void initState() {
    super.initState();
    widget.manufacturerFieldController.addListener(_onExternalControllerChanged);
  }

  @override
  void didUpdateWidget(covariant ManufacturerRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.manufacturerFieldController != widget.manufacturerFieldController) {
      oldWidget.manufacturerFieldController.removeListener(_onExternalControllerChanged);
      widget.manufacturerFieldController.addListener(_onExternalControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.manufacturerFieldController.removeListener(_onExternalControllerChanged);
    super.dispose();
  }

  void _onExternalControllerChanged() {
    if (_autocompleteController != null &&
        _autocompleteController!.text != widget.manufacturerFieldController.text) {
      _autocompleteController!.text = widget.manufacturerFieldController.text;
    }
  }

  List<String> _getExistingManufacturers() {
    final watchBox = Boxes.getWatches();
    final manufacturers = <String>{};
    for (final watch in watchBox.values) {
      if (watch.manufacturer.trim().isNotEmpty) {
        manufacturers.add(watch.manufacturer.trim());
      }
    }
    final list = manufacturers.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: widget.manufacturerFieldController.text),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        final options = _getExistingManufacturers();
        return options.where((String option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        widget.manufacturerFieldController.text = selection;
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        _autocompleteController = fieldTextEditingController;
        fieldTextEditingController.addListener(() {
          if (widget.manufacturerFieldController.text != fieldTextEditingController.text) {
            widget.manufacturerFieldController.text = fieldTextEditingController.text;
          }
        });

        return WatchFormField(
          icon: const FaIcon(FontAwesomeIcons.building),
          enabled: widget.enabled,
          fieldTitle: AppLocalizations.of(Get.context!)!.manufacturerRowTitle,
          hintText: AppLocalizations.of(Get.context!)!.manufacturerRowHintText,
          maxLines: 1,
          controller: fieldTextEditingController,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          textCapitalization: TextCapitalization.words,
          validator: (String? val) {
            if (val == null || !val.isAlphaNumericIncCyrillicAndNotEmpty) {
              return AppLocalizations.of(Get.context!)!.manufacturerInvalidError;
            }
            return null;
          },
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected,
          Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            color: WristCheckFormFieldDecoration.getDropDownBackground() ??
                Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return InkWell(
                    onTap: () {
                      onSelected(option);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: Text(
                        option,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
