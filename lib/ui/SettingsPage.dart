import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';




class SettingsPage extends StatefulWidget{

@override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool _darkModeToggle = false;
  final watchBox = Boxes.getWatches();


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
          ),
          Divider(),
          ListTile(
            title:Text("Delete collection"),
            leading: Icon(Icons.warning),
            trailing: OutlinedButton(
              child: Icon(Icons.delete, color: Colors.red),
              onPressed: (){
                Get.defaultDialog(
                  title: "Warning",
                  middleText: "Pressing OK will delete all watch data, including your wishlist\n \n THIS CANNOT BE UNDONE",
                  textConfirm: "OK",
                  textCancel: "Cancel",
                  onConfirm: (){
                    //On pressing ok, call the .clear() method on the watchbox
                    watchBox.clear();
                    Get.back();
                    Get.snackbar(
                      "Watches Cleared",
                      "Your watch collection is now empty",
                      icon: Icon(Icons.delete),
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }

                );
              }
            )
          ),
          Divider()
        ],
      ),


    );
  }
}