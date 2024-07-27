import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/dynamic_copy_helper.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/ui/watch/watchview.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';
import 'package:wristcheck/util/list_tile_helper.dart';
import 'package:get/get.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';



class ServicingWidget extends StatefulWidget {
  ServicingWidget({Key? key}) : super(key: key);
  final wristCheckController = Get.put(WristCheckController());


  @override
  State<ServicingWidget> createState() => _ServicingWidgetState();
}

class _ServicingWidgetState extends State<ServicingWidget> with SingleTickerProviderStateMixin{
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  final watchBox = Boxes.getWatches();
  BannerAd? banner;
  bool purchaseStatus = WristCheckPreferences.getAppPurchasedStatus() ?? false;

  //Set up tabbed view
  final List<Tab> myTabs = <Tab>[
    Tab(
      icon: Icon(FontAwesomeIcons.calendarDays),
      text: "Servicing" ,
      iconMargin: EdgeInsets.only(bottom: 5),),
    Tab(
      icon: Icon(FontAwesomeIcons.screwdriverWrench),
      text: "Warranty",
      iconMargin: EdgeInsets.only(bottom: 5),),
    Tab(
      icon: Icon(FontAwesomeIcons.question),
      text: "Help",
      iconMargin: EdgeInsets.only(bottom: 5),)
  ];

  late TabController _tabController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!purchaseStatus)
    {
      final adState = Provider.of<AdState>(context);
      adState.initialization.then((status) {
        setState(() {
          banner = BannerAd(
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.servicePageBannerAdUnitId,
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
    analytics.setCurrentScreen(screenName: "servicing");
    _tabController.index = widget.wristCheckController.lastServicingTabIndex.value;
    return Scaffold(
        body: Obx(
            ()=> Column(
              children:[
            widget.wristCheckController.isAppPro.value? const SizedBox(height: 0,) : AdWidgetHelper.buildSmallAdSpace(banner, context),
            TabBar(
              controller: _tabController,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              labelColor: Theme.of(context).textTheme.bodyMedium!.color,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50), // Creates border
                color: Theme.of(context).highlightColor,),
              tabs: myTabs,
              onTap: (index) async {
                widget.wristCheckController.updateLastServicingTabIndex(index);
                await analytics.logEvent(name: "chg_srv_tab",
                    parameters: {
                      "current_tab": index
                    });
              },
            ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: myTabs.map((Tab tab){
                      return Center(
                        child: ValueListenableBuilder<Box<Watches>>(
                            valueListenable: watchBox.listenable(),
                            builder: (context, box, _){
                              List<Watches> serviceList = widget.wristCheckController.lastServicingTabIndex.value == 0 ?
                              Boxes.getServiceSchedule() :
                              Boxes.getWarrantySchedule();

                              return serviceList.isEmpty ? Container(
                                alignment: Alignment.center,
                                // child: const Text("No Service schedules identified. \n\nEdit your watch info to track service timelines and last-serviced dates.",
                                //   textAlign: TextAlign.center,),
                                child: DynamicCopyHelper.getEmptyServiceText(widget.wristCheckController.lastServicingTabIndex.value, context),
                              ):

                              Column(
                                  children:[

                                    Expanded(
                                        child:ListView.separated(
                                          itemCount: serviceList.length,
                                          itemBuilder: (BuildContext context, int index){
                                            var watch = serviceList.elementAt(index);
                                            Widget returnWidget = Container();

                                            switch (widget.wristCheckController.lastServicingTabIndex.value){
                                              case 0:
                                                returnWidget = _getServicingListTile(watch);
                                                break;
                                              case 1:
                                                returnWidget = _getWarrantyListTile(watch);
                                                break;
                                              case 2:
                                                returnWidget = _getHelpPage(context, widget.wristCheckController.lastServicingTabIndex.value);
                                                break;
                                              default:
                                                returnWidget = _getServicingListTile(watch);
                                                break;
                                            }
                                            return returnWidget;

                                          },
                                          separatorBuilder: (context, index){
                                            return const Divider(thickness: 2,);
                                          },
                                        )
                                    ),
                                  ]
                              );
                            }
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 7,
                        child: const SizedBox(width: 0,)),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 25.0),
                        child: Container(
                            decoration: BoxDecoration(
                              //: Border.all(color: Colors.blue, width: 4),
                              color: Theme.of(context).buttonTheme.colorScheme?.primary,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(icon: Icon(Icons.calendar_month_sharp,
                              color: Colors.white, ),
                              onPressed: (){
                                widget.wristCheckController.updateCalendarOrService(true);
                                analytics.logEvent(name: "change_cal_view",
                                    parameters: {
                                      "open_cal": true
                                    });
                              },)),
                      ),
                    )
                  ],
                )
              ]
            )
        )

    );

  }
}

Widget _getHelpPage(BuildContext context, int index) {
  return Container(
    alignment: Alignment.center,
    child: DynamicCopyHelper.getEmptyServiceText(index, context)
  );
}

_getServicingListTile(Watches watch){
  String? _title = "${watch.manufacturer} ${watch.model}";
  
  return  ListTile(
    leading: ListTileHelper.getServicingIcon(watch.nextServiceDue!),
    title: Text(_title),
    subtitle: Text("Next Service by: ${DateFormat.yMMMd().format(watch.nextServiceDue!)}"),
    onTap: () => Get.to(()=>WatchView(currentWatch: watch,)),
  );
}

_getWarrantyListTile(Watches watch){
  String? _title = "${watch.manufacturer} ${watch.model}";

  return  ListTile(
    leading: Icon(FontAwesomeIcons.screwdriverWrench),//ListTileHelper.getServicingIcon(watch.nextServiceDue!),
    title: Text(_title),
    subtitle: Text("Warranty Expires on: ${WristCheckFormatter.getFormattedDateWithDay(watch.warrantyEndDate!)}"),
    onTap: () => Get.to(()=>WatchView(currentWatch: watch,)),
  );
}

