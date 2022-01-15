import 'package:flutter/material.dart';

class WristCheckHome extends StatefulWidget{

  @override
  _WristCheckHomeState createState() => _WristCheckHomeState();
}

class _WristCheckHomeState extends State<WristCheckHome> {

  int _currentIndex = 0;



  @override
  Widget build(BuildContext context) {


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
        actions: [
          IconButton(onPressed: onSettingsPressed, icon: const Icon(Icons.settings)),
        ],
      ),

      drawer:  Drawer(
        backgroundColor: Theme.of(context).backgroundColor,
        child: ListView(
          children:  [
            DrawerHeader(child: Container(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close), onPressed: () { Navigator.of(context).pop(); },
              ),
            )),
            ListTile(),
            Divider(),
            ListTile(),
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