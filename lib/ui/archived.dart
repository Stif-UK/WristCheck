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
import 'package:wristcheck/copy/snackbars.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';
import 'package:wristcheck/util/images_util.dart';

class Archived extends StatefulWidget {
  const Archived({Key? key}) : super(key: key);

  @override
  State<Archived> createState() => _ArchivedState();
}

class _ArchivedState extends State<Archived> {
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
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.archivePageBannerAdUnitId,
              //If the device screen is large enough display a larger ad on this screen
              size: AdSize.largeBanner,
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
        title: const Text("Archived Watches"),
        actions: [
          IconButton(
              icon: const Icon(Icons.help_outline),
            onPressed: (){
                WristCheckDialogs.getArchivedHelpDialog();
            } )
        ],

      ),
        body: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder<Box<Watches>>(
                  valueListenable: watchBox.listenable(),
                  builder: (context, box, _){
                    List<Watches> archiveList = Boxes.getArchivedWatches();



                    return archiveList.isEmpty?Container(
                      alignment: Alignment.center,
                      child: const Text("Your Archive is currently empty",
                        textAlign: TextAlign.center,),
                    ):

                    ListView.separated(
                      itemCount: archiveList.length,
                      itemBuilder: (BuildContext context, int index){
                        final item = archiveList[index].toString();
                        var watch = archiveList.elementAt(index);
                        String? _title = "${watch.manufacturer} ${watch.model}";
                        String? _status = "${watch.status}";


                        return Dismissible(
                          key: Key(item),
                          direction: DismissDirection.endToStart,

                          onDismissed: (direction) {
                            setState(() {
                              archiveList.removeAt(index);
                              var watchInfo = "${watch.manufacturer} ${watch.model}";
                              ImagesUtil.deleteImages(watch);
                              watchBox.delete(watch.key);
                              // Then show a snackbar.
                              WristCheckSnackBars.deleteWatch(watchInfo);
                            });

                          },

                          child: ListTile(
                            leading: const Icon(Icons.watch),
                            title: Text(_title),
                            subtitle: Text(_status),
                            onTap: () => Get.to(() => ViewWatch(currentWatch: watch,)),
                          ),

                          background: Container(
                          alignment: Alignment.center,color: Colors.red,
                          child: const Text("Deleting"),),
                        );
                      },
                      separatorBuilder: (context, index){
                        return const Divider();
                      },
                    );
                  }


              ),
            ),
            purchaseStatus? const SizedBox(height: 0,) : AdWidgetHelper.buildLargeAdSpace(banner, context),
            const SizedBox(height: 100,)
          ],
        )
    );
  }
}
