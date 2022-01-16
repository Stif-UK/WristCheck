import 'package:flutter/material.dart';
import 'package:wristcheck/ui/AboutApp.dart';
import 'package:wristcheck/ui/PrivacyPolicy.dart';
import 'package:wristcheck/ui/SettingsPage.dart';


class WristCheckHome extends StatefulWidget{

  @override
  _WristCheckHomeState createState() => _WristCheckHomeState();
}

class _WristCheckHomeState extends State<WristCheckHome> {

  int _currentIndex = 0;



  @override
  Widget build(BuildContext context) {


    bool _darkModeToggle = false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: const Text("WristCheck"),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () { Scaffold.of(context).openDrawer(); },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
        }),

      ),

      drawer:  Drawer(
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
            SwitchListTile(
              title: const Text("Dark Mode"),
              secondary: const Icon(Icons.wb_sunny),
              //activeThumbImage: Icon(Icons.dark_mode),

              value: _darkModeToggle,
              onChanged: (bool value){
                setState(() {
                  _darkModeToggle = value;
                });

              },

            ),
            Divider(),
             ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  SettingsPage()));
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.warning_amber_rounded),
              title: const Text("Privacy Policy"),
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  PrivacyPolicy()));
              },
            ),
            Divider(),
             ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About"),
              onTap: (){
                Navigator.push(context, 
                MaterialPageRoute(builder: (context) =>  AboutApp()));
              },
            ),

            Divider(),

          ],

        ),
      ),





      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon:  Icon(Icons.watch),
            label: "Collection",
          ),
          BottomNavigationBarItem(
            icon:  Icon(Icons.bar_chart),
            label: "Stats",
          ),
          BottomNavigationBarItem(
            icon:  Icon(Icons.schedule),
            label: "Service",
          )
        ],
        
      ),
    );
  }

  void onSettingsPressed() {
  }

  void _onTabTapped(int index) {
    setState(() {
       _currentIndex = index;
    });
  }
}