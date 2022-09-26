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

class SoldView extends StatefulWidget {
  const SoldView({Key? key}) : super(key: key);

  @override
  State<SoldView> createState() => _SoldViewState();
}

class _SoldViewState extends State<SoldView> {
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
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.soldPageBannerAdUnitId,
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
        title: const Text("Sold Watches"),

      ),
        body: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder<Box<Watches>>(
                  valueListenable: watchBox.listenable(),
                  builder: (context, box, _){
                    List<Watches> soldList = Boxes.getSoldWatches();



                    return soldList.isEmpty?Container(
                      alignment: Alignment.center,
                      child: const Text("No sold watches tracked\n \n Mark watches as 'sold' to populate this list",
                        textAlign: TextAlign.center,),
                    ):

                    ListView.separated(
                      itemCount: soldList.length,
                      itemBuilder: (BuildContext context, int index){
                        var watch = soldList.elementAt(index);
                        String? _title = "${watch.manufacturer} ${watch.model}";
                        String? _status = "${watch.status}";


                        return ListTile(
                          leading: const Icon(Icons.watch),
                          title: Text(_title),
                          subtitle: Text(_status),
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
        )
    );
  }
}
