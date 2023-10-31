import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/chart_options.dart';


class WearFilterBottomSheet extends StatefulWidget {
  WearFilterBottomSheet({Key? key}) : super(key: key);

  @override
  State<WearFilterBottomSheet> createState() => _WearFilterBottomSheetState();
}

class _WearFilterBottomSheetState extends State<WearFilterBottomSheet> with SingleTickerProviderStateMixin{
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  final List<Tab> myTabs = <Tab>[
    Tab(
      icon: Icon(FontAwesomeIcons.chartSimple),
      text: "Basic" ,
      iconMargin: EdgeInsets.only(bottom: 5),),
    Tab(
        icon: Icon(FontAwesomeIcons.magnifyingGlassChart),
        text: "Advanced",
        iconMargin: EdgeInsets.only(bottom: 5),)
  ];

  late TabController _tabController;

  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    _tabController = TabController(length: myTabs.length, vsync: this);
    super.initState();
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(screenName: "wearchart_bottomsheet");

    return Container(
      decoration: BoxDecoration(
        color: Colors.white38,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15),
      ),
      height: MediaQuery.of(context).size.height*0.8,
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text("Wear Chart Filters",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,),
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.gear),
                  onPressed: (){
                  Get.to(() => ChartOptions());
                  }),
            ],
          ),
          const Divider(thickness: 2,),
          SizedBox(
            height: 450,
            //width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                    labelColor: Theme.of(context).textTheme.bodyMedium!.color,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(50), // Creates border
                        color: Theme.of(context).highlightColor,),
                  tabs: myTabs
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: myTabs.map((Tab tab){
                      return Center(
                        child: tab.text == "Basic"? _buildBasicFilter(): _buildAdvancedFilter()
                      );
                    }).toList(),
                  ),
                )
              ],
            )
          )
          //Header#
          ]
      ),

    );
  }

  Widget _buildBasicFilter() {
    return SingleChildScrollView(
      child: Column(
        children: [

        ],
      ),
    );
  }

  Widget _buildAdvancedFilter() {
    return Center(
      child: Text("Page 2"),
    );
  }
}
