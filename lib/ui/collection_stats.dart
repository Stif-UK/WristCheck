import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/ui/collection_stats/collection_charts.dart';
import 'package:wristcheck/ui/collection_stats/collection_info.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/ui/collection_stats/value_data.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';


class CollectionStats extends StatefulWidget {
  const CollectionStats({Key? key}) : super(key: key);

  @override
  State<CollectionStats> createState() => _CollectionStatsState();
}

class _CollectionStatsState extends State<CollectionStats> {

  final wristCheckController = Get.put(WristCheckController());
  int _currentIndex = 0;
  final List<Widget> _children =[
    const CollectionCharts(),
    const CollectionInfo(),
    ValueData(),
  ];

  BannerAd? banner;
  bool purchaseStatus = WristCheckPreferences.getAppPurchasedStatus() ?? false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!purchaseStatus)
    {
      final adState = Provider.of<AdState>(context);
      adState.initialization.then((status) {
        setState(() {
          banner = BannerAd(
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.collectionStatsAdUnitID,
              //If the device screen is large enough display a larger ad on this screen
              size: AdSize.banner,
              request: const AdRequest(),
              listener: adState.adListener)
            ..load();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: const Text("Collection Stats"),
        actions: [
          IconButton(onPressed: (){WristCheckDialogs.getCollectionStatsDialog();}, icon: const Icon(Icons.help_outline))
        ],
      ),
      //Return children wrapped in a column to allow adspace to be included
      body: Obx(() => Column(
          children: [
            //Insert Ad Widget into tree
            wristCheckController.isAppPro.value? const SizedBox(height: 0,) : AdWidgetHelper.buildSmallAdSpace(banner, context),
            Expanded(child: _children[_currentIndex]),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon:  Icon(FontAwesomeIcons.chartBar),
            label: "Charts",
          ),
          BottomNavigationBarItem(
            icon:  Icon(FontAwesomeIcons.clipboardList),
            label: "Info",
          ),
          BottomNavigationBarItem(
            icon:  Icon(FontAwesomeIcons.moneyBillTrendUp),
            label: "Value Data",
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
