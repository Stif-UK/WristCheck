import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';
import 'package:wristcheck/util/list_tile_helper.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/view_watch.dart';
import 'package:wristcheck/copy/dialogs.dart';



class ServicingWidget extends StatefulWidget {
  ServicingWidget({Key? key}) : super(key: key);
  final wristCheckController = Get.put(WristCheckController());


  @override
  State<ServicingWidget> createState() => _ServicingWidgetState();
}

class _ServicingWidgetState extends State<ServicingWidget> {

  final watchBox = Boxes.getWatches();
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
  Widget build(BuildContext context) {
    return Scaffold(
        body: ValueListenableBuilder<Box<Watches>>(
            valueListenable: watchBox.listenable(),
            builder: (context, box, _){
              List<Watches> serviceList = Boxes.getServiceSchedule();



              return serviceList.isEmpty?Container(
                alignment: Alignment.center,
                child: const Text("No Service schedules identified. \n\nEdit your watch info to track service timelines and last-serviced dates.",
                  textAlign: TextAlign.center,),
              ):

              Obx(
                  () => Column(
                    children:[
                      Expanded(
                flex:1,
                    child: ListTile(
                      title: const Text("Service Schedule"),
                      leading: const Icon(Icons.schedule),
                      trailing: InkWell(
                          child: const Icon(Icons.help),
                        onTap: () => WristCheckDialogs.getServicePageTooltipDialog(),

                      ),
                    )

                ),
                      const Divider(
                        thickness: 2.0,
                      ),


                      Expanded(
                flex: 9,
                child:ListView.separated(
                itemCount: serviceList.length,
                itemBuilder: (BuildContext context, int index){
                var watch = serviceList.elementAt(index);
                String? _title = "${watch.manufacturer} ${watch.model}";


                return ListTile(
                leading: ListTileHelper.getServicingIcon(watch.nextServiceDue!),
                title: Text(_title),
                subtitle: Text("Next Service by: ${DateFormat.yMMMd().format(watch.nextServiceDue!)}"),
                onTap: () => Get.to(ViewWatch(currentWatch: watch,)),
                );
                },
                separatorBuilder: (context, index){
                return const Divider();
                },
                )
                ),
                      widget.wristCheckController.isAppPro.value? const SizedBox(height: 0,) : AdWidgetHelper.buildSmallAdSpace(banner, context),
                    ]
                    ),
              );
            }


        )

    );

  }
}

// Widget _buildAdSpace(BannerAd? banner, BuildContext context){
//   return banner == null
//       ? const SizedBox(height: 50,)
//       : SizedBox(
//     height: 50,
//     child: AdWidget(ad: banner!),
//   );
// }
