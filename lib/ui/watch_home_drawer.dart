import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/SettingsPage.dart';
import 'package:wristcheck/ui/PrivacyPolicy.dart';
import 'package:wristcheck/ui/AboutApp.dart';

class WatchHomeDrawer extends StatelessWidget {
  const WatchHomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).backgroundColor,
      child: ListView(
        children:  [
          DrawerHeader(child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,

            children: [

              Container(
                alignment: Alignment.topLeft,
                child: const Text("WristCheck",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    //fontWeight: FontWeight.bold,
                      fontSize: 20.0

                  ),),
              ),

              Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 20.0,), onPressed: () { Navigator.of(context).pop(); },
                ),
              ),
            ],
          )
          ),

          Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: (){
              Get.to(() => SettingsPage());

            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.warning_amber_rounded),
            title: const Text("Privacy Policy"),
            onTap: (){
              Get.to(() => PrivacyPolicy());
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About"),
            onTap: (){
              Get.to(() => AboutApp());
            },
          ),

          Divider(),

        ],

      ),);
  }
}
