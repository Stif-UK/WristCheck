import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/enums/collection_view.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/ui/search_finder.dart';
import 'package:wristcheck/ui/search_widget.dart';
import 'package:wristcheck/ui/view_watch.dart';
import 'package:wristcheck/ui/widgets/watchorder_bottomsheet.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';
import 'package:wristcheck/util/list_tile_helper.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class Watchbox extends StatefulWidget {
  Watchbox({Key? key}) : super(key: key);
  final wristCheckController = Get.put(WristCheckController());




  @override
  State<Watchbox> createState() => _WatchBoxState();
}



class _WatchBoxState extends State<Watchbox> {

  final items = CollectionView.values;
  CollectionView? collectionValue = CollectionView.all;

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
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.watchboxBannerAdUnitID,
              //If the device screen is large enough display a larger ad on this screen
              size: AdSize.banner,
              request: const AdRequest(),
              listener: adState.adListener)
            ..load();
        });
      });
    }
  }

  final watchBox = Boxes.getWatches();

  @override
  Widget build(BuildContext context) {

    //List to check if the notebook is 'empty'
    List<Watches> nonArchivedWatchList = watchBox.values.where((watch) => watch.status != "Archived").toList();

    return Obx( ()=> Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Insert Ad Widget into tree
          widget.wristCheckController.isAppPro.value? const SizedBox(height: 0,) : AdWidgetHelper.buildSmallAdSpace(banner, context),
          //Create drop down and search button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Obx(
                  ()=> Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).disabledColor,
                          width: 2
                        ),
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                    child: IconButton(
                      icon: ListTileHelper.getWatchOrderIcon(widget.wristCheckController.watchboxOrder.value),
                      onPressed: (){
                        //TODO: Implement Enums for order of list plus filters to affect returned lists
                        showModalBottomSheet(
                            context: context,
                            builder: (context){
                              return WatchOrderBottomSheet();
                            }
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).disabledColor,
                            width: 2
                        ),
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        //Text("Filter: "),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<CollectionView>(
                            items: items.map(buildMenuItem).toList(),
                            value: collectionValue,
                            onChanged: (value){
                              setState(() {
                                collectionValue = value;
                              });
                            },),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).disabledColor,
                          width: 2
                      ),
                      shape: BoxShape.rectangle,
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                  child: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: (){
                      showSearch(
                        context: context,
                        delegate: SearchWidget(),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          //Implement the watchbox view
          ValueListenableBuilder<Box<Watches>>(
              valueListenable: watchBox.listenable(),
              builder: (context, box, _){
                //List<Watches> filteredList = Boxes.getCollectionWatches();
                List<Watches> filteredList = Boxes.getWatchesByFilter(collectionValue!);



                return filteredList.isEmpty?Container(
                  alignment: Alignment.center,
                  child: const Text("Your watch-box is currently empty\n\nPress the red button to add watches to your collection\n",
                    textAlign: TextAlign.center,),
                ):

                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: filteredList.length,
                    itemBuilder: (BuildContext context, int index){
                      var watch = filteredList.elementAt(index);
                      String? _title = "${watch.manufacturer} ${watch.model}";
                      bool fav = watch.favourite; // ?? false;
                      String? _status = "${watch.status}";
                      int _wearCount = watch.wearList.length;



                      return ListTile(
                        leading: const Icon(Icons.watch),
                        title: Text(_title),
                        subtitle: Text(ListTileHelper.getWatchboxListSubtitle(watch)),
                        isThreeLine: true,

                        trailing:  InkWell(
                          child: fav? const Icon(Icons.star): const Icon(Icons.star_border),
                          onTap: () {
                            setState(() {
                              watch.favourite = !fav;
                              watch.save();
                            });
                          },
                        ),
                        onTap: () => Get.to(() => ViewWatch(currentWatch: watch,)),
                      );
                    },
                    separatorBuilder: (context, index){
                      return const Divider(thickness: 2,);
                    },
                  ),
                );
              }


          )

        ]

    ),
    );
  }

  DropdownMenuItem<CollectionView> buildMenuItem(CollectionView item) => DropdownMenuItem(
      value: item,
      child: Text(
        WristCheckFormatter.getCollectionText(item),
        style: Theme.of(context).textTheme.headlineSmall,
      )

  );
}
