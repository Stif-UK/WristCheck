import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/ui/decoration/formfield_decoration.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:wristcheck/util/string_extension.dart';

class PrimaryColourRow extends StatefulWidget {
  const PrimaryColourRow({
    super.key,
    required this.enabled,
    required this.primaryColourFieldController,
  });

  final bool enabled;
  final TextEditingController primaryColourFieldController;

  @override
  State<PrimaryColourRow> createState() => _PrimaryColourRowState();
}

class _PrimaryColourRowState extends State<PrimaryColourRow> {
  TextEditingController? _autocompleteController;

  @override
  void initState() {
    super.initState();
    widget.primaryColourFieldController.addListener(_onExternalControllerChanged);
  }

  @override
  void didUpdateWidget(covariant PrimaryColourRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.primaryColourFieldController != widget.primaryColourFieldController) {
      oldWidget.primaryColourFieldController.removeListener(_onExternalControllerChanged);
      widget.primaryColourFieldController.addListener(_onExternalControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.primaryColourFieldController.removeListener(_onExternalControllerChanged);
    super.dispose();
  }

  void _onExternalControllerChanged() {
    if (_autocompleteController != null &&
        _autocompleteController!.text != widget.primaryColourFieldController.text) {
      _autocompleteController!.text = widget.primaryColourFieldController.text;
    }
  }

  List<String> _getExistingPrimaryColours() {
    final watchBox = Boxes.getWatches();
    final colours = <String>{};
    for (final watch in watchBox.values) {
      if (watch.primaryColour != null && watch.primaryColour!.trim().isNotEmpty) {
        colours.add(watch.primaryColour!.trim());
      }
    }
    final list = colours.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: widget.primaryColourFieldController.text),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        final options = _getExistingPrimaryColours();
        return options.where((String option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        widget.primaryColourFieldController.text = selection;
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        _autocompleteController = fieldTextEditingController;
        fieldTextEditingController.addListener(() {
          if (widget.primaryColourFieldController.text != fieldTextEditingController.text) {
            widget.primaryColourFieldController.text = fieldTextEditingController.text;
          }
        });

        return WatchFormField(
          icon: const FaIcon(FontAwesomeIcons.palette),
          enabled: widget.enabled,
          fieldTitle: AppLocalizations.of(Get.context!)!.primaryColourRowTitle,
          hintText: AppLocalizations.of(Get.context!)!.primaryColourHintText,
          maxLines: 1,
          controller: fieldTextEditingController,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          textCapitalization: TextCapitalization.words,
          validator: (String? val) {
            if (val != null && val.isNotEmpty && !val.isAlphaOrEmpty) {
              return AppLocalizations.of(Get.context!)!.primaryColourInvalidError;
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
