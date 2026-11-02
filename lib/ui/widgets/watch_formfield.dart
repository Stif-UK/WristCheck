import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/ui/decoration/formfield_decoration.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class WatchFormField extends StatefulWidget {
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
    this.datePicker,
    this.focusNode,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.onObscureTextToggle,
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
  final Widget? icon;
  final TextInputType? keyboardType;
  final bool? datePicker;
  final FocusNode? focusNode;
  final VoidCallback? onFieldSubmitted;
  final bool obscureText;
  final VoidCallback? onObscureTextToggle;

  @override
  State<WatchFormField> createState() => _WatchFormFieldState();
}

class _WatchFormFieldState extends State<WatchFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant WatchFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.obscureText != oldWidget.obscureText) {
      _obscureText = widget.obscureText;
    }
  }

  @override
  Widget build(BuildContext context) {
    var date = widget.datePicker ?? false;
    return Padding(
      padding: WristCheckFormFieldDecoration.getFormFieldPadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.fieldTitle,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyLarge,),
          TextFormField(
            keyboardType: widget.keyboardType,
            enabled: widget.enabled,
            textCapitalization: widget.textCapitalization,
            controller: widget.controller,
            minLines: widget.minLines,
            maxLines: _obscureText ? 1 : widget.maxLines,
            validator: widget.validator,
            focusNode: widget.focusNode,
            obscureText: _obscureText,
            onFieldSubmitted: widget.onFieldSubmitted != null ? (_) => widget.onFieldSubmitted!() : null,
            //If datepicker is requested, show picker and add to controller
            onTap: date? () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100)
              );
              if(pickedDate != null){
                widget.controller.text = WristCheckFormatter.getFormattedDate(pickedDate);
            }
            }
                :null,
            decoration: WristCheckFormFieldDecoration.getFormFieldDecoration(
              widget.icon, 
              context, 
              widget.hintText,
              widget.obscureText
                  ? IconButton(
                      icon: FaIcon(
                        _obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                        size: 20,
                        color: Theme.of(context).hintColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                        if (widget.onObscureTextToggle != null) {
                          widget.onObscureTextToggle!();
                        }
                      },
                    )
                  : null,
            )

          ),
        ],
      ),
    );
  }
}
