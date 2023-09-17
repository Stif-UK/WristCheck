import 'package:flutter/material.dart';

class WristCheckFormFieldDecoration{

  static getFormFieldDecoration(Icon? icon, BuildContext context){
    return InputDecoration(
        icon: icon,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: Theme.of(context).focusColor),
            borderRadius: BorderRadius.circular(20.0)
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 3, color: Colors.lightBlue),
            borderRadius: BorderRadius.circular(20.0)
        )

    );
  }

  static getFormFieldPadding(){
    return const EdgeInsets.all(10.0);
  }
}