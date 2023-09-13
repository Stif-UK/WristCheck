import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WatchFormField extends StatelessWidget {
  const WatchFormField({
    Key? key,
    required this.fieldTitle,
    required this.hintText,
    this.minLines,
    this.maxLines,
    this.inputFormatters,
    this.validator,
    required this.textCapitalization,
    required this.controller,
    required this.enabled,
    this.icon,
    this.keyboardType
  }) : super(key: key);

  final String fieldTitle;
  final String hintText;
  final int? minLines;
  final int? maxLines;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final bool enabled;
  final Icon? icon;
  final TextInputType? keyboardType;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(fieldTitle,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyLarge,),
          TextFormField(
            keyboardType: keyboardType,
            enabled: enabled,
            textCapitalization: textCapitalization,
            controller: controller,
            minLines: minLines,
            maxLines: maxLines,
            validator: validator,
            decoration: InputDecoration(
              icon: icon,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Theme.of(context).focusColor),
                    borderRadius: BorderRadius.circular(20.0)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 3, color: Colors.lightBlue),
                    borderRadius: BorderRadius.circular(20.0)
                )

            ),

          ),
        ],
      ),
    );
  }
}
