import 'package:wristcheck/model/watches.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:wristcheck/boxes.dart';

class DatabaseProvider extends ChangeNotifier {

  int _selectedIndex = 0;

  Box<Watches> _watchBox = Boxes.getWatches();

  Watches _selectedWatch = Watches();

  Box<Watches> get watchesBox => _watchBox;

  Watches get selectedWatch => _selectedWatch;

  ///* Updating the current selected index for that contact to pass to read from hive
  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    updateSelectedWatch();
    notifyListeners();
  }

  ///* Updating the current selected contact from hive
  void updateSelectedWatch() {
    _selectedWatch = readFromHive();
    notifyListeners();
  }

  ///* reading the current selected contact from hive
  Watches readFromHive() {
    Watches getWatch = _watchBox.getAt(_selectedIndex)!;

    return getWatch;
  }

  void deleteFromHive(){
    _watchBox.deleteAt(_selectedIndex);
  }
}