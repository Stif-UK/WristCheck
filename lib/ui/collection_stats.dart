import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/ui/collection_stats/collection_charts.dart';
import 'package:wristcheck/ui/collection_stats/collection_info.dart';
import 'package:wristcheck/copy/dialogs.dart';


class CollectionStats extends StatefulWidget {
  const CollectionStats({Key? key}) : super(key: key);

  @override
  State<CollectionStats> createState() => _CollectionStatsState();
}

class _CollectionStatsState extends State<CollectionStats> {

  int _currentIndex = 0;
  final List<Widget> _children =[
    const CollectionInfo(),
    const CollectionCharts()
  ];

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: const Text("Collection Stats"),
        actions: [
          IconButton(onPressed: (){WristCheckDialogs.getCollectionStatsDialog();}, icon: const Icon(Icons.help_outline))
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon:  Icon(FontAwesomeIcons.clipboardList),
            label: "Info",
          ),
          BottomNavigationBarItem(
            icon:  Icon(FontAwesomeIcons.chartBar),
            label: "Charts",
          ),
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
