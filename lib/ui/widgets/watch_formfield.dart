import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/ui/decoration/formfield_decoration.dart';

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
    this.keyboardType,
    this.datePicker
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
  final bool? datePicker;


  @override
  Widget build(BuildContext context) {
    var date = datePicker ?? false;
    return Padding(
      padding: WristCheckFormFieldDecoration.getFormFieldPadding(),
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
            //If datepicker is requested, show picker and add to controller
            onTap: date? () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100)
              );
              if(pickedDate != null){
                controller.text = DateFormat('yMMMd').format(pickedDate);
            }
            }
                :null,
            decoration: WristCheckFormFieldDecoration.getFormFieldDecoration(icon, context)

          ),
        ],
      ),
    );
  }
}
