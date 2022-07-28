import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget{

@override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool _darkModeToggle = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading:  IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back)),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode_rounded),
            value: _darkModeToggle,
            onChanged: (bool value){
              Get.changeTheme(
                  Get.isDarkMode ? ThemeData.light() : ThemeData.dark()
              );
              setState(() {
                _darkModeToggle = value;

                print(_darkModeToggle);
              });

            },
          )
        ],
      ),


    );
  }
}