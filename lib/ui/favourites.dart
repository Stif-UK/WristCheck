import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/boxes.dart';
import 'package:get/get.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/ui/view_watch.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';

class Favourites extends StatefulWidget {
  Favourites({Key? key}) : super(key: key);

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  var watchBox = Boxes.getWatches();
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
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.favouritesPageBannerAdUnitId,
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
          title: const Text("Favourites"),

        ),
        body: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder<Box<Watches>>(
                  valueListenable: watchBox.listenable(),
                  builder: (context, box, _){
                    List<Watches> favourites = Boxes.getFavouriteWatches();



                    return favourites.isEmpty?Container(
                      alignment: Alignment.center,
                      child: const Text("Your watchbox has no favourites\n \n Mark watches as favourite to display in this filter",
                        textAlign: TextAlign.center,),
                    ):

                    ListView.separated(
                      itemCount: favourites.length,
                      itemBuilder: (BuildContext context, int index){
                        var watch = favourites.elementAt(index);
                        String? _title = "${watch.manufacturer} ${watch.model}";
                        bool fav = watch.favourite; // ?? false;
                        String? _status = "${watch.status}";


                        return ListTile(
                          leading: const Icon(Icons.watch),
                          title: Text(_title),
                          subtitle: Text(_status),
                          trailing:  fav? const Icon(Icons.star): const Icon(Icons.star_border),
                          onTap: () => Get.to(ViewWatch(currentWatch: watch,)),
                        );
                      },
                      separatorBuilder: (context, index){
                        return const Divider();
                      },
                    );
                  }


              ),
            ),
            purchaseStatus? const SizedBox(height: 0,) : AdWidgetHelper.buildSmallAdSpace(banner, context),
            const SizedBox(height: 50,)
          ],
        ),
    );
  }
}
