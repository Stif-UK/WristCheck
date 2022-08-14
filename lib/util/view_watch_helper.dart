import 'package:flutter/material.dart';

class ViewWatchHelper{

  static Icon getEditIcon(bool editable){
    return !editable ? const Icon(Icons.edit) : const Icon(Icons.save);

  }
}